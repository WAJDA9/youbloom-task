import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/blocs/details_page_bloc/details_page_bloc.dart';
import 'package:youbloom/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:youbloom/models/person.dart';
import 'package:youbloom/ui/screens/code_verification_screen.dart';
import 'package:youbloom/ui/screens/home_screen.dart';
import 'package:youbloom/ui/screens/login-screen.dart';
import 'package:youbloom/ui/screens/person_details_screen.dart';
import 'package:youbloom/ui/screens/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomePageBloc(),
                  child: const HomeScreen(),
                ));
      case '/details_screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => DetailsPageBloc(),
            child:  GalacticProfileScreen(
              person: settings.arguments as Person, 
            ),
          ),
        );
      case '/code_verification':
        return MaterialPageRoute(
          builder: (_) => CodeVerificationScreen(
            verificationId: settings.arguments as String,
          ),
        );
    }

    return null;
  }
}
