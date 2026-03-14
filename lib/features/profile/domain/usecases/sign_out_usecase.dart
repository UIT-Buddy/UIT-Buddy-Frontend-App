import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/sign_out_repository.dart';

class SignOutUsecase implements UseCase<void, NoParams> {
  SignOutUsecase({required SignOutRepository signOutRepository})
      : _signOutRepository = signOutRepository;

  final SignOutRepository _signOutRepository;

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      _signOutRepository.signOut();
}
