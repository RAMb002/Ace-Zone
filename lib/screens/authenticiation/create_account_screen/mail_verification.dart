import 'dart:convert';
import 'dart:math';

import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/auth.config.dart';
import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_otp_verification.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_verification_animatedbutton_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/pagecontroller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/my_provider/loading_provider.dart';
import 'package:chadate_alpha/screens/authenticiation/methods/methods.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:chadate_alpha/services/email_otp_service.dart';
import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class MailVerificationScreen extends StatefulWidget {
  const MailVerificationScreen({required this.pageController,Key? key}) : super(key: key);

  final PageController pageController;

  @override
  _MailVerificationScreenState createState() => _MailVerificationScreenState();
}

class _MailVerificationScreenState extends State<MailVerificationScreen> with TickerProviderStateMixin {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final _formKeyOtp = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation animation;
  // late AnimationController _buttonColorAnimationController;
  // late Animation<Color?> _buttonColorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(code);
    // sendOtp();
    // launchEmail(toEmail: 'ram300501@gmail.com', subject: 'test', message: 'hi');
    // sendEmail(name: 'ram', email: 'ram300501@gmail.com', subject: 'this is a test', message: 'sucess');
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // _buttonColorAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    //
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    // _buttonColorAnimation = ColorTween(begin: Colors.lightBlueAccent, end: Colors.red).animate(_buttonColorAnimationController)
    // ..addListener(() {
    //   setState(() {
    //
    //   });
    // });
  }

  // void sendOtp() async {
  //   print('otp method');
  //   EmailAuth emailAuth = new EmailAuth(
  //     sessionName: "Sample session",
  //   );
  //   // await emailAuth.config(data)
  //   // FirebaseAuth.instance.currentUser.
  //   await emailAuth.config({"server": "https://letsgo823.herokuapp.com", "serverKey": "bggthgff"});
  //   bool result = await emailAuth.sendOtp(recipientMail: 'rambo300502@gmail.com', otpLength: 5);
  //   print(result);
  //   // bool result = await emailAuth.sendOtp(recipientMail: 'ram300501@gmail.com', otpLength: 5);
  //   // if (result) {
  //   //   print(result);
  //   //   // using a void function because i am using a
  //   //   // stateful widget and seting the state from here.
  //   //   // setState(() {
  //   //   //   submitValid = true;
  //   //   // });
  //   // }
  // }

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    // _emailController.dispose();
    // _passwordController.dispose();
    // _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.black12,
        // border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.red,
      borderRadius: BorderRadius.circular(20),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Colors.black54,
      // border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.black,
      ),
    );

    final _loadingProvider = Provider.of<MailLoadingProvider>(context, listen: false);
    final _buttonAnimationProvider =
        Provider.of<EmailVerificationAnimatedButtonProvider>(context, listen: false);
    final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);

    final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);

    return Scaffold(
      body: WillPopScope(
        onWillPop: ()async{
          if(_buttonAnimationProvider.status){
            _buttonAnimationProvider.changeAnimationStatus(false);
            return true;
          }
          return true;
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            GestureDetector(
              onPanUpdate: (details){
                print("pan");
                if (details.delta.dx < 0) {
                  print("swipe right");
                  final pLoadingIndex =Provider.of<MailLoadingProvider>(context,listen: false);
                  if(pVerificationTruth.emailVerificationTruth || pLoadingIndex.loadingIndex==1) {
                    swipeNextPage(context);
                  }
                }
                else if(details.delta.dx > 0){
                  print("swipe left");
                  widget.pageController.animateToPage(0,duration: lPageControllerDuration, curve: lPageControllerCurve);


                }
              },
              child: Container(
                padding: lPaddingFirstContainer,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 25),
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            ' E-mail Verification',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Consumer<EmailControllerProvider>(
                            builder: (context,emailController,child)=>
                             MyTextFormField(
                                keyboardType: TextInputType.emailAddress,
                                labelText: "Email",
                                lineColorWhite: false,
                                hintText: 'Enter your mail id',
                                controller: emailController.emailController,
                                email: true,
                                validator: (email) {
                                  if (email != null && !EmailValidator.validate(email)) {
                                    return "Enter a valid Email";
                                  } else
                                    return null;
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // Consumer<PasswordVisibilityProvider>(
                        //   builder: (context, data, child) => MyTextFormField(
                        //       lineColorWhite: false,
                        //       controller: _passwordController,
                        //       hintText: 'Enter the password',
                        //       labelText: "Password",
                        //       keyboardType: TextInputType.emailAddress,
                        //       password: !data.getPasswordVisibility,
                        //       passwordIcon: true,
                        //       passwordVisibility: data.getPasswordVisibility,
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return "This Field cannot be empty";
                        //         } else
                        //           return null;
                        //       }),
                        // ),
                        SizedBox(
                          height: 0,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              color: Colors.transparent,
                            ),
                            Consumer<EmailOtpVerification>(
                              builder: (context, data, child) => Pinput(
                                  controller: data.otpController,
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  // errorPinTheme: _buttonAnimationProvider.status ?
                                  // defaultPinTheme.copyDecorationWith(
                                  //   color: data.otpController.text.length ==6  ? Colors.red : Colors.black12,
                                  //   borderRadius: BorderRadius.circular(20),
                                  // ) : null,
                                  // pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                  focusedPinTheme: focusedPinTheme,

                                  submittedPinTheme: submittedPinTheme,
                                  // errorTextStyle: data.otpController.text.length ==6
                                  //     ? null
                                  //     : TextStyle(height: 0, color: Colors.white),
                                  validator: (s) {
                                    print('validator');
                                    // bool emailOtpValidation = emailAuth.validateOtp(
                                    //     recipientMail: _emailController.value.text,
                                    //     userOtp: _otpController.value.text);
                                    // return emailOtpValidation ? null : 'Pin is incorrect';
                                    // print(data.otpNumber.toString() == _otpController.text.toString());
                                    // print(_otpController.text);
                                    // if(_buttonAnimationProvider.status) {
                                    //   print('incorrect');
                                    //   print(data.otpNumber == data.otpController.text);
                                    //   return data.otpNumber == data.otpController.text
                                    //       ? null
                                          // : 'Pin is incorrect';
                                    // }
                                    // else{
                                    //   print('null');
                                    //   return null;
                                    // }
                                    // else if(s!.length!=6){
                                    //   return 'Pin is incorrect';
                                    // }
                                    // else{
                                    //   print('null');
                                    //   return null;
                                    // }
                                  },
                                  onSubmitted: (pin) async {
                                    print('sddsd');
                                    print(pin);
                                    if (pin == data.otpNumber) {
                                      print('success');
                                    }
                                    // print(pin);
                                    // if(pin == _verificationId ){
                                    // print('sfkisfhksfs');
                                  }),
                            ),

                            Consumer<MailLoadingProvider>(
                              builder: (context, data, child) => Consumer<EmailVerificationAnimatedButtonProvider>(
                                builder: (context, buttonAnimation, child) {
                                  // if(!_buttonColorAnimationController.isDismissed){
                                  //   print('button animation false');
                                    // _buttonColorAnimationController.reverse();
                                  // }
                                  return AnimatedPositioned(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    left: 1,
                                    right: 1,
                                    // bottom: 10,
                                    top: pVerificationTruth.emailVerificationTruth || !buttonAnimation.status ? 0 : 70,
                                    child: FlatButton(
                                      color: (data.loadingIndex ==0 || data.loadingIndex ==2) && !pVerificationTruth.emailVerificationTruth? Colors.lightBlueAccent : Colors.greenAccent.shade700,
                                      minWidth: double.infinity,
                                      height: lFlatButtonHeight,
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      onPressed: () async {
                                        final form = _formKey.currentState!;
                                        if (form.validate()) {
                                          if(data.loadingIndex==0 && !pVerificationTruth.emailVerificationTruth) {
                                            try {
                                              final pEmailController = Provider.of<EmailControllerProvider>(
                                                  context, listen: false);
                                              data.changeIndex(2);
                                              bool presentCheck = await FirebaseApi.checkEmailOrPhonePresence(
                                                  pEmailController.emailController.text,
                                                  lPublicEmailPath, 'email');
                                              data.changeIndex(0);
                                              if (presentCheck) {
                                                if(_animationController.status == AnimationStatus.dismissed){
                                                  messageProvider.changeMessage('This account already exists !');
                                                  _animationController.forward();
                                                  await Future.delayed(Duration(seconds: 2));
                                                  if(mounted) {
                                                    _animationController.reverse();
                                                  }
                                                }
                                                // AuthMethods.bottomMessage(
                                                //     _animationController, 'This account already exists !',
                                                //     messageProvider);
                                              }
                                              else {
                                                await verifyPopUpMessage(
                                                    context, _buttonAnimationProvider, messageProvider);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          }else{
                                            swipeNextPage(context);
                                          }

                                          // bool result = await signUpOnPressed(context);
                                          // if (!result) {
                                          //   // final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
                                          //   final loadingProvider =
                                          //       Provider.of<LoadingProvider>(context, listen: false);
                                          //   loadingProvider.changeLoadingStatus(false);
                                          //   _animationController.forward();
                                          //   await Future.delayed(Duration(seconds: 2));
                                          //   _animationController.reverse();
                                          // }
                                          // FirebaseAuth.instance.cu)
                                          // print('ok');
                                        }
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                                      child: loadingStatus(data.loadingIndex),
                                    ),
                                  );
                                }
                              ),
                            ),

                            // Positioned(
                            //   // bottom,: 10,
                            //
                            //   child: Container(height: 50,color: Colors.red,),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 45,
              child: FadeInMessageBox(
                  animationController: _animationController, width: MediaQuery.of(context).size.width),
            ),
          ],
        ),
      ),
    );
  }

  void swipeNextPage(BuildContext context) {
    final pEmailVerification = Provider.of<VerificationTruthProvider>(context,listen: false);
    final pageIndex =Provider.of<PageControllerIndexProvider>(context,listen: false);
    print(pEmailVerification.emailVerificationTruth);
    if(pageIndex.pageIndex ==1 && pEmailVerification.emailVerificationTruth){
      print('act');
      widget.pageController.animateToPage(2, duration: lPageControllerDuration, curve: lPageControllerCurve);
    }
    else {
      print('no act');
    }
  }





  Future<void> verifyPopUpMessage(
      BuildContext context,
      EmailVerificationAnimatedButtonProvider _buttonAnimationProvider,
      AuthenticationMessageProvider messageProvider) async {
    print('onpressed button');

    final emailOtpProvider = Provider.of<EmailOtpVerification>(context, listen: false);
    final mailLoadingProvider = Provider.of<MailLoadingProvider>(context,listen: false);
    final pEmailController = Provider.of<EmailControllerProvider>(
        context, listen: false);

    if(mailLoadingProvider.loadingIndex==0) {
      String actualOtp = emailOtpProvider.otpNumber;
      String userOtp = emailOtpProvider.otpController.text;


      if (!_buttonAnimationProvider.status) {
        // if(_buttonColorAnimationController.status==AnimationStatus.dismissed){
        //   print('button color animation');
        //   _buttonColorAnimationController.forward();
        // }
        FocusScope.of(context).unfocus();

        _buttonAnimationProvider.changeAnimationStatus(true);
        messageProvider.changeMessage('An OTP has been sent to this mail id, Please enter the OTP above ');
        emailOtpProvider.generateRandomNumber();
        print('dfsfssssssssssssssssssssssssssssss');

        EmailOtpService.sendEmail(name: 'name',
            email: pEmailController.emailController.text,
            subject: 'Testing',
            message: emailOtpProvider.otpNumber.toString()).then((value) => print('sent email successfully'));

        _animationController.forward();
        await Future.delayed(Duration(seconds: 4));
        _animationController.reverse();
      }
      else if (_buttonAnimationProvider.status) {
        // final formOtp = _formKeyOtp.currentState!;
        // if(formOtp.validate()){
        //   print('hi');
        // }
        print(userOtp == actualOtp);
        print(userOtp);
        print(actualOtp);
        if (userOtp == actualOtp) {
          print('verificating');
          AuthMethods.emailVerified(context: context, pageController: widget.pageController,
              mailLoadingProvider: mailLoadingProvider,buttonProvider: _buttonAnimationProvider,
          );
        } else {
          if (_animationController.status == AnimationStatus.dismissed) {
            // print(_animationController.status);
            if (userOtp.length >= 1) {

              if(_animationController.status == AnimationStatus.dismissed){
                messageProvider.changeMessage('Incorrect OTP');
                _animationController.forward();
                await Future.delayed(Duration(seconds: 2));
                if(mounted) {
                  _animationController.reverse();
                }
              }
              // AuthMethods.bottomMessage(_animationController, "Incorrect OTP", messageProvider);
              // messageProvider.changeMessage("Incorrect OTP");
              // _animationController.forward();
              // await Future.delayed(Duration(seconds: 3));
              // _animationController.reverse();
            } else {

              if(_animationController.status == AnimationStatus.dismissed){
                messageProvider.changeMessage('Please enter the OTP');
                _animationController.forward();
                await Future.delayed(Duration(seconds: 2));
                if(mounted) {
                  _animationController.reverse();
                }
              }
              // AuthMethods.bottomMessage(_animationController, 'Please enter the OTP', messageProvider);
              // messageProvider.changeMessage('Please enter the OTP');
              // _animationController.forward();
              // await Future.delayed(Duration(seconds: 3));
              // _animationController.reverse();
              print('bye');
            }
          }
        }
        // sendOtp();
        // bool emailOtpValidation = emailAuth.validateOtp(
        //     recipientMail: _emailController.value.text,
        //     userOtp: _otpController.value.text);
      }
    }
  }

  Widget loadingStatus(int index) {
    final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);
    if(pVerificationTruth.emailVerificationTruth){
      return Text(
        'Verified',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }

    else if (index == 0) {
      return Text(
        'Verify',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (index == 1) {
      return Text(
        'Verified',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
    else if(index==2){
      return lLoadingIndicator;
    }
    else {
      return Text(
        'Next',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
  }

  // void sendOtp() async {
  //   bool result = await emailAuth.sendOtp(
  //       recipientMail: _emailcontroller.value.text, otpLength: 5
  //   );
  // }

  // Future<bool> signUpOnPressed(BuildContext context) async {
  //   final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  //
  //   loadingProvider.changeLoadingStatus(true);
  //   FocusScope.of(context).unfocus();
  //
  //   final message =
  //       await AuthenticationService.signUp(email: _emailController.text, password: _passwordController.text);
  //   if (message != "true") {
  //     messageProvider.changeMessage(message);
  //     return false;
  //   } else {
  //     Navigator.pop(context);
  //     loadingProvider.changeLoadingStatus(false);
  //     return true;
  //   }
  // }
}
