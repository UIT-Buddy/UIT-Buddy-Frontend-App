import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart';

class NotificationDatasourceImpl implements NotificationDatasourceInterface {
  @override
  Future<ApiResponse<NotificationModel>> getNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final apiResponse = ApiResponse<NotificationModel>(
        data: NotificationModel(
          items: [
            NotificationItemModel(
              id: '1',
              title: 'New message from Tuan Tran',
              content: 'asdfasdfsadfsadfasdfasdfasdfasdfasdf',
              type: 'SOCIAL',
              isRead: false,
              redirectUrl: ''
            ),
            NotificationItemModel(
              id: '2',
              title: 'You have a class today at 7:30',
              content: 'SS003.Q11 Tư tưởng Hồ Chí Minh - VN',
              type: 'REMINDER',
              isRead: false,
              redirectUrl: ''
            ),
            NotificationItemModel(
              id: '3',
              title: 'You joined Gaming group',
              content: 'now you can send messages and make calls in the group!',
              type: 'SOCIAL',
              isRead: false,
              redirectUrl: ''
            ),
            NotificationItemModel(
              id: '4',
              title: 'You have a deadline today',
              content: 'Nộp bài công nghệ web 6',
              type: 'REMINDER',
              isRead: false,
              redirectUrl: ''
            ),
            NotificationItemModel(
              id: '5',
              title: 'File uploaded',
              content: 'Đề cương SE346.pdf',
              type: 'SYSTEM',
              isRead: false,
              redirectUrl: ''
            ),
          ],
        ),
        message: 'Notifications fetched successfully.',
        statusCode: 200,
      );

      return apiResponse;
    } catch (e) {
      return ApiResponse<NotificationModel>(
        data: null,
        message: 'Failed to fetch notifications.',
        statusCode: 500,
      );
    }
  }
}
