import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_update.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/screens/authenticiation/methods/methods.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneOtpVerification extends StatefulWidget {
  const PhoneOtpVerification({
    // required this.phoneNumber,required this.countryNumberCode,
    required this.pageController,
    Key? key}) : super(key: key);

  // final String? phoneNumber;
  // final String? countryNumberCode;
  static String name = "PhoneOtpVerificationScreen";
  final PageController pageController;

  @override
  State<PhoneOtpVerification> createState() => _PhoneOtpVerificationState();
}

class _PhoneOtpVerificationState extends State<PhoneOtpVerification> with SingleTickerProviderStateMixin {

  TextEditingController _smsController = TextEditingController();
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    // TODO: implement dispose
    _smsController.dispose();
    _animationController.dispose();
    super.dispose();

  }

  String _verificationId ="";
  // int? _resendToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhone();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }



  @override
  Widget build(BuildContext context) {
    print('phone otp sceeen');
    // print('resing token $_resendToken');

    final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);
    final pMessage = Provider.of<AuthenticationMessageProvider>(context,listen: false);


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
      color: Colors.blue,
      // border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      textStyle:TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.lightBlueAccent,
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: lAuthenticationAppBarColor,
      //   title: Text(
      //     'OTP Verification',
      //   ),
      // ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: lPaddingFirstContainer,
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [lPrimaryColor, lTertiaryColor, lSecondaryColor],
              //   // stops: [0.2,0.6,1],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 25),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text('Verification',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                        ),),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Center(child: Text('Enter the code sent to the number',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),),),
                    SizedBox(height: 10,),
                    Consumer<PhoneAuthenticationProvider>(
                      builder: (context,data,child)=>
                       Center(
                        child: Text('+ ${data.countryNumberCode} ${data.phoneNumber}',
                        style: TextStyle(
                          color: Colors.black54.withOpacity(0.7),
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Pinput(
                      closeKeyboardWhenCompleted: false,
                      controller: _smsController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      // errorPinTheme: errorPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      // validator: (s) {
                      //   return s == _verificationId ? null : 'Pin is incorrect';
                      // },
                      onSubmitted: (pin)async{
                        if(_smsController.text.length!=6){
                          if(_animationController.status == AnimationStatus.dismissed){
                            pMessage.changeMessage("Enter a 6 digit pin");
                            _animationController.forward();
                            await Future.delayed(Duration(seconds: 2));
                            if(mounted) {
                              _animationController.reverse();
                            }
                          }
                        }
                        else{
                          if(_verificationId.isNotEmpty) {
                            // if (_smsController.text != _verificationId) {
                            //   print(_smsController.text);
                            //   print(_verificationId);
                            //   if (_animationController.status == AnimationStatus.dismissed) {
                            //     pMessage.changeMessage("Incorrect pin");
                            //     _animationController.forward();
                            //     await Future.delayed(Duration(seconds: 2));
                            //     if (mounted) {
                            //       _animationController.reverse();
                            //     }
                            //   }
                            // }
                            // else{
                              await phoneOtpVerificationProcess(context, pin, pVerificationTruth, pMessage);
                            // }
                          }
                          else{
                            if(_animationController.status == AnimationStatus.dismissed){
                              pMessage.changeMessage("Request timed out");
                              _animationController.forward();
                              await Future.delayed(Duration(seconds: 2));
                              if(mounted) {
                                _animationController.reverse();
                              }
                            }
                          }

                        }


                      }
                      //   try{
                      //     FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationId,
                      //         smsCode: pin)).then((value)async{
                      //           if(value.user!=null){
                      //             print('not null');
                      //           }
                      //     });
                      //
                      //   }
                      //   catch(e){
                      //     print('0000000000000000000000000000000000000');
                      //   }
                      //
                      //
                      // },

                    ),
                    SizedBox(height: 20,),
                    // Center(child: Text(
                    //   'Didnt receive code ?',
                    //   style: TextStyle(
                    //     fontSize: 15
                    //   ),
                    // ),),
                    // SizedBox(height: 8,),
                    // GestureDetector(
                    //   onTap: (){
                    //
                    //   },
                    //   child: Center(
                    //     child: Text(
                    //       'Resend OTP',
                    //       style: TextStyle(
                    //         decoration: TextDecoration.underline,
                    //           fontSize: 15,
                    //           color: Colors.blueAccent,
                    //         fontWeight: FontWeight.bold
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          PageLoader(),
          Positioned(
            bottom: 45,
            child: FadeInMessageBox(
                animationController: _animationController, width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }

  Future<void>


  phoneOtpVerificationProcess(BuildContext context, String pin, VerificationTruthProvider pVerificationTruth, AuthenticationMessageProvider pMessage) async {
     final pPhone = Provider.of<PhoneAuthenticationProvider>(context,listen: false);
    print(pin);
    print(_verificationId);
    print('sfkisfhksfs');
    final user = FirebaseAuth.instance.currentUser;
    final pLoader = Provider.of<PasswordLoadingProvider>(context,listen: false);
    try {
      pLoader.changeLoadingIndex(1);
      await FirebaseAuth.instance.currentUser?.linkWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: pin)).then((value) =>
      {
        print(value.user),
        if(value.user != null){
          print('got in'),
          FirebaseApi.setPhoneNumber('+${pPhone.countryNumberCode}${pPhone.phoneNumber}'),
          pVerificationTruth.changePhoneVerificationTruth(true),
          FirebaseUpdate.updateProfileData(user!.uid, '+${pPhone.countryNumberCode}${pPhone.phoneNumber}','phoneNumber'),
          pLoader.changeLoadingIndex(0),
          widget.pageController.animateToPage(5, duration: lPageControllerDuration,
              curve: lPageControllerCurve),
        }
      });
    }
    on FirebaseAuthException catch( e){

      print(e.message);
      FocusScope.of(context).unfocus();
      pLoader.changeLoadingIndex(0);
      // pMessage.changeMessage(e.message.toString());
      //     AuthMethods.bottomMessage(_animationController, e.message.toString(), pMessage);

      if(_animationController.status == AnimationStatus.dismissed){
        pMessage.changeMessage(e.message.toString());
        _animationController.forward();
        await Future.delayed(Duration(seconds: 2));
        if(mounted) {
          _animationController.reverse();
        }
      }
      // if(_animationController.status == AnimationStatus.dismissed){
      //   _animationController.forward();
      //   await Future.delayed(Duration(seconds: 2));
      //   _animationController.reverse();
      // }
    }
  }

  verifyPhone()async{
    final pPhone = Provider.of<PhoneAuthenticationProvider>(context,listen: false);
    final pMessage = Provider.of<AuthenticationMessageProvider>(context,listen: false);
    final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);


    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber :"+${pPhone.countryNumberCode}${pPhone.phoneNumber}",
        // phoneNumber: '+${widget.countryNumberCode}${widget.phoneNumber}',
      // phoneNumber: '+918056741925',
        verificationCompleted: (PhoneAuthCredential credential)async{
        print("the verification code is " + credential.smsCode.toString());
        // Provider.of<VerificationTruthProvider>(context,listen: false).changePhoneVerificationTruth(true);
        // widget.pageController.animateToPage(5, duration: Duration(seconds: 1), curve: Curves.easeOut);
          await phoneOtpVerificationProcess(context, credential.smsCode.toString(), pVerificationTruth, pMessage);

          print('verified successfully');
        },
        verificationFailed: (FirebaseAuthException e)async{
        print('++++++++++++++++ failed +==============');
        pMessage.changeMessage(e.message.toString());
        if(_animationController.status == AnimationStatus.dismissed){
          _animationController.forward();
          await Future.delayed(Duration(seconds: 3));
          if(mounted) {
            _animationController.reverse();
          }
        }
          print(e.message);
        },
        codeSent: (String verificationId,int? resendToken){
        print('code sent 0000000000000000000000');
        print(verificationId);
          setState(() {
            // _resendToken = resendToken;
            this._verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout:(String verificationId){
        print('codeAutoRetrievalTImeout000000000000000000');
          setState(() {
            this._verificationId = verificationId;
          });
        },
      timeout: Duration(seconds:30),
      // forceResendingToken: _resendToken,
      // forceResendingToken:
    );
    print(_verificationId);
  }
}

class PageLoader extends StatelessWidget {
  const PageLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Consumer<PasswordLoadingProvider>(
        builder: (context,data,child)=>
         Visibility(
          visible: data.loadingIndex ==1,
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: LoadingAnimationWidget.bouncingBall(
                color: Colors.lightBlueAccent,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
