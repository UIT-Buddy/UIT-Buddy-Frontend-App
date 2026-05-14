import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_folder_model.freezed.dart';
part 'sub_folder_model.g.dart';

@freezed
abstract class SubFolderModel with _$SubFolderModel {
  const factory SubFolderModel({
    required String folderId,
    required String folderName,
    required int folderItemCount,
  }) = _SubFolderModel;

  factory SubFolderModel.fromJson(Map<String, dynamic> json) =>
      _$SubFolderModelFromJson(json);
}
