
class CommentAuthorEntity {
  final String mssv;
  final String fullName;
  final String? avatarUrl;

  const CommentAuthorEntity({
    required this.mssv,
    required this.fullName,
    this.avatarUrl,
  });

  String get avatarLetter =>
      fullName.isNotEmpty ? fullName.split(' ').last[0].toUpperCase() : '?';
}

class CommentEntity {
  final String id;
  final String content;
  final CommentAuthorEntity? author;
  final int likeCount;
  final int replyCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentId;

  const CommentEntity({
    required this.id,
    required this.content,
    this.author,
    required this.likeCount,
    required this.replyCount,
    this.isLiked = false,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
  });

  bool get isReply => parentId != null;


  CommentEntity copyWith({
    String? id,
    String? content,
    CommentAuthorEntity? author,
    int? likeCount,
    int? replyCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentId,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
    );
  }
}
