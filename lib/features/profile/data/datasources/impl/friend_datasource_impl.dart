import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/friend_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/friend_model.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/impl/paging_mixin.dart';

class FriendDatasourceImpl
    with PagingMixin
    implements FriendDatasourceInterface {
  FriendDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<FriendModel>> getFriends({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final apiResponse = await _dio.get<Map<String, dynamic>>(
      '/api/friends',
      queryParameters: queryParams,
    );

    final body = apiResponse.data!;
    final dataList = (body['data'] as List)
        .map((e) => _toFriendModel(e as Map<String, dynamic>))
        .toList();

    return PagedResult<FriendModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<PagedResult<FriendModel>> getSentFriendRequests({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final apiResponse = await _dio.get<Map<String, dynamic>>(
      '/api/friends/requests/sent',
      queryParameters: queryParams,
    );

    final body = apiResponse.data!;
    final dataList = (body['data'] as List)
        .map(
          (e) => _toFriendModel(
            e as Map<String, dynamic>,
            fallbackUserKey: 'receiver',
          ),
        )
        .toList();

    return PagedResult<FriendModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<PagedResult<FriendModel>> getPendingFriendRequests({
    String? cursor,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit};
    if (cursor != null) queryParams['cursor'] = cursor;

    final apiResponse = await _dio.get<Map<String, dynamic>>(
      '/api/friends/requests/pending',
      queryParameters: queryParams,
    );

    final body = apiResponse.data!;
    final dataList = (body['data'] as List)
        .map(
          (e) => _toFriendModel(
            e as Map<String, dynamic>,
            fallbackUserKey: 'sender',
          ),
        )
        .toList();

    return PagedResult<FriendModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  @override
  Future<void> unFriend(String friendMssv) async {
    await _dio.delete<void>('/api/friends/$friendMssv');
  }

  @override
  Future<void> toggleFriendRequest(String receiverMssv) async {
    final body = <String, dynamic>{'receiverMssv': receiverMssv};

    await _dio.post<void>('/api/friends/requests', data: body);
  }

  @override
  Future<void> respondToFriendRequest({
    required String action,
    required String senderMssv,
  }) async {
    final body = <String, dynamic>{'action': action};

    await _dio.put<void>('/api/friends/requests/$senderMssv', data: body);
  }

  FriendModel _toFriendModel(
    Map<String, dynamic> raw, {
    String? fallbackUserKey,
  }) {
    final nested = _extractNestedUser(raw, fallbackUserKey: fallbackUserKey);

    final id =
        _asString(raw['id']) ??
        _asString(nested?['id']) ??
        _asString(raw['mssv']) ??
        _asString(nested?['mssv']) ??
        '';

    final name =
        _asString(raw['name']) ??
        _asString(raw['fullName']) ??
        _asString(nested?['name']) ??
        _asString(nested?['fullName']) ??
        '';

    final mssv = _asString(raw['mssv']) ?? _asString(nested?['mssv']) ?? '';

    final avatarUrl =
        _asString(raw['avatarUrl']) ?? _asString(nested?['avatarUrl']);

    final createdAt = _parseDateTime(raw['createdAt']) ?? DateTime.now();

    return FriendModel(
      id: id,
      name: name,
      mssv: mssv,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic>? _extractNestedUser(
    Map<String, dynamic> raw, {
    String? fallbackUserKey,
  }) {
    if (fallbackUserKey != null) {
      final preferred = raw[fallbackUserKey];
      if (preferred is Map<String, dynamic>) {
        return preferred;
      }
    }

    for (final key in const ['sender', 'receiver', 'user', 'friend']) {
      final value = raw[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
    }

    return null;
  }

  String? _asString(Object? value) {
    if (value == null) return null;
    return value.toString();
  }

  DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
