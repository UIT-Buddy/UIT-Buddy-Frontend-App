import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/folder_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/shared_student_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/sub_folder_model.dart';

class StorageDatasourceImpl implements StorageDatasourceInterface {
  StorageDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<FolderModel> getFolder(String? folderId) async {
    final queryParams = <String, dynamic>{'folderId': folderId};
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/document/folder',
      queryParameters: queryParams,
    );

    final data = res.data!['data'] as Map<String, dynamic>;

    // Map API response to SubFolderModel list
    final folders =
        (data['folders'] as List<dynamic>?)
            ?.map(
              (f) => SubFolderModel(
                id: f['folderId'] as String,
                name: f['folderName'] as String,
                itemCount: f['folderItemCount'] as int,
              ),
            )
            .toList() ??
        [];

    // Map API response to FileModel list
    final files =
        (data['files'] as List<dynamic>?)
            ?.map(
              (f) => FileModel(
                id: f['fileId'] as String,
                name: f['fileName'] as String,
                url: f['fileUrl'] as String,
                size: (f['fileSize'] as num).toDouble(),
                sizeUnit: f['fileSizeUnit'] as String,
                type: f['fileType'] as String,
              ),
            )
            .toList() ??
        [];

    return FolderModel(
      id: data['folderId'] as String,
      name: data['folderName'] as String,
      path: data['folderPath'] as String,
      parentFolderId: (data['parentFolderId'] as String?) ?? '',
      folders: folders,
      files: files,
    );
  }

  @override
  Future<void> createFolder({
    required String folderName,
    String? parentFolderId,
  }) async {
    final data = {'folderName': folderName, 'parentFolderId': parentFolderId};
    await _dio.post('/api/document/folder', data: data);
  }

  @override
  Future<void> createFiles({
    required List<FileModel> files,
    String? folderId,
  }) async {
    final formData = FormData();

    // Add each file as MultipartFile
    for (final file in files) {
      final ioFile = File(file.url); // url contains the local file path
      final multipartFile = await MultipartFile.fromFile(
        ioFile.path,
        filename: file.name,
      );
      formData.files.add(MapEntry('files', multipartFile));
    }

    // Add folderId if provided
    if (folderId != null) {
      formData.fields.add(MapEntry('folderId', folderId));
    }

    await _dio.post('/api/document/file', data: formData);
  }

  @override
  Future<List<FileModel>> searchDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    required String keyword,
  }) async {
    final queryParams = <String, dynamic>{'keyword': keyword};

    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (sortType != null) queryParams['sortType'] = sortType;
    if (sortBy != null) queryParams['sortBy'] = sortBy;

    final res = await _dio.get<Map<String, dynamic>>(
      '/api/document/search',
      queryParameters: queryParams,
    );

    final dataList = res.data!['data'] as List<dynamic>;

    return dataList.map((item) {
      final file = item as Map<String, dynamic>;
      return FileModel(
        id: file['documentId'] as String,
        name: file['fileName'] as String,
        url: file['url'] as String,
        size: 0.0, // Not provided in search response
        sizeUnit: '', // Not provided in search response
        type: '', // Not provided in search response
      );
    }).toList();
  }

  @override
  Future<String> getDownloadUrl(String fileId) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/api/document/download/$fileId',
    );
    return res.data!['data'] as String;
  }

  @override
  Future<void> updateFile({
    required String documentId,
    required String fileName,
    String? folderId,
  }) async {
    final body = <String, dynamic>{'fileName': fileName};
    if (folderId != null) {
      body['folderId'] = folderId;
    }

    await _dio.put<void>('/api/document/$documentId', data: body);
  }

  @override
  Future<void> shareResource({
    required String resourceType,
    required String resourceId,
    required String targetMssv,
  }) async {
    final body = <String, dynamic>{
      'resourceType': resourceType,
      'resourceId': resourceId,
      'targetMssv': targetMssv,
    };

    await _dio.post<void>('/api/document/share', data: body);
  }

  @override
  Future<PagedResult<SharedStudentModel>> getSharedUsers({
    required String resourceType,
    required String resourceId,
    int page = 1,
    int limit = 15,
    String sortType = 'desc',
    String sortBy = 'sharedAt',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortType': sortType,
      'sortBy': sortBy,
    };

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/document/shared-user/$resourceType/$resourceId',
      queryParameters: queryParams,
    );

    final body = response.data!;
    final dataList = (body['data'] as List<dynamic>? ?? const [])
        .map(
          (item) => SharedStudentModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final paging = body['paging'] as Map<String, dynamic>?;
    final total = (paging?['total'] as num?)?.toInt();

    final hasMore = total != null
        ? page * limit < total
        : dataList.length == limit;

    return PagedResult<SharedStudentModel>(
      items: dataList,
      nextCursor: hasMore ? (page + 1).toString() : null,
      hasMore: hasMore,
    );
  }

  @override
  Future<void> deleteFile({required String documentId}) async {
    await _dio.delete<void>('/api/document/$documentId');
  }

  @override
  Future<void> unShare({
    required String resourceId,
    required String resourceType,
    required String targetMssv,
  }) async {
    final body = <String, dynamic>{
      'resourceId': resourceId,
      'resourceType': resourceType,
      'targetMssv': targetMssv,
    };

    await _dio.delete<void>('/api/document/share', data: body);
  }

  @override
  Future<List<FileModel>> searchSharedDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    required String keyword,
  }) async {
    final queryParams = <String, dynamic>{'keyword': keyword};

    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (sortType != null) queryParams['sortType'] = sortType;
    if (sortBy != null) queryParams['sortBy'] = sortBy;

    final res = await _dio.get<Map<String, dynamic>>(
      '/api/document/shared-with-me',
      queryParameters: queryParams,
    );

    final dataList = res.data!['data'] as List<dynamic>;

    return dataList.map((item) {
      final file = item as Map<String, dynamic>;
      return FileModel(
        id: file['documentId'] as String,
        name: file['fileName'] as String,
        url: file['url'] as String,
        size: 0.0, // Not provided in search response
        sizeUnit: '', // Not provided in search response
        type: '', // Not provided in search response
      );
    }).toList();
  }
}
