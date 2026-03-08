import 'package:uit_buddy_mobile/features/calendar/data/datasources/course_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/calendar/data/models/course_model.dart';

class CourseDatasourceImpl implements CourseDatasourceInterface {
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

  @override
  Future<List<CourseModel>> getCourses() async {
    // Simulate a lightweight local lookup delay.
    await Future.delayed(const Duration(milliseconds: 100));
    return _sampleCourses;
  }
}
