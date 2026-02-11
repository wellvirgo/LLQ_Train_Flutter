import 'package:to_do_app/models/message_type.dart';

class MessageTypeList {
  final List<MessageType> messageTypes;
  MessageTypeList({required this.messageTypes});

  factory MessageTypeList.fromJson(List<dynamic> json) {
    return MessageTypeList(
      messageTypes: json
          .map(
            (element) => MessageType.fromJson(element as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
