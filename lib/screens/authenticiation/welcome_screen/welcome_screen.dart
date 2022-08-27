import 'dart:ui';

import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/displayname_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_otp_verification.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_auth_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/create_account_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/new_create_account.dart';
import 'package:chadate_alpha/screens/authenticiation/sign_in_screen/sign_in_screen.dart';
import 'package:chadate_alpha/screens/map_screen/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
  static String name = "WelcomeScreen";

}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trial();
  }

  void trial()async{

    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    print(isLocationServiceEnabled);

    // await Geolocator.openAppSettings();
    // await Geolocator.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError){
            return Center(child: Text('Something went wrong!'),);
          }
          else if(snapshot.hasData){
            return MapScreen();
          }
          else {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/welcome_screen.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 285,
                    child: ClipRect(
                      child: BackdropFilter(
                        // blendMode: BlendMode.lighten,
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [lPrimaryColor.withOpacity(0.8),lSecondaryColor.withOpacity(0.6)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    'Welcome',
                                    style: lHeadingStyle
                                ),
                                SizedBox(height: 10,),
                                Text(
                                    'Login or create an account to visit your neighbors and friends.',
                                    style: lIntroStyle
                                ),
                                SizedBox(height: 25,),
                                WelcomeButton(
                                  text: 'Login',
                                  textColor: Colors.white,
                                  color: Colors.transparent,
                                  onPressed: (){
                                    providerChanges();
                                    Navigator.pushNamed(context,SignInScreen.name, );

                                  },
                                ),
                                SizedBox(height: 20,),
                                WelcomeButton(
                                  text: 'Create Account',
                                  color: Colors.white,
                                  textColor: Colors.black,
                                  onPressed: (){
                                    providerChanges();

                                    Navigator.pushNamed(context,NewCreateAccountScreenMain.name, );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // height: 50,
                          // width: 50,
                          // color: Colors.blue.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }

      ),
    );
  }

  void providerChanges(){
    final _passwordVisibilityProvider = Provider.of<PasswordVisibilityProvider>(context,listen: false);
    final authenticationMessage = Provider.of<AuthenticationMessageProvider>(context,listen: false);
    final pPasswordLoader = Provider.of<PasswordLoadingProvider>(context,listen: false);
    final pEmailController = Provider.of<EmailControllerProvider>(context,listen: false);
    final pDisplayNameController = Provider.of<DisplayNameController>(context,listen: false);
    final pEmailLoading = Provider.of<MailLoadingProvider>(context,listen: false);
    final pEmailOtpController = Provider.of<EmailOtpVerification>(context,listen: false);
    final pPhoneAuthLoading = Provider.of<PhoneAuthLoadingProvider>(context,listen: false);
    final pPhoneAuthentication = Provider.of<PhoneAuthenticationProvider>(context,listen: false);
    final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);

    if(_passwordVisibilityProvider.getPasswordVisibility){
      _passwordVisibilityProvider.changePasswordVisibility(false);
    }
    if(authenticationMessage.message!=""){
      authenticationMessage.changeMessage("");
    }
    if(pPasswordLoader.loadingIndex!=0){
      pPasswordLoader.changeLoadingIndex(0);
    }
    if(pEmailLoading.loadingIndex!=0){
      pEmailLoading.changeIndex(0);
    }
    if(pEmailController.emailController.text.isNotEmpty){
      pEmailController.clearEmailController();
    }
    if(pEmailOtpController.otpController.text.isNotEmpty){
      pEmailOtpController.clearOtpController();
    }
    if(pDisplayNameController.displayNameController.text.isNotEmpty){
      pDisplayNameController.clearUserDisplayController();
    }
    if(pPhoneAuthLoading.index!=0){
      pPhoneAuthLoading.changeIndex(0);
    }
    if(pPhoneAuthentication.phoneNumber!=''){
      pPhoneAuthentication.changePhoneNumber('');
    }
    if(pVerificationTruth.emailVerificationTruth){
      pVerificationTruth.changeEmailVerificationTruth(false);
    }
    if(pVerificationTruth.userNameVerificationTurth){
      pVerificationTruth.changeUserNameVerificationTruth(false);
    }
    if(pVerificationTruth.phoneVerificationTruth){
      pVerificationTruth.changePhoneVerificationTruth(false);
    }
  }
}

class WelcomeButton extends StatelessWidget {
   WelcomeButton({
    required this.color,
    required this.onPressed,
    required this.text,
    required this.textColor,
    this.height=50.0,
    Key? key,
  }) : super(key: key);

  final Color color;
  final Function() onPressed;
  final String text;
  final Color textColor;
  double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FlatButton(
              splashColor: Colors.transparent,
              color: color,
              height: height,
                onPressed:onPressed,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
            ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                side: BorderSide(color: Colors.white)
              ),

            ),
          ),
        ),
      ],
    );
  }
}
