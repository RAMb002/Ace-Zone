class ChatMessageLogOops{
  // final String photoUrl;
  // final String name;
  final String lastMessage;
  // final String timeOfMessage;
  // final String timeStamp;
  final String userId;

  ChatMessageLogOops({
    // required this.photoUrl,
    // required this.name,
    required this.lastMessage,
    // required this.timeOfMessage,
    // required this.timeStamp,
    required this.userId
});

  Map<String,dynamic> setMessageLog(){
    return {
      // "photoUrl" :photoUrl,
      // "name" : name,
      "lastMessage" : lastMessage,
      // "timeOfMessage" : timeOfMessage,
      "timeStamp" :DateTime.now(),
      "userId" : userId
    };
  }
}