import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed
abstract class FileModel with _$FileModel {
  const factory FileModel({
    required String id,
    required String name,
    required String url,
    required double size,
    required String sizeUnit,
    required String type,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}
