class ChatTextingOops{
  String currentUserId;
  String message;

  ChatTextingOops({
    required this.currentUserId,
    required this.message,
});

  Map<String,dynamic> setPrivateChatData(){
    return {
      "currentUserId" : currentUserId,
      "message" : message,
      "timeStamp" : DateTime.now()
    };
  }
}