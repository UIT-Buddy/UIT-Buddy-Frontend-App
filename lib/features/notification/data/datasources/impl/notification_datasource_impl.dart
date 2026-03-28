import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/impl/notification_paging_mixin.dart';
import 'package:uit_buddy_mobile/features/notification/data/datasources/notification_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/notification/data/models/notification_model.dart';

class NotificationDatasourceImpl
    with NotificationPagingMixin
    implements NotificationDatasourceInterface {
  NotificationDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<NotificationModel>> getNotifications({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/notifications',
      queryParameters: queryParams,
    );

    final body = response.data!;
    final dataList = (body['data'] as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PagedResult<NotificationModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await _dio.put('/api/notifications/$notificationId/read');
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    await _dio.put('/api/notifications/read-all');
  }

  @override
  Future<int> getUnreadCount() async {
    final res = await _dio.get('/api/notifications/unread-count');
    return res.data!.unread_notification;
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _dio.delete('/api/notifications/$notificationId');
  }
}

    // try {
    //   await Future.delayed(const Duration(milliseconds: 500));

    //   final apiResponse = ApiResponse<NotificationModel>(
    //     data: NotificationModel(
    //       items: [
    //         NotificationItemModel(
    //           id: '1',
    //           title: 'New message from Tuan Tran',
    //           content: 'asdfasdfsadfsadfasdfasdfasdfasdfasdf',
    //           type: 'SOCIAL',
    //           isRead: false,
    //           redirectUrl: '',
    //         ),
    //         NotificationItemModel(
    //           id: '2',
    //           title: 'You have a class today at 7:30',
    //           content: 'SS003.Q11 Tư tưởng Hồ Chí Minh - VN',
    //           type: 'REMINDER',
    //           isRead: false,
    //           redirectUrl: '',
    //         ),
    //         NotificationItemModel(
    //           id: '3',
    //           title: 'You joined Gaming group',
    //           content: 'now you can send messages and make calls in the group!',
    //           type: 'SOCIAL',
    //           isRead: false,
    //           redirectUrl: '',
    //         ),
    //         NotificationItemModel(
    //           id: '4',
    //           title: 'You have a deadline today',
    //           content: 'Nộp bài công nghệ web 6',
    //           type: 'REMINDER',
    //           isRead: false,
    //           redirectUrl: '',
    //         ),
    //         NotificationItemModel(
    //           id: '5',
    //           title: 'File uploaded',
    //           content: 'Đề cương SE346.pdf',
    //           type: 'SYSTEM',
    //           isRead: false,
    //           redirectUrl: '',
    //         ),
    //       ],
    //     ),
    //     message: 'Notifications fetched successfully.',
    //     statusCode: 200,
    //   );

    //   return apiResponse;
    // } catch (e) {
    //   return ApiResponse<NotificationModel>(
    //     data: null,
    //     message: 'Failed to fetch notifications.',
    //     statusCode: 500,
    //   );
    // }