class SearchUserModel {
  const SearchUserModel({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      mssv: (json['mssv'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? '',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  final String mssv;
  final String fullName;
  final String? avatarUrl;
}
