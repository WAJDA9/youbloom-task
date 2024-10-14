part of 'login_bloc.dart';

@immutable
sealed class LoginBlocEvent {}

final class LoginRequested extends LoginBlocEvent {
  final String phone;

  LoginRequested({
    required this.phone,
  });
}

final class LogoutRequested extends LoginBlocEvent {}

final class ChangeStayConnected extends LoginBlocEvent {
  final bool stayConnected;
  ChangeStayConnected(this.stayConnected);
}

final class ChangePasswordShown extends LoginBlocEvent {
  final bool showPassword;
  ChangePasswordShown(this.showPassword);
}

final class VerificationRequested extends LoginBlocEvent{
  final String code;
  final String verificationId;
  VerificationRequested(this.code, this.verificationId);
}