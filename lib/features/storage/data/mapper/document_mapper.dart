import 'package:uit_buddy_mobile/features/storage/data/models/document_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';

extension DocumentMapper on DocumentModel {
  DocumentEntity toEntity() => DocumentEntity(
    id: id,
    classCode: classCode,
    fileUrl: fileUrl,
    fileName: fileName,
    accessLevel: _mapAccessLevel(accessLevel),
    priority: _mapPriority(priority),
  );
}

extension DocumentListMapper on DocumentListModel {
  DocumentListEntity toEntity() => DocumentListEntity(
    classCode: classCode,
    items: items.map((e) => e.toEntity()).toList(),
  );
}

AccessLevel _mapAccessLevel(String level) {
  switch (level.toUpperCase()) {
    case 'PRIVATE':
      return AccessLevel.private;
    case 'CLASS_ONLY':
      return AccessLevel.classOnly;
    default:
      return AccessLevel.public;
  }
}

DocumentPriority _mapPriority(String priority) {
  switch (priority.toUpperCase()) {
    case 'MEDIUM':
      return DocumentPriority.medium;
    case 'HIGH':
      return DocumentPriority.high;
    case 'URGENT':
      return DocumentPriority.urgent;
    default:
      return DocumentPriority.low;
  }
}
