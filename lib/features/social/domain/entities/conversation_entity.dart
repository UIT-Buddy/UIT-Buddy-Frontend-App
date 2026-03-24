class ConversationEntity {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final bool isOnline;

  /// "user" or "group" — mirrors CometChat's conversationType field.
  final String conversationType;

  const ConversationEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isOnline = false,
    this.conversationType = 'user',
  });
}
