enum FriendStatus { none, pending, friends }

extension FriendStatusX on FriendStatus {
  String get label => switch (this) {
    FriendStatus.none => 'Add Friend',
    FriendStatus.pending => 'Pending',
    FriendStatus.friends => 'Friends',
  };
}

class SearchUserEntity {
  const SearchUserEntity({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
    this.friendStatus = FriendStatus.none,
  });

  final String mssv;
  final String fullName;
  final String? avatarUrl;
  final FriendStatus friendStatus;

  String get avatarLetter => fullName.isNotEmpty
      ? fullName.trim().split(' ').last[0].toUpperCase()
      : '?';
}
