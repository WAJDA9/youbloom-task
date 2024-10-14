part of 'login_bloc.dart';

@immutable
class LoginState {
  const LoginState();
}

final class AuthInitial extends LoginState {
  const AuthInitial();
}

final class AuthSuccess extends LoginState {
  const AuthSuccess();
}

// State when authentication fails
final class AuthFailure extends LoginState {
  final String error;

  const AuthFailure(this.error);
}

// State when authentication is in progress
final class AuthLoading extends LoginState {}

// State for "stay connected" checkbox
final class StayConnected extends LoginState {
  final bool stayConnected;

  const StayConnected(this.stayConnected);
}

// State for showing/hiding password
final class PasswordShown extends LoginState {
  final bool showPassword;

  const PasswordShown(this.showPassword);
}

final class VerificationSuccess extends LoginState {
  final String verificationId;
  

  const VerificationSuccess(this.verificationId);
}