import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spacers/business_logic/authentication/phone_auth_cubit.dart';

import '../../../constants/colors.dart';
import '../../constants/strings.dart';
import '../wedigts/show_progress_indecator.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final phoneNumber;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  late String otpCode;



  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: height,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
                  child: Column(
                    children: [
                      _buildIntroTexts(),
                      const SizedBox(
                        height: 88,
                      ),
                      _buildPinCodeFields(context),
                      const SizedBox(
                        height: 60,
                      ),
                      _buildVrifyButton(context),
                      _verificationSubmiteOTP()
                      // _buildPhoneVerificationBloc(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
              text: 'Enter your 6 digit code numbers sent to ',
              style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.4),
              children: <TextSpan>[
                TextSpan(
                  text: '$phoneNumber',
                  style: const TextStyle(color: purple),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: purple,
          inactiveColor: purple,
          inactiveFillColor: Colors.transparent,
          activeFillColor: purple,
          selectedColor: purple,
          selectedFillColor: Colors.white,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        onCompleted: (submitedCode) {
          otpCode = submitedCode;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  void login(BuildContext context) {
    BlocProvider.of<PhoneAuthCubit>(context).submitOTP(otpCode);
  }

  Widget _buildVrifyButton(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);

          login(context);
        },
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width * 0.13, height * 0.07),
          primary: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _verificationSubmiteOTP() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is PhoneOtpVerified) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            home,
            arguments: phoneNumber,
          );
        }
        if (state is Error) {
          String errorMsg = state.errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      listenWhen: (previous, current) {
        return previous != current;
      },
      child: Container(),
    );
  }
}
