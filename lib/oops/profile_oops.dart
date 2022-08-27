import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileOops{
   String userName ="";
   String emailId ="";
   String photoUrl ="";
   String phoneNumber ="";
   String occupation ="";
   String officeAddress ="";
   String companyName ="";
   String bio ="";
   GeoPoint geoPoint=GeoPoint(0,0);


   Map<String,dynamic> profileData(){
      return ({

         'userName' : userName,
         'emailId' : emailId,
         'photoUrl' : photoUrl,
         'phoneNumber' : phoneNumber,
         'occupation' : occupation,
         'officeAddress' : officeAddress,
         'companyName' : companyName,
         'bio' : bio,
         'geoPoint' : geoPoint,
      });
   }
}

class Coordinates{
   String userId ="";
   GeoPoint geoPoint = GeoPoint(0, 0);

   Map<String,dynamic> coordinatesData(){
      return ({
         'geoPoint' : geoPoint,
         'userId' : userId
      });
   }

}