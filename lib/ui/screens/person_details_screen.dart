import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';
import 'package:youbloom/models/person.dart';

class GalacticProfileScreen extends StatelessWidget {
  final Person person;

  const GalacticProfileScreen({Key? key, required this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simple pattern background
          CustomPaint(
            painter: SimplePatternPainter(),
            child: Container(
              width: size.width,
              height: size.height,
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  _buildProfileImage(),
                  SizedBox(height: 20.h),
                  _buildNamePlate(),
                  SizedBox(height: 30.h),
                  _buildInfoCard(
                      'Gender', person.gender.toString().split(".")[1]),
                  SizedBox(height: 10.h),
                  _buildInfoCard('Eye Color', person.eyeColor ?? 'Unknown'),
                  SizedBox(height: 10.h),
                  _buildInfoCard('Hair Color', person.hairColor ?? 'Unknown'),
                  SizedBox(height: 10.h),
                  _buildInfoCard('Skin Color', person.skinColor ?? 'Unknown'),
                  SizedBox(height: 30.h),
                  _buildInteractiveFeature(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Hero(
      tag: 'profile_${person.name}',
      child: CircleAvatar(
        radius: 60.w,
        backgroundImage: person.skinColor!.toUpperCase().contains("WHITE")
            ? const AssetImage(Assets.trooper)
            : const AssetImage(Assets.vader),
        backgroundColor: AppColors.primaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNamePlate() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Text(
        person.name ?? 'Unknown',
        style: AppTextStyle.titleText.copyWith(
          color: Colors.white,
          fontSize: 24.sp,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.descText.copyWith(
              color: Colors.white70,
              fontSize: 16.sp,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.descText.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFeature(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: const Text('Galactic Fact', style: TextStyle(color: Colors.white)),
            content: Text(
              'Did you know? If ${person.name} were a star, they would be a ${_getStarType()}!',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cool!',
                    style: TextStyle(color: AppColors.primaryColor)),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Text(
          'Discover Galactic Fact',
          style: AppTextStyle.descText.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  String _getStarType() {
    final types = [
      'Red Dwarf',
      'Yellow Dwarf',
      'Blue Giant',
      'White Dwarf',
      'Neutron Star'
    ];
    return types[DateTime.now().microsecond % types.length];
  }
}

class SimplePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    double spacing = 20;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
    for (int i = 0; i < 50; i++) {
      double x = (DateTime.now().millisecond * i) % size.width;
      double y = (DateTime.now().microsecond * i) % size.height;
      canvas.drawCircle(Offset(x, y), 1, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
