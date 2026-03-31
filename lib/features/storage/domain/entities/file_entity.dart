import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum FileType { word, image, video, excel, ppt, other }

// enum AccessLevel { private, public, classOnly }

// enum DocumentPriority { low, medium, high, urgent }

@immutable
class FileEntity extends Equatable {
  final String id;
  final String name;
  final String url;
  final double size;
  final String sizeUnit;
  final FileType type;
  // final AccessLevel accessLevel;
  // final DocumentPriority priority;

  const FileEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.size,
    required this.sizeUnit,
    required this.type,
  });

  FileEntity copyWith({
    String? id,
    String? name,
    String? url,
    double? size,
    String? sizeUnit,
    FileType? type,
  }) {
    return FileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      size: size ?? this.size,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, name, url, size, sizeUnit, type];
}
