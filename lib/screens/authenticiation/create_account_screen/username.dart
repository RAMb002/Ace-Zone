import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/displayname_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/screens/authenticiation/methods/methods.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key,required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> with SingleTickerProviderStateMixin {
  // final TextEditingController _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // _buttonColorAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    //
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
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
                      'Choose username',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(child: Text('You can always change it later.',style: TextStyle(color: Colors.black54),),),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Consumer<DisplayNameController>(
                              builder: (context,data,child)=>
                                  MyTextFormField(
                                      controller: data.displayNameController,
                                      labelText: "User name",
                                      hintText: "Enter your user name",
                                      lineColorWhite: false,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (data.displayNameController.text.isEmpty) {
                                          return "This field is required";
                                        } else
                                          return null;
                                      }),
                            ),
                            SizedBox(height: 15,),

                            Consumer<PasswordLoadingProvider>(
                              builder: (context, loadingIndex, child) => FlatButton(
                                  color: Colors.lightBlueAccent,
                                  minWidth: double.infinity,
                                  height: lFlatButtonHeight,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () async {
                                    final form = _formKey.currentState!;
                                    if (form.validate()) {
                                      final userNameController = Provider.of<DisplayNameController>(context,listen: false);
                                      final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
                                      final pVerificationTruth = Provider.of<VerificationTruthProvider>(context,listen: false);


                                      String userName =userNameController.displayNameController.text;
                                      if(!pVerificationTruth.userNameVerificationTurth){
                                        print('valid');
                                        loadingIndex.changeLoadingIndex(1);
                                        bool userNamePresence = await FirebaseApi.checkDisplayNamePresence(userName);
                                        if(userNamePresence){
                                          FocusScope.of(context).unfocus();
                                          // AuthMethods.bottomMessage(_animationController,
                                          //     "A user with that username already exists"
                                          //     , messageProvider);
                                          if(_animationController.status == AnimationStatus.dismissed){
                                            messageProvider.changeMessage("A user with that username already exists");
                                            _animationController.forward();
                                            await Future.delayed(Duration(seconds: 2));
                                            if(mounted) {
                                              _animationController.reverse();
                                            }
                                          }
                                          loadingIndex.changeLoadingIndex(0);
                                        }
                                        else{
                                          // await FirebaseApi.setDisplayName(userName);
                                          FocusScope.of(context).unfocus();
                                          loadingIndex.changeLoadingIndex(0);
                                          pVerificationTruth.changeUserNameVerificationTruth(true);
                                          widget.pageController.animateToPage(1,duration: lPageControllerDuration, curve: lPageControllerCurve);

                                        }

                                      }else {
                                        widget.pageController.animateToPage(1,duration: lPageControllerDuration, curve: lPageControllerCurve);

                                      }

                                      // await signUpOnPressed(context);
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
                                  height: 132,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Consumer<PasswordLoadingProvider>(
                  //   builder: (context, loadingIndex, child) => FlatButton(
                  //       color: Colors.lightBlueAccent,
                  //       minWidth: double.infinity,
                  //       height: lFlatButtonHeight,
                  //       padding: EdgeInsets.symmetric(vertical: 10),
                  //       onPressed: () async {
                  //         final form = _formKey.currentState!;
                  //         if (form.validate()) {
                  //
                  //         }
                  //       },
                  //       shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                  //       child: loadingStatus(loadingIndex.loadingIndex)),
                  // ),
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
  Widget loadingStatus(int index) {
    if (index == 0) {
      return Text(
        'Next',
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
