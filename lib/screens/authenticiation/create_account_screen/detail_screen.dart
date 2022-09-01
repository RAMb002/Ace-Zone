// import 'dart:io';

import 'dart:io';

import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_update.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/baka.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/image_provider.dart';
import 'package:chadate_alpha/my_provider/authenticiation_screens/password_loading.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/phone_otp_verification_screen.dart';
import 'package:chadate_alpha/screens/widgets/auth_detail_textformfield.dart';
import 'package:chadate_alpha/screens/widgets/image_display.dart';
import 'package:chadate_alpha/screens/widgets/my_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

const height = 8.0;

class DetailScreen extends StatefulWidget {
  const DetailScreen({
  Key? key,
  required this.editStatus,
  this.photoUrl ="",
    this.bio="",
    this.officeAddress ="",
    this.companyName ="",
    this.occupation = "",

  }) : super(key: key);

  final bool editStatus;
  final String photoUrl;
  final String bio;
  final String officeAddress;
  final String companyName;
  final String occupation;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _officeAddressController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _occupationController.text = widget.occupation;
    _officeAddressController.text = widget.officeAddress;
    _companyNameController.text = widget.companyName;
    _bioController.text = widget.bio;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _officeAddressController.dispose();
    _occupationController.dispose();
    _companyNameController.dispose();
    _bioController.dispose();
    super.dispose();
    // _userNameController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // print(widget.photoUrl + "d");

    _occupationController.addListener(() {
      Provider.of<BakaProvider>(context,listen: false).setBakaState();
    });
    _officeAddressController.addListener(() {
      Provider.of<BakaProvider>(context,listen: false).setBakaState();

    });
    _companyNameController.addListener(() {
      Provider.of<BakaProvider>(context,listen: false).setBakaState();

    });
    _bioController.addListener(() {
      Provider.of<BakaProvider>(context,listen: false).setBakaState();

    });
    final User? user = FirebaseAuth.instance.currentUser;
    print(user?.displayName);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: lPaddingFirstContainer,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                child: ListView(
                  children: [
                    ImageDisplay(
                      editStatus: widget.editStatus,
                      context: context,
                      photoUrl: widget.photoUrl,
                    ),
                    SizedBox(
                      height: height,
                    ),
                    AuthDetailTextFormField(
                      editStatus: widget.editStatus,
                        labelText: 'Occupation', controller: _occupationController, validator: (s) {}),
                    SizedBox(
                      height: height,
                    ),
                    AuthDetailTextFormField(
                        editStatus: widget.editStatus,
                        labelText: 'Office Address', controller: _officeAddressController, validator: (s) {}),
                    SizedBox(
                      height: height,
                    ),
                    AuthDetailTextFormField(
                        editStatus: widget.editStatus,
                        labelText: 'Company Name', controller: _companyNameController, validator: (s) {}),
                    SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      cursorColor: Colors.lightBlueAccent,
                      controller: _bioController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color: widget.editStatus ?Theme.of(context).colorScheme.primaryVariant : Colors.black38, width: 1),
                              borderRadius: lBorderRadius),
                          disabledBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:widget.editStatus ?Theme.of(context).colorScheme.primaryVariant : Colors.black38, width: 1),
                              borderRadius: lBorderRadius),
                          focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color:widget.editStatus ?Theme.of(context).primaryColorDark : Colors.black, width: 1.5),
                              borderRadius: lBorderRadius),
                          labelText: 'Bio',
                          labelStyle: TextStyle(color:widget.editStatus ?Theme.of(context).colorScheme.primaryVariant : Colors.black54)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Consumer<BakaProvider>(
                      builder: (context,baka,child)=>
                       Consumer<MyImageProvider>(
                        builder: (context,image,child) =>
                         FlatButton(
                          color: checkPresence(image) ? Colors.black : Colors.lightBlueAccent,
                          minWidth: double.infinity,
                          height: lFlatButtonHeight -10,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          onPressed: () async {
                            if(widget.editStatus){
                              onPressed(image);
                            }
                             else checkPresence(image) ? Navigator.pop(context) : onPressed(image) ;
                          },
                          shape: RoundedRectangleBorder(borderRadius: lBorderRadius),
                          child: Text(
                            widget.editStatus ? "Save" : checkPresence(image) ? 'Skip' : 'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
          PageLoader()
        ],
      ),
    );
  }
  bool checkPresence(MyImageProvider image){
    if(_occupationController.text.isEmpty && _officeAddressController.text.isEmpty &&
    _companyNameController.text.isEmpty && _bioController.text.isEmpty && image.getProfilePic()==null){
      return true;
    }
    else return false;
  }
  void onPressed(MyImageProvider image)async{
    final pLoader = Provider.of<PasswordLoadingProvider>(context,listen: false);
    String userId = _user!.uid;
    if(pLoader.loadingIndex ==0) {
      pLoader.changeLoadingIndex(1);
      if (image.getProfilePic() != null) {
        await uploadImage(context);
        print('ssssssssssssssssssssssssssssssssssssssssd');
      }

      if ((!widget.editStatus && _occupationController.text.isNotEmpty) || widget.editStatus) {
        await FirebaseUpdate.updateProfileData(userId, _occupationController.text, 'occupation');
        print('ocu updated');
      }
      if ((!widget.editStatus && _officeAddressController.text.isNotEmpty) || widget.editStatus) {
        await FirebaseUpdate.updateProfileData(userId, _officeAddressController.text, 'officeAddress');
        print('office updated');
      }
      if ((!widget.editStatus &&_companyNameController.text.isNotEmpty) || widget.editStatus) {
        await FirebaseUpdate.updateProfileData(userId, _companyNameController.text, 'companyName');
        print('company updated');
      }
      if ((!widget.editStatus &&_bioController.text.isNotEmpty) || widget.editStatus) {
        // if(_bioController.text.isEmpty) _bioController.text="";
       await FirebaseUpdate.updateProfileData(userId, _bioController.text, 'bio');
        print('bio updated');
      }
      pLoader.changeLoadingIndex(0);
      Navigator.pop(context);
    }

  }

  uploadImage(BuildContext context)async {
    final pLoader = Provider.of<PasswordLoadingProvider>(context,listen: false);

    print('started');
    String userId = _user!.uid;

    try {
      var getImageProvider = Provider.of<MyImageProvider>(context, listen: false);
      final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.', '-')
          .replaceAll(':', '-');
      print('saving');
      Reference ref = FirebaseStorage.instance
          .ref()
          .child(userId.toString())
          .child('profileData')
          .child("image1" + time.toString() + '.jpg');
      print('putting');
      UploadTask task = ref.putFile(File(getImageProvider.getProfilePic()!.path));
      // String downloadURL='';
      print('puttttt');
      TaskSnapshot storageTaskSnapshot = await task.whenComplete(() => print('completed'));
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      FirebaseUpdate.updateProfileData(userId, downloadUrl, 'photoUrl');
      await _user?.updatePhotoURL(downloadUrl.toString());

      // movieToFirebaseOops.image = downloadUrl;
      print(downloadUrl);
      // print(movieToFirebaseOops.image);
      print('photourl fetched');
    }
    catch(e){
      pLoader.changeLoadingIndex(0);
      print(e);
    }
    //

  }

}

