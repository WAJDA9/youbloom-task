import 'package:youbloom/const/globals.dart';
import 'package:youbloom/const/urls.dart';
import 'package:youbloom/models/person.dart';
import 'package:youbloom/services/api_service.dart';

class PeopleRepository {
  Future<void> FetchPeople() async {
    final response = await ApiService.get(
      endPoint: AppUrls.people,
    );
    for (var element in (response["results"] as List)) {
      print(Person.fromJson(element).hairColor);
      people.add(Person.fromJson(element));
    }
  }
}
