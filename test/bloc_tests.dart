import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:youbloom/blocs/details_page_bloc/details_page_bloc.dart';
import 'package:youbloom/blocs/login_bloc/login_bloc.dart';
import 'package:youbloom/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:youbloom/repositories/user_repository.dart';
import 'package:youbloom/repositories/people_repository.dart';
import 'package:youbloom/models/person.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockPeopleRepository extends Mock implements PeopleRepository {}

void main() {
  group('LoginBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    blocTest<LoginBloc, LoginState>(
      'emits [AuthLoading, AuthSuccess] when LoginRequested is added with valid phone number',
      build: () => LoginBloc(userRepository),
      act: (bloc) => bloc.add(LoginRequested(phone: '+1234567890')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [AuthLoading, AuthFailure] when LoginRequested is added with invalid phone number',
      build: () => LoginBloc(userRepository),
      act: (bloc) => bloc.add(LoginRequested(phone: 'invalid')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [AuthLoading, AuthFailure] when LoginRequested is added with empty phone number',
      build: () => LoginBloc(userRepository),
      act: (bloc) => bloc.add(LoginRequested(phone: '')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [StayConnected] when ChangeStayConnected is added',
      build: () => LoginBloc(userRepository),
      act: (bloc) => bloc.add(ChangeStayConnected(true)),
      expect: () => [
        isA<StayConnected>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [AuthLoading, AuthSuccess] when VerificationRequested is added with valid code',
      build: () => LoginBloc(userRepository),
      act: (bloc) =>
          bloc.add(VerificationRequested('123456', 'verificationId')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [AuthLoading, AuthFailure] when VerificationRequested is added with empty code',
      build: () => LoginBloc(userRepository),
      act: (bloc) => bloc.add(VerificationRequested('', 'verificationId')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );
  });

  group('HomePageBloc', () {
    late PeopleRepository peopleRepository;

    setUp(() {
      peopleRepository = MockPeopleRepository();
    });

    final mockPeopleResults = PeopleResponse(
      count: 20,
      next: 'next_url',
      previous: null,
      results: List.generate(10, (index) => Person(name: 'Person $index')),
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits [HomePageLoading, DataLoaded] when FetchHomeScreenData is added for initial fetch',
      build: () {
        when(() => peopleRepository.fetchPeople(page: 1))
            .thenAnswer((_) async => mockPeopleResults);
        return HomePageBloc();
      },
      act: (bloc) => bloc.add(FetchHomeScreenData(isInitialFetch: true)),
      expect: () => [
        isA<HomePageLoading>(),
        isA<DataLoaded>(),
      ],
      verify: (bloc) {
        verify(() => peopleRepository.fetchPeople(page: 1)).called(1);
        expect(bloc.currentPage, 2);
        expect(bloc.state.people.length, 10);
        expect(bloc.state.hasReachedMax, false);
      },
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits [HomePageLoading, DataLoaded] when FetchHomeScreenData is added for subsequent fetch',
      build: () {
        when(() => peopleRepository.fetchPeople(page: any(named: 'page')))
            .thenAnswer((_) async => mockPeopleResults);
        return HomePageBloc();
      },
      seed: () =>
          DataLoaded(people: mockPeopleResults.results, hasReachedMax: false),
      act: (bloc) => bloc.add(FetchHomeScreenData(isInitialFetch: false)),
      expect: () => [
        isA<HomePageLoading>(),
        isA<DataLoaded>(),
      ],
      verify: (bloc) {
        verify(() => peopleRepository.fetchPeople(page: 2)).called(1);
        expect(bloc.currentPage, 3);
        expect(bloc.state.people.length, 20);
        expect(bloc.state.hasReachedMax, true);
      },
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits [HomePageError] when FetchHomeScreenData fails',
      build: () {
        when(() => peopleRepository.fetchPeople(page: any(named: 'page')))
            .thenThrow(Exception('Failed to fetch people'));
        return HomePageBloc();
      },
      act: (bloc) => bloc.add(FetchHomeScreenData(isInitialFetch: true)),
      expect: () => [
        isA<HomePageLoading>(),
        isA<HomePageError>(),
      ],
    );
  });
  group('DetailsPageBloc', () {
    final mockPerson = Person(
      name: 'Luke Skywalker',
      gender: 'male',
      eyeColor: 'blue',
      hairColor: 'blond',
      skinColor: 'fair',
    );

    blocTest<DetailsPageBloc, DetailsPageState>(
      'emits [DetailsPageLoaded] when LoadPersonDetails is added',
      build: () => DetailsPageBloc(),
      act: (bloc) => bloc.add(LoadPersonDetails(mockPerson)),
      expect: () => [
        isA<DetailsPageLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as DetailsPageLoaded;
        expect(state.person, mockPerson);
        expect(state.galacticFact, isNull);
      },
    );

    blocTest<DetailsPageBloc, DetailsPageState>(
      'emits [DetailsPageLoaded] with galactic fact when GenerateGalacticFact is added',
      build: () => DetailsPageBloc(),
      seed: () => DetailsPageLoaded(mockPerson),
      act: (bloc) => bloc.add(GenerateGalacticFact()),
      expect: () => [
        isA<DetailsPageLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as DetailsPageLoaded;
        expect(state.person, mockPerson);
        expect(state.galacticFact, isNotNull);
        expect(state.galacticFact,
            contains('If Luke Skywalker were a star, they would be a'));
      },
    );

    blocTest<DetailsPageBloc, DetailsPageState>(
      'does not emit a new state when GenerateGalacticFact is added in DetailsPageInitial state',
      build: () => DetailsPageBloc(),
      act: (bloc) => bloc.add(GenerateGalacticFact()),
      expect: () => [],
    );
  });
}
