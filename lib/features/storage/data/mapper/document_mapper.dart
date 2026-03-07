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
      return AccessLevel.PRIVATE;
    case 'CLASS_ONLY':
      return AccessLevel.CLASS_ONLY;
    default:
      return AccessLevel.PUBLIC;
  }
}

DocumentPriority _mapPriority(String priority) {
  switch (priority.toUpperCase()) {
    case 'MEDIUM':
      return DocumentPriority.MEDIUM;
    case 'HIGH':
      return DocumentPriority.HIGH;
    case 'URGENT':
      return DocumentPriority.URGENT;
    default:
      return DocumentPriority.LOW;
  }
}
