import 'package:uit_buddy_mobile/features/storage/data/mapper/file_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/folder_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/sub_folder_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';

extension FolderMapper on FolderModel {
  FolderEntity toEntity() => FolderEntity(
    id: folderId,
    name: folderName,
    path: folderPath,
    parentFolderId: parentFolderId,
    accessRole: accessRole,
    folders: folders.map((e) => e.toEntity()).toList(),
    files: files.map((e) => e.toEntity()).toList(),
  );
}

extension SubFolderMapper on SubFolderModel {
  SubFolderEntity toEntity() => SubFolderEntity(
    id: folderId,
    name: folderName,
    itemCount: folderItemCount,
  );
}
