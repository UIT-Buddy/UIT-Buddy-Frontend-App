import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_deadline_model.freezed.dart';
part 'incoming_deadline_model.g.dart';

@freezed
abstract class IncomingDeadlineModel with _$IncomingDeadlineModel {
  const factory IncomingDeadlineModel({
    required String id,
    required String deadlineName,
    required RemainingTimeModel remainingTime,
    required DateTime dueDate,
  }) = _IncomingDeadlineModel;

  factory IncomingDeadlineModel.fromJson(Map<String, dynamic> json) =>
      _$IncomingDeadlineModelFromJson(json);
}

@freezed
abstract class RemainingTimeModel with _$RemainingTimeModel {
  const factory RemainingTimeModel({
    required int unit,
    required String unitName,
  }) = _RemainingTimeModel;

  factory RemainingTimeModel.fromJson(Map<String, dynamic> json) =>
      _$RemainingTimeModelFromJson(json);
}
