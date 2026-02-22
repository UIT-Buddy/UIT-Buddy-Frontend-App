import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/calendar_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/calendar_deadline_model.dart';

class CalendarDatasourceImpl implements CalendarDatasourceInterface {
  @override
  Future<ApiResponse<CalendarDeadlineModel>> getDeadline({
    required int month,
    required int year,
  }) async {
    try {
      // Simulate API call with a delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mocked API response
      final apiResponse = ApiResponse<CalendarDeadlineModel>(
        data: CalendarDeadlineModel(
          month: month,
          year: year,
          items: [
            CalendarDeadlineItemModel(
              day: 5,
              status: 'upcoming',
              details: [
                DeadlineDetailModel(
                  id: '1',
                  title: 'Nộp bài công nghệ web tuần 6',
                  status: 'upcoming',
                  courseId: 'SE347.Q14',
                  deadline: '2026-02-05T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '2',
                  title: 'Bài tập lập trình hướng đối tượng - Chương 3',
                  status: 'upcoming',
                  courseId: 'IT001.O11',
                  deadline: '2026-02-05T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '3',
                  title: 'Thực hành cơ sở dữ liệu - Lab 4',
                  status: 'upcoming',
                  courseId: 'IT004.O21',
                  deadline: '2026-02-05T23:59:00Z',
                ),
              ],
            ),
            CalendarDeadlineItemModel(
              day: 10,
              status: 'upcoming',
              details: [
                DeadlineDetailModel(
                  id: '4',
                  title: 'Báo cáo tiểu luận môn Trí tuệ nhân tạo',
                  status: 'upcoming',
                  courseId: 'CS106.O11',
                  deadline: '2026-02-10T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '5',
                  title: 'Bài tập nhóm Phát triển ứng dụng di động',
                  status: 'upcoming',
                  courseId: 'SE121.O11',
                  deadline: '2026-02-10T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '6',
                  title: 'Nộp slide thuyết trình Quản lý dự án phần mềm',
                  status: 'upcoming',
                  courseId: 'SE330.O12',
                  deadline: '2026-02-10T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '7',
                  title: 'Đề cương chi tiết cho đồ án môn Mạng máy tính',
                  status: 'upcoming',
                  courseId: 'NT106.O21',
                  deadline: '2026-02-10T23:59:00Z',
                ),
              ],
            ),
            CalendarDeadlineItemModel(
              day: 15,
              status: 'nearDeadline',
              details: [
                DeadlineDetailModel(
                  id: '8',
                  title: 'Báo cáo thực hành An toàn thông tin',
                  status: 'nearDeadline',
                  courseId: 'NT101.O22',
                  deadline: '2026-02-15T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '9',
                  title: 'Bài tập lớn Phân tích thiết kế hệ thống',
                  status: 'nearDeadline',
                  courseId: 'SE103.O11',
                  deadline: '2026-02-15T23:59:00Z',
                ),
              ],
            ),
            CalendarDeadlineItemModel(
              day: 20,
              status: 'nearDeadline',
              details: [
                DeadlineDetailModel(
                  id: '10',
                  title: 'Nộp code nguồn đồ án Kiến trúc phần mềm',
                  status: 'nearDeadline',
                  courseId: 'SE400.O11',
                  deadline: '2026-02-20T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '11',
                  title: 'Bài tập Học máy và Khai phá dữ liệu',
                  status: 'nearDeadline',
                  courseId: 'CS114.O11',
                  deadline: '2026-02-20T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '12',
                  title: 'Tiểu luận cuối kỳ môn Công nghệ phần mềm',
                  status: 'nearDeadline',
                  courseId: 'SE104.O21',
                  deadline: '2026-02-20T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '13',
                  title: 'Demo sản phẩm môn Thương mại điện tử',
                  status: 'nearDeadline',
                  courseId: 'SE358.O11',
                  deadline: '2026-02-20T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '14',
                  title: 'Báo cáo tiến độ Đồ án chuyên ngành',
                  status: 'nearDeadline',
                  courseId: 'SE490.O11',
                  deadline: '2026-02-20T23:59:00Z',
                ),
              ],
            ),
            CalendarDeadlineItemModel(
              day: 25,
              status: 'nearDeadline',
              details: [
                DeadlineDetailModel(
                  id: '15',
                  title: 'Nộp bài tập Xử lý ảnh và Thị giác máy tính',
                  status: 'nearDeadline',
                  courseId: 'CS406.O11',
                  deadline: '2026-02-25T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '16',
                  title: 'Thực hành DevOps và CI/CD - Sprint 3',
                  status: 'nearDeadline',
                  courseId: 'SE408.O11',
                  deadline: '2026-02-25T23:59:00Z',
                ),
                DeadlineDetailModel(
                  id: '17',
                  title: 'Bài tập nhóm Blockchain và ứng dụng',
                  status: 'nearDeadline',
                  courseId: 'CS420.O11',
                  deadline: '2026-02-25T23:59:00Z',
                ),
              ],
            ),
          ],
        ),
        message: 'Deadlines fetched successfully.',
        statusCode: 200,
      );

      return apiResponse;
    } catch (e) {
      return ApiResponse<CalendarDeadlineModel>(
        data: null,
        message: 'Failed to fetch deadlines.',
        statusCode: 500,
      );
    }
  }
}
