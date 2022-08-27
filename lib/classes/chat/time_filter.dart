import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeFilter{

  static String timeStampToValidTime(Timestamp timestamp){
    DateTime date = DateTime.now();
    DateTime userTimeStamp = timestamp.toDate();

    if(date.year == userTimeStamp.year){
      if(date.month == userTimeStamp.month){
        if(date.day == userTimeStamp.day){
          return DateFormat('hh:mm a').format(userTimeStamp);
        }
        else if(userTimeStamp.day == date.day -1){
          return "Yesterday";
        }
        else{
          return DateFormat("dd/MM/yy").format(userTimeStamp);
        }
      }
      else{
        return DateFormat("dd/MM/yy").format(userTimeStamp);
      }
    }
    else{
      return DateFormat("dd/MM/yy").format(userTimeStamp);

    }

  }

}