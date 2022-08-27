import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/main.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/loading_provider.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/reset_password_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/welcome_screen/welcome_screen.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
  static String name = "SignInScreen";
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation _animation;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).padding.bottom ==0);
    // final firebaseUser = context.watch<User>();
    // if(firebaseUser!=null){
    //   print('null');
    // }
    // else print('done');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // final _passwordVisibilityProvider = Provider.of<PasswordVisibilityProvider>(context,listen: false);
        // if(_passwordVisibilityProvider.getPasswordVisibility){
        //   _passwordVisibilityProvider.changePasswordVisibility(false);
        // }
        return true;
      },
      child: Scaffold(
        body: Stack(
          // alignment: Alignment.center,
          children: [
            Container(
              height: height - height * 0.13,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/sign_in_screen.png',
                  ),
                  fit:  BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Consumer<LoadingProvider>(
                builder: (context, loading, child) => Visibility(
                  visible: loading.loadingStatus,
                  child: Container(
                    height: height,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Positioned(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: height * 0.43,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: height * 0.57,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [lPrimaryColor.withOpacity(1),lSecondaryColor.withOpacity(1)],
                              // stops: [0.2, 0.6, 1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sign In",
                                  style: lHeadingStyle,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text(
                                  'Login to visit your neighbors and friends.',
                                  style: lIntroStyle,
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                MyTextFormField(
                                    controller: _emailController,
                                    labelText: "Email",
                                    email: true,
                                    hintText: 'Enter your email',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value != null && !EmailValidator.validate(value)) {
                                        return "Enter a valid Email";
                                      } else
                                        return null;
                                    }),
                                Consumer<PasswordVisibilityProvider>(
                                  builder: (context, data, child) => MyTextFormField(
                                      controller: _passwordController,
                                      labelText: "Password",
                                      keyboardType: TextInputType.emailAddress,
                                      password: !data.getPasswordVisibility,
                                      passwordIcon: true,
                                      hintText: 'Enter the password',
                                      passwordVisibility: data.getPasswordVisibility,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "This Field cannot be empty";
                                        } else
                                          return null;
                                      }),
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          ResetPasswordScreen(controller: _emailController)));
                                    },
                                    child: Text(
                                      'ForgotPassword ?',
                                      style: TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                WelcomeButton(
                                  height: 45,
                                  color: Colors.white,
                                  onPressed: () async {
                                    final form = _formKey.currentState!;
                                    if (form.validate()) {
                                      await SignInButtonOnPressed(context);

                                      // Navigator.pop(context);
                                    }
                                  },
                                  text: "Login",
                                  textColor: Colors.black,
                                ),
                                SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Positioned(child: Center(
                      //   child: LoadingFadingLine.square(
                      //     borderColor: Colors.cyan,
                      //     borderSize: 0,
                      //     size: 30.0,
                      //     backgroundColor: Colors.cyanAccent,
                      //     duration: Duration(milliseconds: 500),
                      //   ),
                      // ),),
                      Positioned(
                        // top: 4,
                        child: Consumer<LoadingProvider>(
                          builder: (context, loading, child) => Visibility(
                            visible: loading.loadingStatus,
                            child: SizedBox(
                              width: width,
                              height: 5.0,
                              child: Shimmer.fromColors(
                                  baseColor: Colors.black54,
                                  highlightColor: Colors.lightBlue.shade200,
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    height: 20,
                                    width: width,
                                    color: Colors.lightBlueAccent,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // top: 0,
                        // bottom: 10,
                        child: Consumer<LoadingProvider>(
                          builder: (context, loading, child) => Visibility(
                            visible: loading.loadingStatus,
                            child: Column(
                              children: [
                                Container(
                                  height: 4,
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  height: (height * 0.57),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 45,
                        child: Center(
                            child: FadeInMessageBox(animationController: _animationController, width: width)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Positioned(
            //     child: Center(child: CircularProgressIndicator(
            //       color: Theme.of(context).colorScheme.outline,
            //     )),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> SignInButtonOnPressed(BuildContext context) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    loadingProvider.changeLoadingStatus(true);

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(child: CircularProgressIndicator(),),);
    String message =
        await AuthenticationService.signIn(email: _emailController.text, password: _passwordController.text);
    print("the message is $message");
    // navigatorKey.currentState!.popUntil((route) => route.isActive);
    if (message != "true") {
      loadingProvider.changeLoadingStatus(false);
      _animationController.forward();
      messageProvider.changeMessage(message);
      await Future.delayed(Duration(seconds: 2));
      _animationController.reverse();

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(
      //       backgroundColor: Colors.black,
      //       content: Text(message),
      //     ))
      //     .closed
      //     .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
    } else {
      // try {
      //   await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      //   print('verfication sent');
      // }
      // catch(e){
      //   print('error');
      // }
      Navigator.pop(context);
      loadingProvider.changeLoadingStatus(false);
    }
  }
}
