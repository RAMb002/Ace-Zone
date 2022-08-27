import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_otp_verification.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_verification_animatedbutton_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/pagecontroller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/screens/widgets/textform_icon_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const tIconSize = 22.0;

class MyTextFormField extends StatefulWidget {
  MyTextFormField({
    required this.controller,
    required this.labelText,
    required this.validator,
    required this.keyboardType,
    this.password = false,
    this.passwordIcon = false,
    this.email = false,
    this.passwordVisibility = false,
    this.lineColorWhite = true,
    this.hintText = '',
    // this.lineColor = Colors.white70,
    Key? key,
  }) : super(key: key);

  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  // final Color lineColor;
  final bool lineColorWhite;
  bool email;
  bool passwordIcon;
  bool password;
  bool passwordVisibility;
  String hintText;
  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  // final
  @override
  Widget build(BuildContext context) {
    print('textformfield');
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      cursorColor: widget.lineColorWhite ? Colors.white54 : Colors.black,
      style: TextStyle(color: widget.lineColorWhite ? Colors.white : Colors.black54),
      autofocus: true,
      obscureText: widget.password,
      validator: widget.validator,
      autofillHints: widget.email ? [AutofillHints.email] : null,

      onChanged: (value) {

        providerChangesForChangingValue();
        setState(() {});
      },
      //     (value){
      //   if(value!.isEmpty){
      //     return "This Field cannot be empty";
      //   }
      //   else return null;
      //
      // },
      decoration: InputDecoration(
          filled: widget.lineColorWhite ? false : true,
          fillColor: widget.lineColorWhite ? null : Colors.black12.withOpacity(0.08),
          errorStyle: TextStyle(color:widget.lineColorWhite ? Color(0xFFF6A091) : Color(0xFFD0244D), fontWeight: FontWeight.bold),
          focusedErrorBorder: widget.lineColorWhite
              ? UnderlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF6A091), width: 2.0),
          )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                  borderRadius: lBorderRadius),
          errorBorder: widget.lineColorWhite
              ? UnderlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFF6A091), width: 2.0),
                )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                  borderRadius: lBorderRadius),
          enabledBorder: widget.lineColorWhite
              ? UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.lineColorWhite ? Colors.white70 : Colors.black, width: 1.0),
                )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0), borderRadius: lBorderRadius),
          focusedBorder: widget.lineColorWhite
              ? UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: widget.lineColorWhite ? Colors.white70 : Colors.black, width: 1.0),
                )
              : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.5), borderRadius: lBorderRadius),
          hintText: widget.hintText,
          hintStyle:widget.lineColorWhite ? TextStyle(color: Colors.white54) : null,
          labelText: widget.lineColorWhite ? widget.labelText  : null,
          labelStyle: TextStyle(color: widget.lineColorWhite ? Colors.white70 : Colors.black),
          suffixIcon: widget.controller.text.isEmpty
              ? Container(
                  width: 0,
                )
              : getIconButton()),
    );
  }

  Widget? getIconButton() {
    final _passwordVisibilityProvider = Provider.of<PasswordVisibilityProvider>(context, listen: false);
    if (widget.passwordIcon) {
      if (widget.controller.text.isEmpty) {
        return Container(
          width: 0,
        );
      } else if (widget.controller.text.isNotEmpty && !widget.passwordVisibility) {
        return IconButton(
          padding: widget.lineColorWhite ? EdgeInsets.only(top: 15) : EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            // widget.controller.clear();
            setState(() {
              widget.passwordVisibility = true;
              _passwordVisibilityProvider.changePasswordVisibility(true);
              widget.password = false;
            });
          },
          icon: Icon(
            Icons.visibility_off,
            color: widget.lineColorWhite ? Colors.white : Colors.black,
            size: tIconSize,
          ),
        );
      } else if (widget.controller.text.isNotEmpty && widget.passwordVisibility) {
        return IconButton(
          padding: widget.lineColorWhite ? EdgeInsets.only(top: 15) : EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            // widget.controller.clear();
            setState(() {
              widget.passwordVisibility = false;
              _passwordVisibilityProvider.changePasswordVisibility(false);
              widget.password = true;
            });
          },
          icon: Icon(
            Icons.visibility,
            color: widget.lineColorWhite ? Colors.white : Colors.lightBlueAccent,
            size: tIconSize,
          ),
        );
      }
    } else {
      return MyTextFormFieldIconButtonClose(
       lineColorWhite: widget.lineColorWhite,
        onPressed: () {
          providerChangesForChangingValue();
          widget.controller.clear();
          setState(() {});
        },
      );
    }
  }

  void providerChangesForChangingValue(){
    final _buttonAnimationProvider =
    Provider.of<EmailVerificationAnimatedButtonProvider>(context, listen: false);

    final emailOtpProvider = Provider.of<EmailOtpVerification>(context, listen: false);
    final mailLoadingProvider = Provider.of<MailLoadingProvider>(context,listen: false);

    if (_buttonAnimationProvider.status) {
      emailOtpProvider.clearOtpController();
      _buttonAnimationProvider.changeAnimationStatus(false);
    }
    if(!widget.lineColorWhite){
      final otpTruthProvider = Provider.of<VerificationTruthProvider>(context,listen: false);
      final pageController =Provider.of<PageControllerIndexProvider>(context,listen: false);
      if (pageController.pageIndex==0 && otpTruthProvider.userNameVerificationTurth){
        otpTruthProvider.changeUserNameVerificationTruth(false);
      }
      if( pageController.pageIndex==1 &&
          otpTruthProvider.emailVerificationTruth){
        print('made false');
        otpTruthProvider.changeEmailVerificationTruth(false);
      }



    }
    if(mailLoadingProvider.loadingIndex==1){
      mailLoadingProvider.changeIndex(0);
    }
  }
}
