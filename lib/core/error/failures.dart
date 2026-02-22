import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/error/authentication_exception.dart';

class Failure {
  Failure([this.message = 'An unexpected error occurred,']);

  factory Failure.fromException(Exception exception) {
    switch (exception) {
      case final DioException e:
        // Check if the error is an AuthenticationException
        if (e.error is AuthenticationException) {
          return AuthenticationFailure(
            (e.error! as AuthenticationException).message,
          );
        }
        return Failure(
          e.response?.data['message'] as String? ??
              'An unexpected error occurred',
        );
      case final AuthenticationException e:
        return AuthenticationFailure(e.message);
      default:
        return Failure(exception.toString());
    }
  }
  final String message;
}

// Special failure type for authentication errors
class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.message);
}
