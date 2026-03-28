class ConversationEntity {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isGroup;
  final bool isOnline;
  final String? conversationWith;

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
    this.conversationWith,
  });

  ConversationEntity copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isGroup,
    bool? isOnline,
    String? conversationType,
    String? conversationWith,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      isOnline: isOnline ?? this.isOnline,
      conversationType: conversationType ?? this.conversationType,
      conversationWith: conversationWith ?? this.conversationWith,
    );
  }
}
