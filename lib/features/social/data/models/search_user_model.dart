class SearchUserModel {
  const SearchUserModel({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
    this.friendStatus,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      mssv: (json['mssv'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      friendStatus: _parseFriendStatus(json),
    );
  }

  final String mssv;
  final String fullName;
  final String? avatarUrl;
  final String? friendStatus;

  static String? _parseFriendStatus(Map<String, dynamic> json) {
    final rawValue =
        json['friendStatus'] ?? json['relationshipStatus'] ?? json['status'];
    return rawValue?.toString().trim();
  }
}
