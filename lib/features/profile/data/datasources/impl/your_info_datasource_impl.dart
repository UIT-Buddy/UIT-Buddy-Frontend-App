import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/your_info_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_info_model.dart';

class YourInfoDatasourceImpl implements YourInfoDatasourceInterface {
  // In-memory store so updates persist within a session
  YourInfoModel _stored = const YourInfoModel(
    mssv: '23520540',
    fullName: 'Minh Hoàng',
    email: '23520540@gm.uit.edu.vn',
    gender: 'Male',
    homeClass: 'KTPM2023.1',
    faculty: 'CNPM',
    major: 'Kỹ thuật phần mềm',
  );

  @override
  Future<ApiResponse<YourInfoModel>> getYourInfo() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse<YourInfoModel>(
      data: _stored,
      message: 'Your info fetched successfully.',
      statusCode: 200,
    );
  }

  @override
  Future<ApiResponse<YourInfoModel>> updateYourInfo({
    required YourInfoModel info,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _stored = info;
    return ApiResponse<YourInfoModel>(
      data: _stored,
      message: 'Your info updated successfully.',
      statusCode: 200,
    );
  }
}