import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/delete_account_datasource_interface.dart';

class DeleteAccountDatasourceImpl implements DeleteAccountDatasource {
  DeleteAccountDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _dio.delete('/api/user/delete');
      return right(null);
    } on DioException catch (e) {
      return left(Failure(e.message ?? 'An error occurred'));
    }
  }
}
