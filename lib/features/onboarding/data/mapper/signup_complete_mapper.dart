import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_complete_response_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_complete_entity.dart';

extension SignUpCompleteUserModelMapper on SignUpCompleteUserModel {
  SignUpCompleteUserEntity toEntity() =>
      SignUpCompleteUserEntity(mssv: mssv, fullName: fullName, email: email);
}

extension SignUpCompleteResponseModelMapper on SignUpCompleteResponseModel {
  SignUpCompleteEntity toEntity() => SignUpCompleteEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user.toEntity(),
  );
}
