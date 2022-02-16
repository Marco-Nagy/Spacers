import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());
  late String verificationId;

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await signin(credential);
    print(verificationCompleted);
  }

  Future<void> signin(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerified());
    } catch (error) {
      emit(Error(error.toString()));
    }
  }

  void verificationFailed(FirebaseAuthException error) {
    print(error.toString());
    emit(Error(error.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print(codeSent);
    this.verificationId = verificationId;
    emit(PhoneNumberSubmitted());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print(codeAutoRetrievalTimeout);
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: this.verificationId,
      smsCode: otpCode,
    );
    await signin(credential);
  }

  Future<void> logout()async{
    await FirebaseAuth.instance.signOut();
  }
}
