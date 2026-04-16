import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/impl/storage_paging_mixin.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_friend_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/storage_friend_model.dart';

class StorageFriendDatasourceImpl
    with StoragePagingMixin
    implements StorageFriendDatasourceInterface {
  StorageFriendDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PagedResult<StorageFriendModel>> getFriends({
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
        .map((e) => _toStorageFriendModel(e as Map<String, dynamic>))
        .toList();

    return PagedResult<StorageFriendModel>(
      items: dataList,
      nextCursor: extractNextCursor(body),
      hasMore: extractHasMore(body, dataList.length, limit),
    );
  }

  StorageFriendModel _toStorageFriendModel(
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

    return StorageFriendModel(
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
