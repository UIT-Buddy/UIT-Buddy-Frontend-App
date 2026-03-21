import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/your_info_repository.dart';

class GetYourInfoUsecase implements UseCase<YourInfoEntity, void> {
  GetYourInfoUsecase({required YourInfoRepository repository})
    : _yourInfoRepository = repository;
  final YourInfoRepository _yourInfoRepository;

  @override
  Future<Either<Failure, YourInfoEntity>> call(void params) async =>
      _yourInfoRepository.getYourInfo();
}
