class MessageModel {
  final String text;
  final String userId;
  final int createdAt;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createdAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        createdAt = json['createdAt'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
    };
  }
}
