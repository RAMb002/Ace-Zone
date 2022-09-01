import 'package:chadate_alpha/config.dart';
import 'package:chadate_alpha/my_provider/authenticiation_message.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/baka.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/displayname_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_controller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_otp_verification.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/email_verification_animatedbutton_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/image_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/pagecontroller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_visibility.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_auth_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/phone_authentication.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/my_provider/chat/chat_message/chat_message.dart';
import 'package:chadate_alpha/my_provider/home_screen/bottom_navigation_index.dart';
import 'package:chadate_alpha/my_provider/home_screen/home/profile_visibility.dart';
import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:chadate_alpha/my_provider/loading_provider.dart';
import 'package:chadate_alpha/my_provider/profile_screen/app_bar_color.dart';
import 'package:chadate_alpha/my_provider/profile_screen/photourl_name.dart';
import 'package:chadate_alpha/my_provider/search_screen/other_user.dart';
import 'package:chadate_alpha/my_provider/search_screen/third_chat.dart';
import 'package:chadate_alpha/my_provider/stream/client_and_channel.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/create_account_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/detail_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/new_create_account.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_authentication_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/reset_password_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/sign_in_screen/sign_in_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/welcome_screen/welcome_screen.dart';
import 'package:chadate_alpha/screens/loading_screen/loading_screen.dart';
import 'package:chadate_alpha/screens/map_screen/map_screen.dart';
import 'package:chadate_alpha/screens/page1.dart';
import 'package:chadate_alpha/screens/page2.dart';
import 'package:chadate_alpha/screens/profile_screen/user_profile.dart';
import 'package:chadate_alpha/screens/search_screen/search_screen.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as stream;
// import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // PhotoManager.setIgnorePermissionCheck(true);

  // await MyPreference.init();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  // final client = stream.StreamChatClient(Config.streamApiKey,logLevel:stream.Level.SEVERE);
  // final  User? user = FirebaseAuth.instance.currentUser;
  // print(user!.uid);
  // await client.connectUser(
  //   stream.User(id: user.uid),
  //   user!.refreshToken.toString()
  // );
  // final channel = client.channel('messaging',id: 'flutterdevs');
  // await channel.watch();


  runApp( MyApp());
}
// final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  // final stream.StreamChatClient client;
  // final stream.Channel channel;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Provider.of<ClientAndChannelProvider>(context,listen: false).changeChannel(channel);
    // Provider.of<ClientAndChannelProvider>(context,listen: false).changeClient(client);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeScreenSubIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyThemesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationIndex(),
        ),
        ChangeNotifierProvider(
          create: (context) => PasswordVisibilityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationMessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MailLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailVerificationAnimatedButtonProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailOtpVerification(),
        ),
        ChangeNotifierProvider(
          create: (context) => VerificationTruthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailControllerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PasswordLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageControllerIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>BakaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>ProfileVisibilityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>ChatMessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>DisplayNameController(),
        ),
        ChangeNotifierProvider(
          create: (context) =>ScrollAppBarColor(),
        ),
        ChangeNotifierProvider(
          create: (context) =>PhotoUrlName(),
        ),
        ChangeNotifierProvider(
          create: (context) =>OtherUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>ThirdChat(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) =>ClientAndChannelProvider(),
        // ),
      ],
      child: Consumer<MyThemesProvider>(
        builder: (context,data,child)=>
         MaterialApp(
           // navigatorKey: navigatorKey,
           debugShowCheckedModeBanner: false,
          title: 'Ace Zone',
          themeMode: data.getThemeMode(),
          theme: MyThemesProvider.lightTheme,
          darkTheme: MyThemesProvider.darkTheme,
          // theme: ThemeData(
          //
          //   primarySwatch: Colors.blue,
          // ),
          routes: {
            WelcomeScreen.name :(context) =>WelcomeScreen(),
            CreateAccountScreen.name:(context) => CreateAccountScreen(),
            SignInScreen.name:(context) => SignInScreen(),
            // ResetPasswordScreen.name : (context) => ResetPasswordScreen(),
            // PhoneAuthenticationScreen.name : (context) => PhoneAuthenticationScreen(),
            NewCreateAccountScreenMain.name : (context) => NewCreateAccountScreenMain(),
            'initial' :(context) => MapScreen(),

            'page1' :(context) => Page1(),
            'page2' :(context) => Page2(),
            SearchScreen.name:(context) => SearchScreen(),
            UserProfile.name:(context) => UserProfile(status: true,)

          },
          // initialRoute: WelcomeScreen.name,
          home: const LoadingScreenAlpha(),
          // home: const DetailScreen(editStatus: true),
        ),
      ),
    );
  }
}
