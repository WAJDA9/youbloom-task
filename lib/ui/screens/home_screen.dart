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
  List<Person> _filteredPeople = [];

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

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterPeople(String query) {
    final homePageState = context.read<HomePageBloc>().state;
    if (homePageState is DataLoaded) {
      setState(() {
        _filteredPeople = homePageState.people
            .where((person) =>
                person.name?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      });
    }
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPeople,
              decoration: InputDecoration(
                hintText: 'Search by name',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
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
          } else if (state is DataLoaded) {
            _filterPeople(_searchController.text);
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
            final displayedPeople =
                _searchController.text.isEmpty ? state.people : _filteredPeople;

            if (displayedPeople.isEmpty) {
              return const Center(
                child: Text("No people found"),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8),
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: displayedPeople.length +
                    (state.hasReachedMax || _searchController.text.isNotEmpty
                        ? 0
                        : 1),
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  if (index < displayedPeople.length) {
                    final person = displayedPeople[index];
                    return _buildpersonCard(person);
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
