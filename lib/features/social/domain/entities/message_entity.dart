class MessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final String time;
  final bool isMine;
  final MessageType type;
  final String receiverId;
  final bool isGroup;
  final bool isEdited;

  /// Raw sent timestamp — used for accurate time-gap calculation between messages.
  final DateTime? sentAtRaw;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.time,
    required this.isMine,
    required this.receiverId,
    required this.isGroup,
    this.isEdited = false,
    this.type = MessageType.text,
    this.sentAtRaw,
  });
}

enum MessageType { text, image, system }
