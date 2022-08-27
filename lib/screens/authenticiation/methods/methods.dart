import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_otp_verification.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_verification_animatedbutton_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  static void emailVerified(
      {required BuildContext context,
      required PageController pageController,
      required MailLoadingProvider mailLoadingProvider,
      required EmailVerificationAnimatedButtonProvider buttonProvider}) {
    final otpControllerProvider = Provider.of<EmailOtpVerification>(context, listen: false);
    print('truth');
    Provider.of<VerificationTruthProvider>(context, listen: false).changeEmailVerificationTruth(true);
    mailLoadingProvider.changeIndex(1);
    pageController.animateToPage(2, duration: lPageControllerDuration, curve: lPageControllerCurve);
    otpControllerProvider.clearOtpController();
    buttonProvider.changeAnimationStatus(false);
  }
  // static void bottomMessage(AnimationController _animationController,String message,
  //     AuthenticationMessageProvider messageProvider)async{
  //
  //   if(_animationController.status == AnimationStatus.dismissed){
  //     messageProvider.changeMessage(message);
  //     _animationController.forward();
  //     await Future.delayed(Duration(seconds: 2));
  //     _animationController.reverse();
  //   }
  // }

}
