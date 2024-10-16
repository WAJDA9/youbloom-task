import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youbloom/blocs/login_bloc/login_bloc.dart';
import 'package:youbloom/const/assets.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';
import 'package:youbloom/ui/screens/code_verification_screen.dart';
import 'package:youbloom/ui/widgets/fields/button_widget.dart';
import 'package:youbloom/ui/widgets/fields/country_code.dart';
import 'package:youbloom/ui/widgets/fields/input_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _stayConnected = false;
  final countryCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                content: Text(state.error),
                backgroundColor: const Color.fromARGB(175, 244, 67, 54),
              ),
            );
          } else if (state is AuthSuccess) {
            final fullPhoneNumber =
                '+${countryCodeController.text}${phoneNumberController.text}';
            try {
              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: fullPhoneNumber,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  FirebaseAuth.instance.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    throw Exception('The provided phone number is not valid.');
                  }
                },
                codeSent: (String verificationId, int? resendToken) async {
                  Navigator.pushNamed(context, '/code_verification',
                      arguments: verificationId);
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                  ),
                  content: Text(e.toString()),
                  backgroundColor: const Color.fromARGB(175, 244, 67, 54),
                ),
              );
            }
          } else if (state is StayConnected) {
            setState(() {
              _stayConnected = state.stayConnected;
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            print("loading");
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                backgroundColor: AppColors.secondaryColor,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h, child: Image.asset(Assets.logo)),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.infoText.copyWith(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CountryCodeField(
                                  controller: countryCodeController,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 5,
                                child: TextFieldWidget(
                                  hintText: "Phone Number",
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.primaryColor,
                                    value: _stayConnected,
                                    onChanged: (bool? value) {
                                      context.read<LoginBloc>().add(
                                            ChangeStayConnected(value!),
                                          );
                                    },
                                  ),
                                  Text(
                                    'Stay connected',
                                    style: AppTextStyle.infoText.copyWith(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ButtonWidget(
                              buttonText: "Sign in",
                              onClick: () {
                                final fullPhoneNumber =
                                    '+${countryCodeController.text}${phoneNumberController.text}';
                                context.read<LoginBloc>().add(
                                      LoginRequested(
                                        phone: fullPhoneNumber,
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
