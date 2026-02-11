class MessageType {
  final String msgType;
  final String description;

  MessageType({required this.msgType, required this.description});

  factory MessageType.fromJson(Map<String, dynamic> json) {
    return MessageType(
      msgType: json['msgType'] as String,
      description: json['description'] as String,
    );
  }
}
