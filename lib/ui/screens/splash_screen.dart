import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/repositories/user_repository.dart';
import 'package:youbloom/ui/screens/login-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: AppColors.backGroundColor,
      duration: const Duration(seconds: 1),
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Assets.logo),
          SizedBox(height: 20.h),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            backgroundColor: AppColors.secondaryColor,
          ),
        ],
      ),
      onInit: () async {},
      onAnimationEnd: () async {
        final storage = new FlutterSecureStorage();
        String? token = await storage.read(key: 'accesstoken');
        // in case of real auth, check for existing token if not try to refresh if not possible, redirect to login screen
        if (token != null) {
          UserRepository().loadMe().then((value) {
            // if (user.id != null) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => const HomeScreen()),
            //   );
            // }
            // else {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => const LoginScreen()),
            //   );
            // }
          }).catchError((e) {
            Navigator.pushReplacementNamed(
              context,
              '/login',
            );
          });
        } else {
          Navigator.pushReplacementNamed(
            context,
           '/home',
          );
        }
      },

    );
  }
}
