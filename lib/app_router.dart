import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacers/business_logic/authentication/phone_auth_cubit.dart';
import 'package:spacers/presentation/screens/home_screen.dart';
import 'package:spacers/presentation/screens/login_screen.dart';
import 'package:spacers/presentation/screens/otp_screen.dart';
import 'constants/strings.dart';


class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) =>
        BlocProvider<PhoneAuthCubit>.value(
          value: phoneAuthCubit!,
          child:  LoginScreen(),
        ));
      case otp:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: OtpScreen(phoneNumber: phoneNumber),
                ));
      case home:
        return MaterialPageRoute(builder: (_) =>const HomeScreen());

    }
  }

}