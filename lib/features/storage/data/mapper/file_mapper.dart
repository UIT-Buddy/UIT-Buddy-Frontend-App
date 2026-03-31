import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';

extension FileMapper on FileModel {
  FileEntity toEntity() => FileEntity(
    id: id,
    name: name,
    url: url,
    size: size,
    sizeUnit: sizeUnit,
    type: _mapFileType(type),
  );
}

FileType _mapFileType(String type) {
  switch (type.toUpperCase()) {
    case 'WORD':
    case 'DOC':
    case 'DOCX':
      return FileType.word;
    case 'IMAGE':
    case 'JPG':
    case 'JPEG':
    case 'PNG':
    case 'GIF':
      return FileType.image;
    case 'VIDEO':
    case 'MP4':
    case 'MKV':
    case 'AVI':
      return FileType.video;
    case 'EXCEL':
    case 'XLS':
    case 'XLSX':
      return FileType.excel;
    case 'PPT':
    case 'PPTX':
      return FileType.ppt;
    default:
      return FileType.other;
  }
}
