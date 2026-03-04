// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerException {

 String get message; int? get statusCode; dynamic get data; String? get code; dynamic get raw;
/// Create a copy of ServerException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerExceptionCopyWith<ServerException> get copyWith => _$ServerExceptionCopyWithImpl<ServerException>(this as ServerException, _$identity);

  /// Serializes this ServerException to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerException&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.raw, raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,statusCode,const DeepCollectionEquality().hash(data),code,const DeepCollectionEquality().hash(raw));



}

/// @nodoc
abstract mixin class $ServerExceptionCopyWith<$Res>  {
  factory $ServerExceptionCopyWith(ServerException value, $Res Function(ServerException) _then) = _$ServerExceptionCopyWithImpl;
@useResult
$Res call({
 String message, int? statusCode, dynamic data, String? code, dynamic raw
});




}
/// @nodoc
class _$ServerExceptionCopyWithImpl<$Res>
    implements $ServerExceptionCopyWith<$Res> {
  _$ServerExceptionCopyWithImpl(this._self, this._then);

  final ServerException _self;
  final $Res Function(ServerException) _then;

/// Create a copy of ServerException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? statusCode = freezed,Object? data = freezed,Object? code = freezed,Object? raw = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerException].
extension ServerExceptionPatterns on ServerException {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerException value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerException() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerException value)  $default,){
final _that = this;
switch (_that) {
case _ServerException():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerException value)?  $default,){
final _that = this;
switch (_that) {
case _ServerException() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int? statusCode,  dynamic data,  String? code,  dynamic raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerException() when $default != null:
return $default(_that.message,_that.statusCode,_that.data,_that.code,_that.raw);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int? statusCode,  dynamic data,  String? code,  dynamic raw)  $default,) {final _that = this;
switch (_that) {
case _ServerException():
return $default(_that.message,_that.statusCode,_that.data,_that.code,_that.raw);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int? statusCode,  dynamic data,  String? code,  dynamic raw)?  $default,) {final _that = this;
switch (_that) {
case _ServerException() when $default != null:
return $default(_that.message,_that.statusCode,_that.data,_that.code,_that.raw);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerException extends ServerException {
  const _ServerException({required this.message, this.statusCode, this.data, this.code, this.raw}): super._();
  factory _ServerException.fromJson(Map<String, dynamic> json) => _$ServerExceptionFromJson(json);

@override final  String message;
@override final  int? statusCode;
@override final  dynamic data;
@override final  String? code;
@override final  dynamic raw;

/// Create a copy of ServerException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerExceptionCopyWith<_ServerException> get copyWith => __$ServerExceptionCopyWithImpl<_ServerException>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerExceptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerException&&(identical(other.message, message) || other.message == message)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.raw, raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,statusCode,const DeepCollectionEquality().hash(data),code,const DeepCollectionEquality().hash(raw));



}

/// @nodoc
abstract mixin class _$ServerExceptionCopyWith<$Res> implements $ServerExceptionCopyWith<$Res> {
  factory _$ServerExceptionCopyWith(_ServerException value, $Res Function(_ServerException) _then) = __$ServerExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, int? statusCode, dynamic data, String? code, dynamic raw
});




}
/// @nodoc
class __$ServerExceptionCopyWithImpl<$Res>
    implements _$ServerExceptionCopyWith<$Res> {
  __$ServerExceptionCopyWithImpl(this._self, this._then);

  final _ServerException _self;
  final $Res Function(_ServerException) _then;

/// Create a copy of ServerException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? statusCode = freezed,Object? data = freezed,Object? code = freezed,Object? raw = freezed,}) {
  return _then(_ServerException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
