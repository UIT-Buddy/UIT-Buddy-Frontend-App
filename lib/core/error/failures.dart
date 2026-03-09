import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/core/error/authentication_exception.dart';

class Failure {
  Failure([this.message = 'An unexpected error occurred']);

  factory Failure.fromException(Exception exception) {
    switch (exception) {
      case final DioException e:
        // Check if the error is an AuthenticationException
        if (e.error is AuthenticationException) {
          return AuthenticationFailure(
            (e.error! as AuthenticationException).message,
          );
        }

        // Build detailed error message
        final method = e.requestOptions.method;
        final uri = e.requestOptions.uri;
        final statusCode = e.response?.statusCode;

        // Get error message based on type
        String errorMessage;
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timeout to $method $uri';
          case DioExceptionType.sendTimeout:
            errorMessage = 'Send timeout to $method $uri';
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Receive timeout from $method $uri';
          case DioExceptionType.badResponse:
            final responseMessage = e.response?.data is Map
                ? e.response?.data['message'] as String?
                : null;
            errorMessage =
                responseMessage ?? 'Cannot $method $uri (Status: $statusCode)';
          case DioExceptionType.cancel:
            errorMessage = 'Request cancelled: $method $uri';
          case DioExceptionType.connectionError:
            errorMessage =
                'Connection error: Cannot $method $uri\\nPlease check your internet connection or server URL';
          case DioExceptionType.badCertificate:
            errorMessage = 'SSL certificate error: $method $uri';
          case DioExceptionType.unknown:
            errorMessage =
                'Network error: Cannot $method $uri\\n${e.message ?? "Unknown error"}';
        }

        return Failure(errorMessage);
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
