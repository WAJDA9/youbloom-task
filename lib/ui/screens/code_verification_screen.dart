import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/blocs/login_bloc/login_bloc.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/globals.dart';
import 'package:youbloom/ui/widgets/fields/button_widget.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String verificationId;
  const CodeVerificationScreen({super.key, required this.verificationId});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backGroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.sp),
                    topRight: Radius.circular(10.sp),
                  ),
                ),
                content: Text(state.error),
                backgroundColor: const Color.fromARGB(175, 244, 67, 54),
              ),
            );
          } else if (state is AuthSuccess) {
            
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                backgroundColor: AppColors.secondaryColor,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Enter Verification Code",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            "Enter the code we sent you to your phone number ",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      TextSpan(
                        text: "${currentUser.phoneNumber}",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      filled: true,
                      fillColor: AppColors.fieldsColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primaryColor),
                      ),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    controller: codeController,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonWidget(
                      onClick: () async {
                        BlocProvider.of<LoginBloc>(context).add(
                            VerificationRequested(
                                codeController.text, widget.verificationId));
                      },
                      buttonText: "Verify",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
