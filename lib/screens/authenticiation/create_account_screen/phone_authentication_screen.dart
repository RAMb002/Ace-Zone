import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_auth_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_otp_verification_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/methods/methods.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/textform_icon_close.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

class PhoneAuthenticationScreen extends StatefulWidget {
  PhoneAuthenticationScreen({required this.pageController, Key? key}) : super(key: key);

  static String name = "PhoneAuthenticationScreen";
  final PageController pageController;

  @override
  State<PhoneAuthenticationScreen> createState() => _PhoneAuthenticationScreenState();
}

class _PhoneAuthenticationScreenState extends State<PhoneAuthenticationScreen> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  late PhoneController _phoneController;
  late AnimationController _animationController;
  late Animation _animation;


  @override
  void initState() {
    final pPhone =Provider.of<PhoneAuthenticationProvider>(context,listen: false);
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _phoneController =PhoneController(PhoneNumber(
        isoCode: pPhone.country.toString(),
        nsn:pPhone.phoneNumber.toString()
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print('phone autentication screen');
    final phoneAuthProvider = Provider.of<PhoneAuthenticationProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: lAuthenticationAppBarColor,
      //   title: Text(
      //     'Phone Authentication',
      //   ),
      // ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: lPaddingFirstContainer,
            decoration: BoxDecoration(color: Colors.white
                // gradient: LinearGradient(
                //   colors: [lPrimaryColor, lTertiaryColor, lSecondaryColor],
                //   // stops: [0.2,0.6,1],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Align(
                    //   alignment : Alignment.centerLeft,
                    //   child: IconButton(onPressed: (){}, icon: Icon(
                    //     Icons.arrow_back_outlined
                    //   ),),
                    // ),

                    Center(
                      child: Text(
                        'Enter your Mobile Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(child: Text('You can skip this part and fill later')),
                    SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Consumer<PhoneAuthenticationProvider>(
                        builder: (context, data, child) => PhoneFormField(
                          cursorColor: Colors.black,
                          controller: _phoneController,
                          key: Key('phone-field'),
                          // controller: _phoneController, // controller & initialValue value
                          // initialValue: PhoneNumber(
                          //     isoCode: data.country.toString(),
                          //     nsn: data.phoneNumber.toString()), // can't be supplied simultaneously
                          shouldFormat: true, // default
                          defaultCountry: 'IN',
                          style: TextStyle(color: Colors.black), // default
                          countryCodeStyle: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Color(0xFFD0244D), fontWeight: FontWeight.bold),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                                borderRadius: lBorderRadius),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFFD0244D), width: 1.0),
                                borderRadius: lBorderRadius),
                            // errorBorder: UnderlineInputBorder(
                            //   borderSide: const BorderSide(color: Color(0xFFD0244D), width: 2.0),
                            // ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black, width: 1.0),
                                borderRadius: lBorderRadius),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black, width: 1.5),
                                borderRadius: lBorderRadius),
                            fillColor: Colors.black12.withOpacity(0.08),
                            filled: true,
                            hintText: 'Mobile Number',
                            // labelText: "Mobile Number",
                            // labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: _phoneController.value?.nsn != ''
                                ? MyTextFormFieldIconButtonClose(
                              lineColorWhite: false,
                                    onPressed: () {
                                      if (_phoneController.value != null) {
                                        _phoneController.value =
                                            PhoneNumber(isoCode: data.country.toString(), nsn: '');

                                        // data.changePhoneNumber("");
                                        // print(data.phoneNumber);
                                        // Navigator.pop(context);
                                        // Navigator.pushNamed(context, PhoneAuthenticationScreen.name);
                                      }
                                      print('dddd');
                                      print(_phoneController.value);
                                      // setState(() {
                                      //
                                      // });
                                    },
                                  )
                                : Container(
                                    width: 0,
                                  ),
                            // suffixIcon: _numberController.text.isEmpty
                            //     ? Container(
                            //   width: 0,
                            // )
                            //     : getIconButton()
                          ),

                          validator: PhoneValidator.validMobile(
                            allowEmpty: false,
                            // errorText: 'hi'
                          ), // default PhoneValidator.valid()
                          selectorNavigator:
                              const DialogNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
                          showFlagInInput: true, // default
                          flagSize: 16, // default
                          autofillHints: [AutofillHints.telephoneNumber], // default to null
                          // enabled: true,          // default
                          autofocus: false, // def// ault
                          autovalidateMode: AutovalidateMode.onUserInteraction, // default
                          onChanged: (number) {
                            phoneAuthProvider.changeCountry(number?.isoCode);
                            phoneAuthProvider.changePhoneNumber(number?.nsn);
                            phoneAuthProvider.changeCountryNumberCode(number?.countryCode);
                            // print(_phoneController.value);
                          },
                          // onSaved: (PhoneNumber p) => print('saved $p'),   // default null
                          // onChanged: (PhoneNumber p) => print('saved $p'), // default null
                          // ... + other textfield params
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Consumer<PhoneAuthLoadingProvider>(
                      builder: (context,loading,child)=>
                       FlatButton(
                        color: Colors.lightBlueAccent,
                        minWidth: double.infinity,
                        height: lFlatButtonHeight,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        onPressed: () async{

                          final form = _formKey.currentState!;
                          if (phoneAuthProvider.phoneNumber!.isEmpty) {
                            print('empty');
                            // form.validate();
                          } else if (form.validate()) {
                            final pLoading = Provider.of<PhoneAuthLoadingProvider>(context,listen: false);

                            if(pLoading.index==0) {
                              final pPhone = Provider.of<PhoneAuthenticationProvider>(context, listen: false);
                              pLoading.changeIndex(1);
                              bool presence = await FirebaseApi.checkEmailOrPhonePresence(
                                  "+${pPhone.countryNumberCode}${pPhone.phoneNumber}", lPublicPhonePath,
                                  'phone');
                              pLoading.changeIndex(0);
                              if (!presence) {
                                FocusScope.of(context).unfocus();
                                widget.pageController.animateToPage(4, duration: lPageControllerDuration,
                                    curve: lPageControllerCurve);
                                print('bye');
                              }
                              else {
                                final messageProvider =Provider.of<AuthenticationMessageProvider>(context, listen: false);
                                FocusScope.of(context).unfocus();
                                // AuthMethods.bottomMessage(
                                //     _animationController, 'This phone number already exists !',
                                //     Provider.of<AuthenticationMessageProvider>(context, listen: false));
                                if(_animationController.status == AnimationStatus.dismissed){
                                  messageProvider.changeMessage('This phone number already exists !');
                                  _animationController.forward();
                                  await Future.delayed(Duration(seconds: 2));
                                  if(mounted) {
                                    _animationController.reverse();
                                  }
                                }
                              }
                            }
                            else{
                              print('no act');
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                        child: loadingStatus(loading.index)
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
              bottom: 50,
              // left: 10,
              // right: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width - 60,
                  onPressed: () {
                    // widget.pageController
                    //     .animateToPage(4, duration: lPageControllerDuration, curve: lPageControllerCurve);
                    widget.pageController
                        .jumpToPage(5);
                  },
                  height: lFlatButtonHeight,
                  shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                  color: Colors.black,
                  child: Text(
                    'skip',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          Positioned(
            bottom: 55,
            child: FadeInMessageBox(
                animationController: _animationController, width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }

  Widget loadingStatus(int index){
    if(index ==0){
      return Text(
        'Next',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
    else if(index ==1){
      return lLoadingIndicator;
    }
    else{
      return Text(
        'error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
  }
}
