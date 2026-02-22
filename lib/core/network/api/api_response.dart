import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Generic response:
/// { statusCode: int, message: String, data: T }
@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required int statusCode,
    required String message,
    T? data,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// Helpers for common T
T? _readNullable<T>(Object? v, T Function(Object? v) fn) =>
    v == null ? null : fn(v);

ApiResponse<void> apiResponseVoidFromJson(Map<String, dynamic> json) =>
    ApiResponse<void>.fromJson(json, (_) {});

ApiResponse<String> apiResponseStringFromJson(Map<String, dynamic> json) =>
    ApiResponse<String>.fromJson(json, (v) => v! as String);

ApiResponse<T> apiResponseObjectFromJson<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) fromJsonT,
) =>
    ApiResponse<T>.fromJson(json, (v) => fromJsonT(v! as Map<String, dynamic>));

ApiResponse<T?> apiResponseNullableObjectFromJson<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic> json) fromJsonT,
) => ApiResponse<T?>.fromJson(
  json,
  (v) => _readNullable(v, (x) => fromJsonT(x! as Map<String, dynamic>)),
);
