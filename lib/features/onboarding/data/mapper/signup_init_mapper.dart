import 'package:uit_buddy_mobile/features/onboarding/data/models/moodle_token_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/entities/signup_init_entity.dart';

extension MoodleTokenModelMapper on MoodleTokenModel {
  SignUpInitEntity toEntity() => SignUpInitEntity(
    studentId: mssv,
    studentName: fullName,
    signupToken: signupToken,
  );
}
