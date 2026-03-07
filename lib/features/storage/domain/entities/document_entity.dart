import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class DocumentListEntity extends Equatable {
  final String classCode;
  final List<DocumentEntity> items;

  const DocumentListEntity({
    required this.classCode,
    required this.items
  });

  @override
  List<Object?> get props => [classCode, items];
}


enum AccessLevel {
    PRIVATE, PUBLIC, CLASS_ONLY
}

enum DocumentPriority {
    LOW, MEDIUM, HIGH, URGENT
}

@immutable
class DocumentEntity extends Equatable {
  final String id;
  final String classCode;
  final String fileUrl;
  final String fileName;
  final AccessLevel accessLevel;
  final DocumentPriority priority;

  const DocumentEntity({
    required this.id,
    required this.classCode,
    required this.fileUrl,
    required this.fileName,
    required this.accessLevel,
    required this.priority,
  });

  @override
  List<Object?> get props => [id, classCode, fileUrl, fileName, accessLevel, priority];
}