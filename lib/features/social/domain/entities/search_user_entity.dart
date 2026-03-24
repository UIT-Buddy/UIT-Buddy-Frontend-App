class SearchUserEntity {
  const SearchUserEntity({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
  });

  final String mssv;
  final String fullName;
  final String? avatarUrl;

  String get avatarLetter => fullName.isNotEmpty
      ? fullName.trim().split(' ').last[0].toUpperCase()
      : '?';
}
