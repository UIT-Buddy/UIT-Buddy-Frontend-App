class ChatMemberEntity {
  final String id;
  final String name;
  final String avatarUrl;
  final String? nickname;
  final bool isAdmin;
  final bool isOnline;

  const ChatMemberEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.nickname,
    this.isAdmin = false,
    this.isOnline = false,
  });
}
