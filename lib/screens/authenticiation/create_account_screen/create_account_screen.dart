import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/my_provider/loading_provider.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_authentication_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/welcome_screen/welcome_screen.dart';
import 'package:chadate_alpha/screens/widgets/fadein_messagebox.dart';
import 'package:chadate_alpha/screens/widgets/image_display.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

const bigWidgetGap = 10.0;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();

  static String name = "CreateAccountScreen";
}

class _CreateAccountScreenState extends State<CreateAccountScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final PhoneController _phoneController = PhoneController(null);
  late AnimationController _animationController;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _numberController.dispose();
    _occupationController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // _animationController.forward();
    print('create account screen');
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lPrimaryColor, lTertiaryColor, lSecondaryColor],
                // stops: [0.2,0.6,1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: bigWidgetGap,
                  ),
                  Text(
                    'Create an account to visit your neighbors and friends',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: bigWidgetGap,
                  ),
                  ImageDisplay(
                    editStatus: false,
                    context: context,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        MyTextFormField(
                            keyboardType: TextInputType.name,
                            labelText: "Name",
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field cannot be empty";
                              } else
                                return null;
                            }),
                        // MyTextFormField(
                        //     keyboardType: TextInputType.phone,
                        //     labelText: "Mobile Number",
                        //     controller: _numberController,
                        //     validator: (value) {
                        //       if (value!.isEmpty) {
                        //         return "This Field cannot be empty";
                        //       } else
                        //         return null;
                        //     }),
                        Stack(
                          children: [
                            Consumer<PhoneAuthenticationProvider>(
                              builder:(context,data,child){
                                print('hi');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:data.phoneNumber!="" ? 15 : 20),
                                    Text(
                                      'Mobile Number',
                                        style :TextStyle(color: Colors.white70,fontSize: data.phoneNumber=="" ? 16 : 12),
                                    ),
                                    SizedBox(height: 5,),
                                    Visibility(
                                      visible : data.phoneNumber !="",
                                      child: Text(
                                      data.phoneNumber!="" ?'+${data.countryNumberCode} ${data.phoneNumber}' :"",
                                      style: TextStyle(color: Colors.white,fontSize: 16),),
                                    ),
                                    SizedBox(height: data.phoneNumber!="" ? 2 : 6,),
                                    Divider(color: Colors.white70,thickness: 1,),
                                  ],
                                );
                                //   PhoneFormField(
                                //   cursorColor: Colors.white,
                                //   key: Key('phone-field'),
                                //   // controller: _phoneController, // controller & initialValue value
                                //   initialValue: PhoneNumber(isoCode: data.country.toString(), nsn: data.phoneNumber.toString()), // can't be supplied simultaneously
                                //   shouldFormat: true, // default
                                //   defaultCountry: 'IN',
                                //   style: TextStyle(color: Colors.white), // default
                                //   countryCodeStyle: TextStyle(color: Colors.white),
                                //   decoration: InputDecoration(
                                //     errorStyle: TextStyle(color: Color(0xFFD0244D), fontWeight: FontWeight.bold),
                                //     errorBorder: UnderlineInputBorder(
                                //       borderSide: const BorderSide(color: Color(0xFFD0244D), width: 2.0),
                                //     ),
                                //     enabledBorder: UnderlineInputBorder(
                                //       borderSide: const BorderSide(color: Colors.white70, width: 1.0),
                                //     ),
                                //     focusedBorder: UnderlineInputBorder(
                                //       borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                                //     ),
                                //     labelText: "Mobile Number",
                                //     labelStyle: TextStyle(color: Colors.white70),
                                //     // suffixIcon: _numberController.text.isEmpty
                                //     //     ? Container(
                                //     //   width: 0,
                                //     // )
                                //     //     : getIconButton()
                                //   ),
                                //
                                //   validator: PhoneValidator.validMobile(), // default PhoneValidator.valid()
                                //   selectorNavigator:
                                //   const DialogNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
                                //   showFlagInInput: true, // default
                                //   flagSize: 16, // default
                                //   autofillHints: [AutofillHints.telephoneNumber], // default to null
                                //   // enabled: true,          // default
                                //   autofocus: false, // default
                                //   autovalidateMode: AutovalidateMode.onUserInteraction, // default
                                //   onChanged: (number) {
                                //     print(number);
                                //   },
                                //
                                //   // onSaved: (PhoneNumber p) => print('saved $p'),   // default null
                                //   // onChanged: (PhoneNumber p) => print('saved $p'), // default null
                                //   // ... + other textfield params
                                // );

                              }
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, PhoneAuthenticationScreen.name);
                                  print('hi');
                                },
                                child: Container(
                                  height: 50,
                                  width: width ,
                                  color: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),

                        MyTextFormField(
                            keyboardType: TextInputType.name,
                            labelText: "Occupation",
                            controller: _occupationController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field cannot be empty";
                              } else
                                return null;
                            }),
                        MyTextFormField(
                            keyboardType: TextInputType.streetAddress,
                            labelText: "Occupation Address",
                            controller: _addressController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field cannot be empty";
                              } else
                                return null;
                            }),
                        MyTextFormField(
                            keyboardType: TextInputType.emailAddress,
                            labelText: "Email",
                            controller: _emailController,
                            email: true,
                            validator: (email) {
                              if (email != null && !EmailValidator.validate(email)) {
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
                              passwordVisibility: data.getPasswordVisibility,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field cannot be empty";
                                } else
                                  return null;
                              }),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        WelcomeButton(
                          color: Colors.white,
                          height: 45,
                          onPressed: () async {
                            final form = _formKey.currentState!;

                            if (form.validate()) {
                              await signUpOnPressed(context);
                            }
                          },
                          text: "Create Account",
                          textColor: Colors.black,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 45,
            child: FadeInMessageBox(animationController: _animationController, width: width),
          ),
          Positioned(
            child: Consumer<LoadingProvider>(
              builder: (context, loading, child) => Visibility(
                visible: loading.loadingStatus,
                child: Container(
                  height: height,
                  color: Colors.black.withOpacity(0.5),
                  child:Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   child: Consumer<LoadingProvider>(
          //     builder: (context, loading, child) => Visibility(
          //       visible: loading.loadingStatus,
          //       child: Center(
          //         child: LoadingAnimationWidget.staggeredDotsWave(
          //           color: Colors.white,
          //           size: 50,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Future<void> signUpOnPressed(BuildContext context) async {
    final messageProvider = Provider.of<AuthenticationMessageProvider>(context, listen: false);
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    loadingProvider.changeLoadingStatus(true);
    FocusScope.of(context).unfocus();

    final message =
        await AuthenticationService.signUp(email: _emailController.text, password: _passwordController.text);
    if (message != "true") {
      loadingProvider.changeLoadingStatus(false);
      _animationController.forward();
      messageProvider.changeMessage(message);
      await Future.delayed(Duration(seconds: 2));
      _animationController.reverse();
    } else {
      Navigator.pop(context);
      loadingProvider.changeLoadingStatus(false);
    }
  }
}
