import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_post_media_model.freezed.dart';
part 'your_post_media_model.g.dart';

@freezed
abstract class YourPostMediaModel with _$YourPostMediaModel {
  const factory YourPostMediaModel({
    required String type,
    required String url,
  }) = _PostMediaModel;

  factory YourPostMediaModel.fromJson(Map<String, dynamic> json) =>
      _$YourPostMediaModelFromJson(json);
}
