import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/sub_folder_model.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
abstract class FolderModel with _$FolderModel {
  const factory FolderModel({
    required String id,
    required String name,
    required String path,
    required String parentFolderId,
    @Default([]) List<SubFolderModel> folders,
    @Default([]) List<FileModel> files,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);
}
