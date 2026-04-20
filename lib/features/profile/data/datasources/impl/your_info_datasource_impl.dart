import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/your_info_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_info_model.dart';

class YourInfoDatasourceImpl implements YourInfoDatasourceInterface {
  YourInfoDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ApiResponse<YourInfoModel>> getYourInfo() async {
    final response = await _getMeResponse();
    return apiResponseObjectFromJson(
      response.data!,
      (json) => YourInfoModel.fromUserJson(json),
    );

    // Mocked API response kept for fallback/local dev reference.
    // return ApiResponse<YourInfoModel>(
    //   data: const YourInfoModel(
    //     mssv: '23520540',
    //     fullName: 'Minh Hoàng',
    //     email: '23520540@gm.uit.edu.vn',
    //     avatarUrl: 'assets/images/sample/f1.jpg',
    //     bio: 'UIT student passionate about mobile development and UI/UX design.',
    //     gender: 'Male',
    //     homeClass: 'KTPM2023.1',
    //     faculty: 'CNPM',
    //     major: 'Kỹ thuật phần mềm',
    //   ),
    //   message: 'Your info fetched successfully.',
    //   statusCode: 200,
    // );
  }

  @override
  Future<ApiResponse<YourInfoModel>> updateYourInfo({
    required YourInfoModel info,
  }) async {
    var avatarUrl = info.avatarUrl;
    var coverUrl = info.coverUrl;

    if (_isDataUrl(avatarUrl)) {
      avatarUrl = await _uploadAvatarFromDataUrl(avatarUrl);
    }
    if (_isDataUrl(coverUrl)) {
      coverUrl = await _uploadCoverFromDataUrl(coverUrl);
    }

    final normalizedInfo = info.copyWith(
      avatarUrl: avatarUrl,
      coverUrl: coverUrl,
    );
    final updatePayload = normalizedInfo.toUpdateRequestJson();
    if (!_isRemoteAvatarUrl(avatarUrl)) {
      updatePayload.remove('avatarUrl');
    }

    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/user/update',
      data: updatePayload,
    );

    final mapped = apiResponseObjectFromJson(
      response.data!,
      (json) => YourInfoModel.fromUserJson(json, fallback: normalizedInfo),
    );

    return mapped;
  }

  bool _isDataUrl(String value) => value.startsWith('data:image');

  bool _isRemoteAvatarUrl(String value) =>
      value.startsWith('http://') || value.startsWith('https://');

  Future<String> _uploadAvatarFromDataUrl(String dataUrl) async {
    final parts = dataUrl.split(',');
    if (parts.length != 2) {
      throw const FormatException('Invalid image data URL.');
    }

    final bytes = base64Decode(parts[1]);
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: 'avatar.jpg'),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/user/avatar',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final parsed = apiResponseStringFromJson(response.data!);
    return parsed.data ?? '';
  }

  Future<String> _uploadCoverFromDataUrl(String dataUrl) async {
    final parts = dataUrl.split(',');
    if (parts.length != 2) {
      throw const FormatException('Invalid image data URL.');
    }

    final bytes = base64Decode(parts[1]);
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: 'cover.jpg'),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/user/cover',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final parsed = apiResponseStringFromJson(response.data!);
    return parsed.data ?? '';
  }

  Future<Response<Map<String, dynamic>>> _getMeResponse() async {
    return await _dio.get<Map<String, dynamic>>('/api/user/me');
  }
}
