class MessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final String time;
  final bool isMine;
  final MessageType type;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.time,
    required this.isMine,
    this.type = MessageType.text,
  });
}

enum MessageType { text, image, system }
