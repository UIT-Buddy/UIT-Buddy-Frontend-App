import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class GetCallAuthTokenUsecase implements UseCase<String, NoParams> {
  GetCallAuthTokenUsecase({required CallRepository repository})
    : _repository = repository;

  final CallRepository _repository;

  @override
  Future<Either<Failure, String>> call(NoParams _) async {
    final token = await _repository.getUserAuthToken();
    return Right(token);
  }
}
