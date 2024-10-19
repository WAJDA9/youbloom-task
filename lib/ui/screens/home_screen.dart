import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';
import 'package:youbloom/models/person.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    context.read<HomePageBloc>().add(FetchHomeScreenData());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !context.read<HomePageBloc>().state.hasReachedMax &&
          context.read<HomePageBloc>().state is! HomePageLoading) {
        
        context
            .read<HomePageBloc>()
            .add(FetchHomeScreenData(isInitialFetch: false));
      }
    });

    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      context
          .read<HomePageBloc>()
          .add(FetchHomeScreenData(isInitialFetch: true, searchQuery: query));
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<HomePageBloc, HomePageState>(
        listener: (context, state) {
          if (state is HomePageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomePageLoading && state.people.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                backgroundColor: AppColors.secondaryColor,
              ),
            );
          } else if (state is DataLoaded ||
              (state is HomePageLoading && state.people.isNotEmpty)) {
            if (state.people.isEmpty) {
              return const Center(
                child: Text("No people found"),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8),
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: state.hasReachedMax
                    ? state.people.length
                    : state.people.length + 1,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  if (index < state.people.length) {
                    final player = state.people[index];
                    return _buildpersonCard(player);
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor),
                          backgroundColor: AppColors.secondaryColor,
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          } else if (state is HomePageError) {
            return Center(
              child: Text("Failed to load people: ${state.error}"),
            );
          } else {
            return const Center(
              child: Text("No people available"),
            );
          }
        },
      ),
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
                    person.gender ?? 'Unknown',
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
