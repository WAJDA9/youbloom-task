import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/blocs/login_bloc/login_bloc.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/firebase_options.dart';
import 'package:youbloom/repositories/user_repository.dart';
import 'package:youbloom/router/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _router;
  @override
  void initState() {
    _router = AppRouter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size sc = MediaQuery.of(context).size;

    return ScreenUtilInit(
      designSize: Size(sc.width, sc.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return SafeArea(
          child: BlocProvider(
            create: (context) => LoginBloc(UserRepository()),
            child: MaterialApp(
              color: AppColors.primaryColor,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android:
                        NoTransitionPageTransitionsBuilder(),
                    TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
                  },
                ),
                scaffoldBackgroundColor: AppColors.backGroundColor,
              ),
              title: 'Youbloom App',
              onGenerateRoute: _router.onGenerateRoute,
            ),
          ),
        );
      },
    );
  }
}

class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // No transition effect, just return the child widget
    return child;
  }
}
