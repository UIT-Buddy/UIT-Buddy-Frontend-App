class FriendSummaryModel {
  const FriendSummaryModel({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
    this.cometUid,
  });

  factory FriendSummaryModel.fromJson(Map<String, dynamic> json) {
    return FriendSummaryModel(
      mssv: (json['mssv'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      cometUid: (json['cometUid'] as String?) ?? (json['uid'] as String?),
    );
  }

  final String mssv;
  final String fullName;
  final String? avatarUrl;
  final String? cometUid;
}

class FriendListItemModel {
  const FriendListItemModel({
    required this.id,
    required this.friend,
    this.createdAt,
  });

  factory FriendListItemModel.fromJson(Map<String, dynamic> json) {
    final rawFriend = json['friend'];

    return FriendListItemModel(
      id: (json['id'] as String?) ?? '',
      friend: rawFriend is Map<String, dynamic>
          ? FriendSummaryModel.fromJson(rawFriend)
          : const FriendSummaryModel(mssv: '', fullName: ''),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }

  final String id;
  final FriendSummaryModel friend;
  final DateTime? createdAt;
}
