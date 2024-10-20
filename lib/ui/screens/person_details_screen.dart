import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/blocs/details_page_bloc/details_page_bloc.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';
import 'package:youbloom/models/person.dart';

class GalacticProfileScreen extends StatelessWidget {
  final Person person;

  const GalacticProfileScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsPageBloc()..add(LoadPersonDetails(person)),
      child: BlocBuilder<DetailsPageBloc, DetailsPageState>(
        builder: (context, state) {
          if (state is DetailsPageLoaded) {
            return _buildContent(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DetailsPageLoaded state) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            painter: SimplePatternPainter(),
            child: SizedBox(
              width: size.width,
              height: size.height,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  _buildProfileImage(state.person),
                  SizedBox(height: 20.h),
                  _buildNamePlate(state.person),
                  SizedBox(height: 30.h),
                  _buildInfoCard('Gender', state.person.gender ?? 'Unknown'),
                  SizedBox(height: 10.h),
                  _buildInfoCard(
                      'Eye Color', state.person.eyeColor ?? 'Unknown'),
                  SizedBox(height: 10.h),
                  _buildInfoCard(
                      'Hair Color', state.person.hairColor ?? 'Unknown'),
                  SizedBox(height: 10.h),
                  _buildInfoCard(
                      'Skin Color', state.person.skinColor ?? 'Unknown'),
                  SizedBox(height: 30.h),
                  _buildInteractiveFeature(context, state),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            left: 20.w,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileImage(Person person) {
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

Widget _buildNamePlate(Person person) {
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

Widget _buildInteractiveFeature(BuildContext context, DetailsPageLoaded state) {
  return GestureDetector(
    onTap: () {
      context.read<DetailsPageBloc>().add(GenerateGalacticFact());
    },
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color.fromARGB(255, 205, 205, 205).withOpacity(0.8),
                title: const Text('Galactic Fact',
                    style: TextStyle(color: AppColors.primaryColor)),
                content: Text(
                  'Did you know? If ${state.person.name} were a star, they would be a ${_getStarType()}!',
                  style: const TextStyle(color: Colors.black87),
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
          child: Text(
            'Discover Galactic Fact',
            style: AppTextStyle.descText.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        )),
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
