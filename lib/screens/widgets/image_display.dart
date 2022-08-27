import 'dart:io';

import 'package:chadate_alpha/my_provider/authenticiation_screens/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  Future getImage() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var tempImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    var getImageProvider = Provider.of<MyImageProvider>(context, listen: false);

    getImageProvider.changeProfilePic(tempImage);
    print(getImageProvider.getProfilePic());
  }

  @override
  Widget build(BuildContext context) {
    print('image display');
    return Provider.of<MyImageProvider>(
              context,
            ).getProfilePic() ==
            null
        ? GestureDetector(
            onTap: getImage,
            child: Container(
              margin: EdgeInsets.all(20),
              // padding: EdgeInsets.all(20),
              height: 100,
              width: 100,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
              child: Icon(
                Icons.person,
                size: 45,
              ),
            ),
          )
        : GestureDetector(
            onTap: getImage,
            child: Container(
              margin: EdgeInsets.all(20),
              // padding: EdgeInsets.all(20),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: Image.file(
                        File(Provider.of<MyImageProvider>(
                          context,
                        ).getProfilePic()!.path),
                      ).image,
                      fit: BoxFit.fill)),
            ),
          );
  }
}
