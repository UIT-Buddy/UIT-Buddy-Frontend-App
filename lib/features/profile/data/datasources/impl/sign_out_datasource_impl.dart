import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/sign_out_datasource_interface.dart';

class SignOutDatasourceImpl implements SignOutDatasource {
  SignOutDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> signOut({required String refreshToken}) async {
    await _dio.post<void>(
      '/api/auth/signout',
      options: Options(headers: {'X-Refresh-Token': refreshToken}),
    );
  }
}
