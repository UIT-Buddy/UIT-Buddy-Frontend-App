import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String content;
  final List<String> mediaUrls;
  final int likeCount;
  final int commentCount;
  final int shareCount;

  const PostEntity({
    required this.id,
    required this.user,
    required this.content,
    required this.mediaUrls,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount
  });

  @override
  List<Object?> get props => [
    id,
    user,
    content,
    mediaUrls,
    likeCount,
    commentCount,
    shareCount
  ];
}

class UserEntity extends Equatable {
  final String name;
  final String homeClass;
  final String avatarUrl;

  const UserEntity({
    required this.name,
    required this.homeClass,
    required this.avatarUrl
  });

  @override
  List<Object?> get props => [
    name,
    homeClass,
    avatarUrl,
  ];
}