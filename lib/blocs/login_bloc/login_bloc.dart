import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youbloom/const/globals.dart';
import 'package:youbloom/models/user.dart';
import 'package:youbloom/repositories/user_repository.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginBlocEvent, LoginState> {
  final UserRepository userRepository;
  LoginBloc(this.userRepository) : super(const AuthInitial()) {
    on<LoginRequested>(_onAuthLoginRequested);
    on<VerificationRequested>(_onVerificationRequested);
    on<ChangeStayConnected>(_onStayConnected);
  }

  void _onStayConnected(
    ChangeStayConnected event,
    Emitter<LoginState> emit,
  ) {
    emit(StayConnected(event.stayConnected));
  }

  void _onAuthLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final phone = event.phone;
      if (phone == "") {
        return emit(const AuthFailure("Phone number is required"));
      }
      final phoneRegex = RegExp(r'^\+?[0-9]{10,14}$');
      if (!phoneRegex.hasMatch(phone)) {
        return emit(const AuthFailure('Invalid phone number format!'));
      }
      currentUser = AppUser(phoneNumber: phone);
      return emit(const AuthSuccess());
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  void _onVerificationRequested(
      VerificationRequested event, Emitter<LoginState> emit) async {
    emit(AuthLoading());
   
    try {
      final code = event.code;
      if (code == "") {
        return emit(const AuthFailure("Code is required"));
      }
      final cred = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: code);

      await FirebaseAuth.instance.signInWithCredential(cred);
      return emit(const AuthSuccess());
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
    
  }
}
