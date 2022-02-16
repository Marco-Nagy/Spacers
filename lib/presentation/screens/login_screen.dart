import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacers/business_logic/authentication/phone_auth_cubit.dart';
import 'package:spacers/constants/strings.dart';

import '../../constants/colors.dart';
import '../wedigts/show_progress_indecator.dart';
import '../wedigts/widgits.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _phoneFormKey = GlobalKey();
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var query = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Container(
              color: Colors.grey[200],
              height: query.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/spacer.jpeg",
                      height: query.height * .45,
                      colorBlendMode: BlendMode.hardLight),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Container(
                      width: query.width * .75,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Form(
                          key: _phoneFormKey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your phone",
                                suffixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                  ),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number!';
                              } else if (value.length < 11) {
                                return 'Too short for a phone number!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phoneNumber = value!;
                            },
                            maxLines: 1,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: defaultButton(
                      function: () {
                        // Navigator.of(context).pushNamed(otp);
                        showProgressIndicator(context);
                        _register(context);
                      },
                      text: 'Verified my phone',
                      background: purple,
                      width: query.width * 0.45,
                    ),
                  ),
                  const Center(
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 20,
                        color: purple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: Row(
                            children: [
                              const Text(
                                "login with ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                "assets/images/google.jpeg",
                                height: 25,
                                width: 25,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              const Text(
                                "login with ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                "assets/images/face.jpeg",
                                height: 25,
                                width: 25,
                              ),
                            ],
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildPhoneNumSubmittedBloc(),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();

      // Dah El Object Bta3 El Cubit
      BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phoneNumber);
    }
  }

  Widget _buildPhoneNumSubmittedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is PhoneNumberSubmitted) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            otp,
            arguments: phoneNumber,
          );
        }
        if (state is Error) {
          Navigator.pop(context);
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
      child: Container(),
    );
  }
}
