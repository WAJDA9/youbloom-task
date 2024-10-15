import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/globals.dart';
import 'package:youbloom/const/text.dart';
import 'package:youbloom/models/person.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomePageBloc>().add(FetchHomeScreenData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        print(people.length);
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: CustomPaint(
              painter: StarryBackgroundPainter(),
              child: Container(),
            ),
            title: Text(
              'People',
              style: AppTextStyle.titleText.copyWith(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      return _buildpersonCard(people[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Widget _buildpersonCard(Person person) {
    return Card(
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: const Color(0xFFDFF8FF), width: 1.w),
        borderRadius: BorderRadius.circular(16.w),
      ),
      elevation: 5.h,
      shadowColor: AppColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.w,
              backgroundImage: person.skinColor!.toUpperCase().contains("WHITE")
                  ? const AssetImage(Assets.trooper)
                  : const AssetImage(Assets.vader),
              backgroundColor: AppColors.primaryColor.withOpacity(0.5),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: AppTextStyle.descText.copyWith(
                      color: const Color(0xff232323),
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    '${person.name}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff718EBF),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Gender',
                    style: AppTextStyle.descText.copyWith(
                      color: const Color(0xff232323),
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    person.gender.toString().split(".")[1],
                    style: AppTextStyle.descText.copyWith(
                      color: const Color(0XFFA0A0A0),
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/details_screen',
                    arguments: person);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: const Color(0xFF718EBF), width: 1.w),
                  borderRadius: BorderRadius.circular(50.w),
                ),
              ),
              child: Text(
                'More Details',
                style: AppTextStyle.descText.copyWith(
                  color: const Color(0xff718EBF),
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = Random();

   
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    
    for (int i = 0; i < 100; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius = random.nextDouble() * 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}