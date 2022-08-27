import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/displayname_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/oops/profile_oops.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:chadate_alpha/services/location/current_position.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> with SingleTickerProviderStateMixin{
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProfileOops profileOops = ProfileOops();

  late AnimationController _animationController;
  late Animation animation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationDetails();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

  }



  void getLocationDetails()async{
    // bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    //
    // print(isLocationServiceEnabled);
    print('00000000000');

    CurrentLocation _currentLocation = CurrentLocation();
    profileOops.geoPoint = await _currentLocation.getLocation();
    print(profileOops.geoPoint.latitude);
    print(profileOops.geoPoint.longitude);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: lPaddingFirstContainer,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        'Create a Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(child: Text('For security, your password must be 6 characters or more.',textAlign:TextAlign.center,style: TextStyle(color: Colors.black54),),),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [

                              Consumer<PasswordVisibilityProvider>(
                                builder: (context, data, child) => MyTextFormField(
                                    controller: _passwordController,
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    lineColorWhite: false,
                                    keyboardType: TextInputType.emailAddress,
                                    password: !data.getPasswordVisibility,
                                    passwordIcon: true,
                                    passwordVisibility: data.getPasswordVisibility,
                                    validator: (value) {
                                      if (_passwordController.text.length < 6) {
                                        return "The password must be 6 characters or more";
                                      } else
                                        return null;
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Consumer<PasswordLoadingProvider>(
                                builder: (context, loadingIndex, child) => FlatButton(
                                    color: Colors.lightBlueAccent,
                                    minWidth: double.infinity,
                                    height: lFlatButtonHeight,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    onPressed: () async {
                                      final form = _formKey.currentState!;
                                      if (form.validate()) {
                                        await signUpOnPressed(context);
                                      }
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                                    child: loadingStatus(loadingIndex.loadingIndex)),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          child: Consumer<PasswordLoadingProvider>(
                            builder: (context,loading,child)=>
                             Visibility(
                              visible:loading.loadingIndex ==1 ,
                              child: Container(
                                color: Colors.transparent,
                                height: 136,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
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
    );
  }

  Future<void> signUpOnPressed(BuildContext context) async {
    final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
    final emailControllerProvider = Provider.of<EmailControllerProvider>(context, listen: false);
    final pPasswordLoading = Provider.of<PasswordLoadingProvider>(context, listen: false);

    // final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);


    pPasswordLoading.changeLoadingIndex(1);
    FocusScope.of(context).unfocus();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      try{
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Location Permission'),
              content: Text(
                  'This app needs location access to display your location to other users'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Deny'),
                  onPressed: () => {
                  pPasswordLoading.changeLoadingIndex(0),
            Navigator.of(context).pop(),
                            }),
                CupertinoDialogAction(
                  child: Text('Settings'),
                  onPressed: () => Geolocator.openLocationSettings(),
                ),
              ],
            ));
      }
      catch(e){
        pPasswordLoading.changeLoadingIndex(0);

      }
    }
    else{
      final message = await AuthenticationService.signUp(
          email: emailControllerProvider.emailController.text, password: _passwordController.text);
      if (message != "true") {
        print(message);
        pPasswordLoading.changeLoadingIndex(0);
        if(_animationController.status == AnimationStatus.dismissed){
          messageProvider.changeMessage(message);
          _animationController.forward();
          await Future.delayed(Duration(seconds: 2));
          if(mounted) {
            _animationController.reverse();
          }
        }

      } else {



        final pEmailController = Provider.of<EmailControllerProvider>(context,listen: false);
        final pUserNameController = Provider.of<DisplayNameController>(context,listen: false);
        // final pPhoneNumber = Provider.of<PhoneAuthenticationProvider>(context,listen: false);

        print('updating user');
        final User? user = FirebaseAuth.instance.currentUser;
        final String userId = user!.uid;
        await user.updateDisplayName(pUserNameController.displayNameController.text);
        FirebaseApi.setEmail(emailControllerProvider.emailController.text);
        FirebaseApi.setDisplayName(pUserNameController.displayNameController.text,userId);

        // var user = FirebaseAuth.instance.currentUser?.uid;

        // ProfileOops profileOops = ProfileOops();

        profileOops.userName = pUserNameController.displayNameController.text;
        profileOops.emailId = pEmailController.emailController.text;
        Coordinates coordinates= Coordinates();
        coordinates.geoPoint = profileOops.geoPoint;
        coordinates.userId = userId;
        // // profileOops.phoneNumber = "+${pPhoneNumber.countryNumberCode}${pPhoneNumber.phoneNumber}";
        //
        print(coordinates.geoPoint.longitude);
        print(profileOops.geoPoint.latitude);
        await FirebaseApi.setCoordinates(coordinates);
        await FirebaseApi.setProfileData(profileOops, userId);
        await user.updateDisplayName(_userNameController.text);

        print('updated user');
        widget.pageController.animateToPage(3, duration: lPageControllerDuration, curve: lPageControllerCurve);// loadingProvider.changeLoadingStatus(false);
        await Future.delayed(Duration(milliseconds: 800));
        pPasswordLoading.changeLoadingIndex(0);
      }
    }

  }

  Widget loadingStatus(int index) {
    if (index == 0) {
      return Text(
        'Create Account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (index == 1) {
      return lLoadingIndicator;
    } else
      return Container();
  }
}
