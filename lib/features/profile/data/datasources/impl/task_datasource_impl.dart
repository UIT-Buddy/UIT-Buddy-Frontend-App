import 'package:uit_buddy_mobile/features/profile/data/datasources/task_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/task_model.dart';

class TaskDatasourceImpl implements TaskDatasourceInterface {
  // In-memory store for mock data
  final List<TaskModel> _tasks = [
    // --- Upcoming (pending) ---
    TaskModel(
      id: 'task_001',
      classCode: 'SE347.Q14',
      taskDetail: TaskDetailModel(
        name: 'Nộp bài công nghệ web 6',
        title: 'SE347.Q14 - Công nghệ Web và ứng dụng',
        description: 'Tạo trang login bao gồm email và mật khẩu',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=417071',
        priority: 'high',
        openDate: DateTime(2026, 3, 12, 7, 30),
        dueDate: DateTime(2026, 3, 23, 11, 59),
        reminderTime: DateTime(2026, 1, 1, 16, 0),
        status: 'pending',
      ),
    ),
    TaskModel(
      id: 'task_002',
      classCode: 'IE303.P11',
      taskDetail: TaskDetailModel(
        name: 'Quiz chương 4 - Mạng máy tính',
        title: 'IE303.P11 - Mạng máy tính',
        description: 'Làm quiz online trên hệ thống, thời gian 30 phút',
        url: 'https://courses.uit.edu.vn/mod/quiz/view.php?id=220891',
        priority: 'medium',
        openDate: DateTime(2026, 3, 14, 8, 0),
        dueDate: DateTime(2026, 3, 20, 23, 59),
        reminderTime: DateTime(2026, 1, 1, 9, 0),
        status: 'pending',
      ),
    ),
    TaskModel(
      id: 'task_003',
      classCode: 'SE405.P11',
      taskDetail: TaskDetailModel(
        name: 'Báo cáo đồ án sprint 2',
        title: 'SE405.P11 - Kỹ nghệ phần mềm',
        description: 'Nộp báo cáo sprint 2 bao gồm tài liệu thiết kế và demo video',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=330145',
        priority: 'high',
        openDate: DateTime(2026, 3, 10, 7, 30),
        dueDate: DateTime(2026, 3, 28, 17, 0),
        reminderTime: DateTime(2026, 1, 1, 8, 0),
        status: 'pending',
      ),
    ),
    // --- Finished (completed) ---
    TaskModel(
      id: 'task_004',
      classCode: 'SE347.Q14',
      taskDetail: TaskDetailModel(
        name: 'Nộp bài công nghệ web 5',
        title: 'SE347.Q14 - Công nghệ Web và ứng dụng',
        description: 'Tạo trang đăng ký tài khoản với validation',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=410022',
        priority: 'medium',
        openDate: DateTime(2026, 2, 20, 7, 30),
        dueDate: DateTime(2026, 3, 5, 11, 59),
        reminderTime: DateTime(2026, 1, 1, 16, 0),
        status: 'completed',
      ),
    ),
    TaskModel(
      id: 'task_005',
      classCode: 'IE303.P11',
      taskDetail: TaskDetailModel(
        name: 'Quiz chương 3 - Mạng máy tính',
        title: 'IE303.P11 - Mạng máy tính',
        description: 'Làm quiz online trên hệ thống, thời gian 30 phút',
        url: 'https://courses.uit.edu.vn/mod/quiz/view.php?id=218833',
        priority: 'low',
        openDate: DateTime(2026, 2, 24, 8, 0),
        dueDate: DateTime(2026, 3, 3, 23, 59),
        reminderTime: DateTime(2026, 1, 1, 9, 0),
        status: 'completed',
      ),
    ),
    TaskModel(
      id: 'task_006',
      classCode: 'SE370.P21',
      taskDetail: TaskDetailModel(
        name: 'Lab 2 - Lập trình di động',
        title: 'SE370.P21 - Phát triển ứng dụng di động',
        description: 'Xây dựng màn hình danh sách sản phẩm với Flutter',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=398756',
        priority: 'medium',
        openDate: DateTime(2026, 2, 18, 7, 30),
        dueDate: DateTime(2026, 2, 28, 20, 0),
        reminderTime: DateTime(2026, 1, 1, 20, 0),
        status: 'completed',
      ),
    ),
    // --- Late (overdue) ---
    TaskModel(
      id: 'task_007',
      classCode: 'SE347.Q14',
      taskDetail: TaskDetailModel(
        name: 'Nộp bài công nghệ web 4',
        title: 'SE347.Q14 - Công nghệ Web và ứng dụng',
        description: 'Xây dựng RESTful API với Node.js và Express',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=400300',
        priority: 'high',
        openDate: DateTime(2026, 2, 1, 7, 30),
        dueDate: DateTime(2026, 2, 15, 11, 59),
        reminderTime: DateTime(2026, 1, 1, 16, 0),
        status: 'overdue',
      ),
    ),
    TaskModel(
      id: 'task_008',
      classCode: 'IE303.P11',
      taskDetail: TaskDetailModel(
        name: 'Bài tập lớn giữa kỳ',
        title: 'IE303.P11 - Mạng máy tính',
        description: 'Phân tích và thiết kế mạng cho một doanh nghiệp vừa',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=215500',
        priority: 'high',
        openDate: DateTime(2026, 1, 15, 8, 0),
        dueDate: DateTime(2026, 2, 10, 23, 59),
        reminderTime: DateTime(2026, 1, 1, 9, 0),
        status: 'overdue',
      ),
    ),
    TaskModel(
      id: 'task_009',
      classCode: 'SE370.P21',
      taskDetail: TaskDetailModel(
        name: 'Lab 1 - Lập trình di động',
        title: 'SE370.P21 - Phát triển ứng dụng di động',
        description: 'Làm quen với Flutter: tạo màn hình Hello World',
        url: 'https://courses.uit.edu.vn/mod/assign/view.php?id=391200',
        priority: 'low',
        openDate: DateTime(2026, 1, 20, 7, 30),
        dueDate: DateTime(2026, 2, 3, 20, 0),
        reminderTime: DateTime(2026, 1, 1, 20, 0),
        status: 'overdue',
      ),
    ),
  ];

  @override
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_tasks);
  }

  @override
  Future<TaskModel> createTask({required TaskModel task}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.add(task);
    return task;
  }

  @override
  Future<TaskModel> updateTask({required TaskModel task}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) throw Exception('Task not found: ${task.id}');
    _tasks[index] = task;
    return task;
  }

  @override
  Future<void> deleteTask({required String taskId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.removeWhere((t) => t.id == taskId);
  }

  @override
  Future<void> markTaskCompleted({required String taskId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) throw Exception('Task not found: $taskId');
    _tasks[index] = _tasks[index].copyWith(
      taskDetail: _tasks[index].taskDetail.copyWith(status: 'completed'),
    );
  }
}
