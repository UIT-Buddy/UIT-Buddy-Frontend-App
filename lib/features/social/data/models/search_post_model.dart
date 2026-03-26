import 'package:uit_buddy_mobile/features/social/data/models/post_media_model.dart';

class SearchPostAuthorModel {
  const SearchPostAuthorModel({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
    this.homeClassCode,
  });

  factory SearchPostAuthorModel.fromJson(Map<String, dynamic> json) {
    return SearchPostAuthorModel(
      mssv: (json['mssv'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      homeClassCode: json['homeClassCode'] as String?,
    );
  }

  final String mssv;
  final String fullName;
  final String? avatarUrl;
  final String? homeClassCode;
}

class SearchPostModel {
  const SearchPostModel({
    required this.id,
    required this.title,
    required this.contentSnippet,
    required this.medias,
    this.author,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLiked,
    required this.createdAt,
  });

  factory SearchPostModel.fromJson(Map<String, dynamic> json) {
    final rawMedias = json['medias'] as List<dynamic>? ?? const [];
    final rawAuthor = json['author'];

    return SearchPostModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      contentSnippet: (json['contentSnippet'] as String?) ?? '',
      medias: rawMedias
          .whereType<Map<String, dynamic>>()
          .map(PostMediaModel.fromJson)
          .toList(),
      author: rawAuthor is Map<String, dynamic>
          ? SearchPostAuthorModel.fromJson(rawAuthor)
          : null,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final String id;
  final String title;
  final String contentSnippet;
  final List<PostMediaModel> medias;
  final SearchPostAuthorModel? author;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final DateTime createdAt;
}
