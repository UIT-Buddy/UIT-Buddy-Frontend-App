import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/change_ws_token_datasource_interface.dart';

class ChangeWsTokenDatasourceImpl implements ChangeWsTokenDatasourceInterface {
  ChangeWsTokenDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, void>> changeWsToken(String newToken) async {
    try {
      await _dio.patch('/api/user/wstoken', data: {'wstoken': newToken});
      return right(null);
    } on DioException catch (e) {
      return left(Failure(e.message ?? 'An error occurred'));
    }
  }
}
