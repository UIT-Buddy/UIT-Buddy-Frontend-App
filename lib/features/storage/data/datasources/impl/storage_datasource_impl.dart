import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/folder_model.dart';
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
}
