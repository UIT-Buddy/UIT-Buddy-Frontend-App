import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/moodle_token_model.dart';
import 'package:uit_buddy_mobile/features/onboarding/data/models/signup_complete_response_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<ApiResponse<void>> forgetPassword({required String mssv});

  Future<ApiResponse<void>> resetPassword({
    required String mssv,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  });
  Future<ApiResponse<MoodleTokenModel>> signUpInit({required String wstoken});

  Future<ApiResponse<SignUpCompleteResponseModel>> signUpComplete({
    required String signupToken,
    required String mssv,
    required String password,
    required String confirmPassword,
    String fcmToken,
  });

  Future<ApiResponse<SignUpCompleteResponseModel>> signIn({
    required String mssv,
    required String password,
    bool rememberMe,
    String fcmToken,
  });
}
