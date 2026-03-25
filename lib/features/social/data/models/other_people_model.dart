import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_people_model.freezed.dart';
part 'other_people_model.g.dart';

@freezed
abstract class OtherPeopleModel with _$OtherPeopleModel {
  const factory OtherPeopleModel({
    required String mssv,
    required String fullName,
    required String email,
    String? avatarUrl,
    String? bio,
    String? homeClassCode,
    String? cometUid,
    String? friendStatus,
  }) = _OtherPeopleModel;

  factory OtherPeopleModel.fromJson(Map<String, dynamic> json) =>
      _$OtherPeopleModelFromJson(json);
}
