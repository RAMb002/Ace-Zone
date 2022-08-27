import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/pagecontroller.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/verification_truth.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/detail_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/mail_verification.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/password_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_authentication_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_otp_verification_screen.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/slide_dots.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/username.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCreateAccountScreenMain extends StatefulWidget {
   NewCreateAccountScreenMain({Key? key}) : super(key: key);

    static String name = 'NewCreateAccountScreenMain';

  @override
  State<NewCreateAccountScreenMain> createState() => _NewCreateAccountScreenMainState();
}

class _NewCreateAccountScreenMainState extends State<NewCreateAccountScreenMain> {
  final PageController _pageController = PageController(
    initialPage: 0
  );
  int _currentPage =0;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index){
    Provider.of<PageControllerIndexProvider>(context,listen: false).changeIndex(index);
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final verificationTruthProvider = Provider.of<VerificationTruthProvider>(context,listen: false);

    List<Widget> screenList =[
      UserName(pageController: _pageController,),
      MailVerificationScreen(pageController: _pageController),
      PasswordScreen(pageController: _pageController),
      PhoneAuthenticationScreen(pageController: _pageController),
      PhoneOtpVerification(pageController: _pageController,),
      DetailScreen(),
    ];
    print('helloss');
    print( Provider.of<VerificationTruthProvider>(context,listen: false).emailVerificationTruth);
    return WillPopScope(
      onWillPop: ()async{
        final pPasswordLoading = Provider.of<PasswordLoadingProvider>(context,listen: false);

        // if(_currentPage ==2 && verificationTruthProvider)
        // if(_currentPage ==4){
        //   return false;
        // }
        if(pPasswordLoading.loadingIndex ==1){
          return false;
        }
        else if(_currentPage==5){
          if(!verificationTruthProvider.phoneVerificationTruth) {
            print('hii');
            setState(() {
              _currentPage = 3;
              // _pageController.animateToPage(_currentPage, duration: lPageControllerDuration,
              //     curve: lPageControllerCurve);
              _pageController.jumpToPage(_currentPage,);
            });
            return false;
          }else{
            return false;
          }
        }
        else if(_currentPage==3 && verificationTruthProvider.emailVerificationTruth){
          print('phone verification true cant go back');
          return false;
        }
        // else if(_currentPage==2 && !verificationTruthProvider.phoneVerificationTruth){
        //   print('phone verification false going page 1');
        //   setState(() {
        //     _currentPage = 0;
        //     _pageController.animateToPage(_currentPage, duration: lPageControllerDuration,
        //         curve:lPageControllerCurve);
        //
        //   });
        //   return false;
        // }
        else if(_currentPage!=0){
          setState(() {
            _currentPage =_currentPage-1;
            _pageController.animateToPage(_currentPage, duration: lPageControllerDuration,
                curve:lPageControllerCurve);
          });
          return false;
        }
        else{
          return true;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Consumer<VerificationTruthProvider>(
      builder: (context,data,child)=>
            PageView.builder(
                physics: _currentPage ==0 && data.userNameVerificationTurth ? null : NeverScrollableScrollPhysics(),
                itemCount: screenList.length,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (ctx,index)=> screenList[index]
            ),
          ),
          Positioned(
            bottom: 20,
              child: Container(
            //     color: Colors.red,
            // height: 10,
            // width: 130,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i = 0;i<screenList.length;i++)
                  if(i==_currentPage)
                    SlideDots(isActive :true)
                  else
                    SlideDots(isActive: false)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
