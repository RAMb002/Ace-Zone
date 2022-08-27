import 'dart:ui';

import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_otp_verification_screen.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({Key? key,required this.controller}) : super(key: key);
  static String name = 'ResetPasswordScreen';
  final TextEditingController controller;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // TextEditingController _emailController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        'Reset Password',
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
                      child: MyTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Email",
                          lineColorWhite: false,
                          hintText: 'Enter your mail id',
                          controller: widget.controller,
                          email: true,
                          validator: (email) {
                            if (email != null && !EmailValidator.validate(email)) {
                              return "Enter a valid Email";
                            } else
                              return null;
                          }),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FlatButton(
                      color: Colors.lightBlueAccent,
                      minWidth: double.infinity,
                      height: lFlatButtonHeight,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      onPressed: () async {

                        final form = _formKey.currentState!;
                        if (form.validate()) {
                          resetPasswordMail();
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                      child: Text(
                        'Reset password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
          PageLoader(),
        ],
      ),
    );
  }

  Future resetPasswordMail() async {

    final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
    final pLoader = Provider.of<PasswordLoadingProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    try {
      pLoader.changeLoadingIndex(1);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.controller.text);
      pLoader.changeLoadingIndex(0);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check your mail to reset your password',textAlign: TextAlign.center,),
        ),
      );

    } on FirebaseAuthException catch (e) {
      pLoader.changeLoadingIndex(0);
      messageProvider.changeMessage(e.message.toString());
      if (_animationController.status == AnimationStatus.dismissed) {
        _animationController.forward();
        await Future.delayed(Duration(seconds: 3));
        if (mounted) {
          _animationController.reverse();
        }
      }
      print(e.message);
      print('0000000000000');
    }
  }
}
