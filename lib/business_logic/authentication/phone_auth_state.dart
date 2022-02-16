part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}
class Loading extends PhoneAuthState {}
class Error extends PhoneAuthState {
  final String errorMessage;

  Error(this.errorMessage);
}
class PhoneNumberSubmitted extends PhoneAuthState {}
class PhoneOtpVerified extends PhoneAuthState {}

