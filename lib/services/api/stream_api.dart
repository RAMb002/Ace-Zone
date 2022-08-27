// import 'package:http/http.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
//
// class StreamApi{
//
//   static Future initUser(
//       StreamChatClient client,{
//         required String userName,
//         required String urlImage,
//         required String id,
//         required String token,
// })async{
//     final user = User(
//       id : id,
//       extraData: {
//         "name" : userName,
//         "image" : urlImage
//       }
//     );
//     await client.connectUser(user, token);
//   }
//
//   static  createChannel(
//       StreamChatClient client,{
//         required String type,
//         required String id,
//         List<String> idMembers = const[]
// }
//       )async{
//
//   }
//
//
// }