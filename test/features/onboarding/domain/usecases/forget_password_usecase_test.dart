import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/usecases/forget_password_usecase.dart';

import '../../../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late ForgetPasswordUsecase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    provideDummy<Either<Failure, void>>(const Right(null));
    usecase = ForgetPasswordUsecase(authRepository: mockRepository);
  });

  const tMssv = '21521234';
  const tParams = ForgetPasswordParams(mssv: tMssv);

  group('ForgetPasswordUsecase', () {
    test('should call repository.forgetPassword with correct mssv', () async {
      when(
        mockRepository.forgetPassword(mssv: tMssv),
      ).thenAnswer((_) async => const Right(null));

      await usecase(tParams);

      verify(mockRepository.forgetPassword(mssv: tMssv));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(null) on success', () async {
      when(
        mockRepository.forgetPassword(mssv: tMssv),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, const Right(null));
    });

    test('should return Failure when repository fails', () async {
      final tFailure = Failure('Student ID not found');
      when(
        mockRepository.forgetPassword(mssv: tMssv),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, Left(tFailure));
    });
  });
}
