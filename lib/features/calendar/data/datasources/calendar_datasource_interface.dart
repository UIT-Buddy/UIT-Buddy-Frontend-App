import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/calendar_deadline_model.dart';

abstract interface class CalendarDatasourceInterface {
  Future<ApiResponse<CalendarDeadlineModel>> getDeadline({
    required int month,
    required int year,
  });
}
