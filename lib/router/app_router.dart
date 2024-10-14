import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:youbloom/ui/screens/home_screen.dart';
import 'package:youbloom/ui/screens/login-screen.dart';
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
          builder: (_) =>  LoginScreen(),
        );
      case '/home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      HomePageBloc(),
                        //..add(FetchHomeScreenData()),
                  child: const HomeScreen(),
                ));
    }

    return null;
  }
}
