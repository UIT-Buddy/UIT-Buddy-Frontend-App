import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class DocumentListModel extends Equatable {
  final String classCode;
  final List<DocumentModel> items;

  const DocumentListModel({
    required this.classCode,
    required this.items
  });

  @override
  List<Object?> get props => [classCode, items];
}

@immutable
class DocumentModel extends Equatable {
  final String id;
  final String classCode;
  final String fileUrl;
  final String fileName;
  final String accessLevel;
  final String priority;

  const DocumentModel({
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