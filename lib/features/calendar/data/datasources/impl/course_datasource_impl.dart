import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_details_model.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';

class CourseDatasourceImpl implements CourseDatasourceInterface {
  CourseDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;
  static const List<CourseModel> _sampleCourses = [
    CourseModel(courseId: 'SE347.Q11', courseName: 'Công nghệ web và ứng dụng'),
    CourseModel(
      courseId: 'SE214.Q11',
      courseName: 'Công nghệ phần mềm chuyên sâu',
    ),
    CourseModel(
      courseId: 'SE310.Q11',
      courseName: 'Phương pháp nghiên cứu khoa học',
    ),
    CourseModel(courseId: 'SE401.Q11', courseName: 'Đồ án tốt nghiệp'),
    CourseModel(courseId: 'SE313.Q11', courseName: 'Quản lý dự án phần mềm'),
    CourseModel(courseId: 'SE104.Q11', courseName: 'Nhập môn lập trình'),
    CourseModel(courseId: 'IT001.Q11', courseName: 'Nhập môn CNTT'),
    CourseModel(courseId: 'IT002.Q11', courseName: 'Lập trình hướng đối tượng'),
    CourseModel(courseId: 'MA006.Q11', courseName: 'Toán rời rạc'),
    CourseModel(courseId: 'PH001.Q11', courseName: 'Vật lý đại cương'),
  ];

  // ---------------------------------------------------------------------------
  // Sample timetable — Semester 2, 2026
  // dayOfWeek: 2=Mon 3=Tue 4=Wed 5=Thu 6=Fri 7=Sat  (Vietnamese convention)
  // Periods: P1 07:30 P2 08:15 P3 09:15 P4 10:00 P5 10:45
  //          P6 12:30 P7 13:15 P8 14:15 P9 15:00 P10 15:45
  // ---------------------------------------------------------------------------
  static const List<CourseDetailsModel> _semester2_2026 = [
    // Monday P1-P3  — SE347 Web Technology
    CourseDetailsModel(
      courseId: 'SE347',
      classId: 'SE347.Q14',
      courseName: 'Công nghệ web và ứng dụng',
      startPeriod: 1,
      endPeriod: 3,
      startTime: '07:30',
      endTime: '09:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 2,
      lecturer: 'TS. Nguyễn Văn An',
      room: 'B3.09',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd1',
          title: 'Nộp bài web tuần 6',
          status: 'upcoming',
          deadline: '2026-03-20T23:59:00',
        ),
        DeadlineDetailInCourseModel(
          id: 'd2',
          title: 'Đồ án giữa kỳ Web',
          status: 'nearDeadline',
          deadline: '2026-04-10T23:59:00',
        ),
      ],
    ),

    // Tuesday P4-P6  — IT002 OOP
    CourseDetailsModel(
      courseId: 'IT002',
      classId: 'IT002.O11',
      courseName: 'Lập trình hướng đối tượng',
      startPeriod: 4,
      endPeriod: 6,
      startTime: '10:00',
      endTime: '12:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 3,
      lecturer: 'ThS. Trần Thị Bích',
      room: 'B4.12',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd3',
          title: 'Bài tập OOP Chương 3',
          status: 'done',
          deadline: '2026-03-05T23:59:00',
        ),
        DeadlineDetailInCourseModel(
          id: 'd4',
          title: 'Bài tập OOP Chương 5',
          status: 'upcoming',
          deadline: '2026-04-01T23:59:00',
        ),
      ],
    ),

    // Wednesday P7-P9  — SE121 Mobile App Development
    CourseDetailsModel(
      courseId: 'SE121',
      classId: 'SE121.O11',
      courseName: 'Phát triển ứng dụng di động',
      startPeriod: 7,
      endPeriod: 9,
      startTime: '13:15',
      endTime: '15:45',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 4,
      lecturer: 'TS. Lê Hoàng Nam',
      room: 'B2.05',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd5',
          title: 'Bài tập nhóm Mobile tuần 5',
          status: 'upcoming',
          deadline: '2026-03-18T23:59:00',
        ),
      ],
    ),

    // Thursday P1-P3  — CS106 Artificial Intelligence
    CourseDetailsModel(
      courseId: 'CS106',
      classId: 'CS106.O11',
      courseName: 'Trí tuệ nhân tạo',
      startPeriod: 1,
      endPeriod: 3,
      startTime: '07:30',
      endTime: '09:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 5,
      lecturer: 'PGS.TS. Phạm Minh Tuấn',
      room: 'C1.03',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd6',
          title: 'Báo cáo tiểu luận AI',
          status: 'overdue',
          deadline: '2026-03-01T23:59:00',
        ),
        DeadlineDetailInCourseModel(
          id: 'd7',
          title: 'Đồ án cuối kỳ AI',
          status: 'upcoming',
          deadline: '2026-05-20T23:59:00',
        ),
      ],
    ),

    // Thursday P6-P8  — SE330 Software Project Management (same day, afternoon)
    CourseDetailsModel(
      courseId: 'SE330',
      classId: 'SE330.O12',
      courseName: 'Quản lý dự án phần mềm',
      startPeriod: 6,
      endPeriod: 8,
      startTime: '12:30',
      endTime: '15:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 5,
      lecturer: 'ThS. Võ Thị Lan',
      room: 'B5.07',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd8',
          title: 'Nộp slide thuyết trình QLDA',
          status: 'upcoming',
          deadline: '2026-04-05T23:59:00',
        ),
      ],
    ),

    // Friday P2-P4  — NT106 Computer Networks
    CourseDetailsModel(
      courseId: 'NT106',
      classId: 'NT106.O21',
      courseName: 'Mạng máy tính',
      startPeriod: 2,
      endPeriod: 4,
      startTime: '08:15',
      endTime: '10:45',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 6,
      lecturer: 'TS. Hoàng Văn Đức',
      room: 'A1.08',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd9',
          title: 'Đề cương đồ án Mạng',
          status: 'upcoming',
          deadline: '2026-03-25T23:59:00',
        ),
        DeadlineDetailInCourseModel(
          id: 'd10',
          title: 'Báo cáo lab Mạng tuần 8',
          status: 'nearDeadline',
          deadline: '2026-04-08T23:59:00',
        ),
      ],
    ),

    // Saturday P1-P3  — IT004 Database Systems
    CourseDetailsModel(
      courseId: 'IT004',
      classId: 'IT004.O21',
      courseName: 'Cơ sở dữ liệu',
      startPeriod: 1,
      endPeriod: 3,
      startTime: '07:30',
      endTime: '09:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 3,
      dayOfWeek: 7,
      lecturer: 'TS. Nguyễn Thị Hoa',
      room: 'C2.11',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd11',
          title: 'Thực hành CSDL Lab 4',
          status: 'done',
          deadline: '2026-03-07T23:59:00',
        ),
        DeadlineDetailInCourseModel(
          id: 'd12',
          title: 'Đồ án CSDL cuối kỳ',
          status: 'upcoming',
          deadline: '2026-05-30T23:59:00',
        ),
      ],
    ),

    // Monday P4-P6  — SE347.Q14.1 (lab section of SE347.Q14, same colour)
    CourseDetailsModel(
      courseId: 'SE347',
      classId: 'SE347.Q14.1',
      labOfClassId: 'SE347.Q14',
      courseName: 'Công nghệ web và ứng dụng (Lab)',
      startPeriod: 4,
      endPeriod: 6,
      startTime: '10:00',
      endTime: '12:00',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 0,
      dayOfWeek: 2,
      lecturer: 'TS. Nguyễn Văn An',
      room: 'B3.01',
      deadlines: [],
    ),

    // Blended Learning — SE401 Graduation Project (no fixed period, shown in BL row)
    CourseDetailsModel(
      courseId: 'SE401',
      classId: 'SE401.Q11',
      isBlendedLearning: true,
      courseName: 'Đồ án tốt nghiệp',
      startPeriod: 0,
      endPeriod: 0,
      startTime: '',
      endTime: '',
      startDate: '2026-02-09',
      endDate: '2026-06-15',
      credits: 10,
      dayOfWeek: 2,
      lecturer: 'PGS.TS. Phạm Minh Tuấn',
      room: 'Online',
      deadlines: [
        DeadlineDetailInCourseModel(
          id: 'd13',
          title: 'Nộp đề cương đồ án',
          status: 'upcoming',
          deadline: '2026-03-15T23:59:00',
        ),
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // Sample timetable — Semester 1, 2026
  // ---------------------------------------------------------------------------
  static const List<CourseDetailsModel> _semester1_2026 = [
    CourseDetailsModel(
      courseId: 'SE214',
      classId: 'SE214.Q11',
      courseName: 'Công nghệ phần mềm chuyên sâu',
      startPeriod: 1,
      endPeriod: 3,
      startTime: '07:30',
      endTime: '09:00',
      startDate: '2025-09-01',
      endDate: '2026-01-15',
      credits: 3,
      dayOfWeek: 2,
      lecturer: 'PGS.TS. Bùi Hoài Thắng',
      room: 'B3.10',
      deadlines: [],
    ),
    CourseDetailsModel(
      courseId: 'MA006',
      classId: 'MA006.Q11',
      courseName: 'Toán rời rạc',
      startPeriod: 4,
      endPeriod: 6,
      startTime: '10:00',
      endTime: '12:00',
      startDate: '2025-09-01',
      endDate: '2026-01-15',
      credits: 3,
      dayOfWeek: 4,
      lecturer: 'TS. Đinh Xuân Lộc',
      room: 'C3.01',
      deadlines: [],
    ),
    CourseDetailsModel(
      courseId: 'PH001',
      classId: 'PH001.Q11',
      courseName: 'Vật lý đại cương',
      startPeriod: 7,
      endPeriod: 9,
      startTime: '13:15',
      endTime: '15:45',
      startDate: '2025-09-01',
      endDate: '2026-01-15',
      credits: 3,
      dayOfWeek: 6,
      lecturer: 'TS. Lý Hồng Minh',
      room: 'A2.04',
      deadlines: [],
    ),
  ];

  @override
  Future<List<CourseModel>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _sampleCourses;
  }

  @override
  Future<List<CourseDetailsModel>> getCoursesByMode({
    required int semester,
    required int year,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (semester == 2 && year == 2026) return _semester2_2026;
    if (semester == 1 && year == 2026) return _semester1_2026;

    // No data for other semesters — return empty list.
    return const [];
  }

  @override
  Future<void> uploadSchedule({
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'icsFile': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    await _dio.post<void>('/api/schedule/upload', data: formData);
  }
}
