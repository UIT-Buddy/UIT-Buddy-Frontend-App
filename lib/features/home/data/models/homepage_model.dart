import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/home/data/models/incoming_course_model.dart';
import 'package:uit_buddy_mobile/features/home/data/models/incoming_deadline_model.dart';
import 'package:uit_buddy_mobile/features/home/data/models/homepage_paging_model.dart';

part 'homepage_model.freezed.dart';
part 'homepage_model.g.dart';

@freezed
abstract class HomePageModel with _$HomePageModel {
  const factory HomePageModel({
    required String studentName,
    required int todayClass,
    required int unreadNotificationCount,
    IncomingCourseModel? incomingCourse,
    @JsonKey(name: 'totalDealineCount') required int totalDeadlineCount,
    required List<IncomingDeadlineModel> incomingDeadlines,
    required HomepagePagingModel paging,
  }) = _HomePageModel;

  factory HomePageModel.fromJson(Map<String, dynamic> json) =>
      _$HomePageModelFromJson(json);
}
