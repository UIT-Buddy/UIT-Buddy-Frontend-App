import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/chat_repository.dart';

class ResetCometCacheUsecase implements UseCase<void, NoParams> {
  ResetCometCacheUsecase({required ChatRepository repository})
    : _repository = repository;

  final ChatRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    _repository.reset();
    return const Right(null);
  }
}
