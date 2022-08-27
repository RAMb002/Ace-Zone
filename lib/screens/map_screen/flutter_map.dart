import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/my_provider/home_screen/bottom_navigation_index.dart';
import 'package:chadate_alpha/my_provider/home_screen/home/profile_visibility.dart';
import 'package:chadate_alpha/screens/map_screen/bottom_container.dart';
import 'package:chadate_alpha/screens/map_screen/bottom_container_loading.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latLng;

import 'package:flutter_map/flutter_map.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class FlutterMapWidget extends StatefulWidget {
  const FlutterMapWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FlutterMapWidget> createState() => _FlutterMapWidgetState();
}

class _FlutterMapWidgetState extends State<FlutterMapWidget> {

  @override
  Widget build(BuildContext context) {

    // print(FirebaseAuth.instance.currentUser?.refreshToken);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('flutter map');
    return StreamBuilder(
      stream: FirebaseStream.coordinateSnapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        // print('000000000');
        // print(snapshot.data.docs[0]['userId']);
        // print(snapshot.data.docs[0]['geoPoint'].latitude);
        return  Stack(
          alignment: AlignmentDirectional.center,
          children: [
           StreamBuilder(
             stream: FirebaseStream.getUserCoordinates(AuthData.userId),
               builder: (BuildContext context,AsyncSnapshot userSnapshot){
             if(userSnapshot.hasData){
               return  FlutterMap(
                 // mapController: MapController().,

                 options: MapOptions(
                   center: latLng.LatLng(snapshot.data.docs[0]["geoPoint"].latitude,snapshot.data.docs[0]["geoPoint"].longitude),
                   zoom: 15.0,
                 ),
                 layers: [
                   TileLayerOptions(
                     urlTemplate: Provider.of<MyThemesProvider>(context).getThemeMode() == ThemeMode.dark
                         ? "https://api.mapbox.com/styles/v1/rambo1234/cl02kdbkf000514p8016gsygr/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFtYm8xMjM0IiwiYSI6ImNsMDJrMWp1cDAzeGkzbHFkbzR1MDNraTMifQ.CGg71wp98Ogpfmbck2OUKg"
                         : "https://api.mapbox.com/styles/v1/rambo1234/cl02kr8ai017u14p8sde7r3wo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFtYm8xMjM0IiwiYSI6ImNsMDJrMWp1cDAzeGkzbHFkbzR1MDNraTMifQ.CGg71wp98Ogpfmbck2OUKg",
                     subdomains: ['a', 'b', 'c'],
                     // attributionBuilder: (_) {
                     //   return Text("© OpenStreetMap contributors");
                     // },
                   ),
                   MarkerLayerOptions(

                     // rebuild: FirebaseApi.shit(),
                     markers: [
                       for(int i=0;i< snapshot.data.docs.length;i++)
                       // snapshot.data.docs[i].geoPoint.latitude
                         Marker(
                           width: 50.0,
                           height: 50.0,
                           point: latLng.LatLng(snapshot.data.docs[i]['geoPoint'].latitude,snapshot.data.docs[i]['geoPoint'].longitude),
                           builder: (ctx) => GestureDetector(
                             onTap: () {
                               if(snapshot.data.docs[i]['userId'] != AuthData.userId) {
                                 // print("000000000000000");
                                 // print(snapshot.data.docs[i]['userId']);
                                 // print(AuthData.userId);
                                 // print(i);
                                 final pProfileVisibility = Provider.of<ProfileVisibilityProvider>(
                                     context, listen: false);
                                 pProfileVisibility.changeI(i);
                                 pProfileVisibility.changeStatus(true);
                               }
                               // showDialog(
                               //     context: context,
                               //     barrierColor: Colors.black45,
                               //     builder: (BuildContext context) {
                               //       return Visibility(
                               //           visible: Provider.of<BottomNavigationIndex>(context).getIndex() == 0,
                               //           child: BottomContainer());
                               //     });

                               // showModalBottomSheet(
                               //   // barrierColor: Colors.red,
                               //   backgroundColor: Colors.transparent,
                               //     context: context,
                               //     enableDrag: false,
                               //     builder:(BuildContext context){
                               //       return Visibility(
                               //         visible: Provider.of<BottomNavigationIndex>(context).getIndex() ==0,
                               //           child: BottomContainer());
                               //     });
                               print('hello');
                             },
                             child: Image(
                                 height: 80,
                                 width: 150,
                                 color: snapshot.data.docs[i]['userId'] != AuthData.userId ? Colors.red : Colors.blue,

                                 image:  AssetImage(
                                   "images/marker.png",
                                 )
                             ),

                             // Container(
                             //   // height: 40,
                             //   // width: 40,
                             //   decoration: BoxDecoration(
                             //     shape: BoxShape.values[BoxShape.circle.index],
                             //     // color: i==0 ? Colors.red : Colors.blue,
                             //     image: DecorationImage(
                             //       image: AssetImage(
                             //         "images/marker.png",
                             //       )
                             //     )
                             //     // borderRadius: BorderRadius.only(bottomLeft :Radius.circular(140),bottomRight:Radius.circular(240) )
                             //   ),
                             // ),
                           ),
                         ),
                     ],
                   ),
                 ],
               );
             }
             else{
               return Center(
                 child: LoadingAnimationWidget.threeArchedCircle(
                   color: Colors.lightBlueAccent,
                   // secondRingColor: Colors.blue,
                   // thirdRingColor: Colors.white,
                   size: 45,
                 ),
               );
             }
           }),
            Positioned(
              child: Consumer<ProfileVisibilityProvider>(
                builder: (context,visibility,_)=>
                    Visibility(
                      visible: visibility.status,
                      child: Stack(
                        // alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              print('tap');
                              visibility.changeStatus(false);
                            },
                            child: Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                              top: screenHeight * 0.175,
                            // top: 100,
                              // bottom: 50,
                              child:
                              // BottomContainerLoading(),
                              BottomContainer(userId: snapshot.data.docs[visibility.i]['userId']),

                          ),
                        ],
                      ),
                    ),
              ),
            ),

          ],
        );

      }
      else return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Colors.lightBlueAccent,
          // secondRingColor: Colors.blue,
          // thirdRingColor: Colors.white,
          size: 45,
        ),
      );
    });
  }
}
