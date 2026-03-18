enum PostMediaType { image, video }

class PostMediaEntity {
  final PostMediaType type;
  final String url;

  const PostMediaEntity({required this.type, required this.url});
}
