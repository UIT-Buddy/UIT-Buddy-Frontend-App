enum SharedMediaType { image, file }

class SharedMediaEntity {
  final String id;
  final SharedMediaType type;
  final String url;
  final String? fileName;
  final String? fileSize;
  final DateTime sharedAt;

  const SharedMediaEntity({
    required this.id,
    required this.type,
    required this.url,
    this.fileName,
    this.fileSize,
    required this.sharedAt,
  });
}
