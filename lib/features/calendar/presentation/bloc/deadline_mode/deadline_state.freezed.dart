// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deadline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeadlineState {

 DeadlineModeStatus get status; CalendarDeadlineEntity? get calendarDeadlineEntity; String? get errorMessage;
/// Create a copy of DeadlineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadlineStateCopyWith<DeadlineState> get copyWith => _$DeadlineStateCopyWithImpl<DeadlineState>(this as DeadlineState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeadlineState&&(identical(other.status, status) || other.status == status)&&(identical(other.calendarDeadlineEntity, calendarDeadlineEntity) || other.calendarDeadlineEntity == calendarDeadlineEntity)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,calendarDeadlineEntity,errorMessage);

@override
String toString() {
  return 'DeadlineState(status: $status, calendarDeadlineEntity: $calendarDeadlineEntity, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DeadlineStateCopyWith<$Res>  {
  factory $DeadlineStateCopyWith(DeadlineState value, $Res Function(DeadlineState) _then) = _$DeadlineStateCopyWithImpl;
@useResult
$Res call({
 DeadlineModeStatus status, CalendarDeadlineEntity? calendarDeadlineEntity, String? errorMessage
});




}
/// @nodoc
class _$DeadlineStateCopyWithImpl<$Res>
    implements $DeadlineStateCopyWith<$Res> {
  _$DeadlineStateCopyWithImpl(this._self, this._then);

  final DeadlineState _self;
  final $Res Function(DeadlineState) _then;

/// Create a copy of DeadlineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? calendarDeadlineEntity = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeadlineModeStatus,calendarDeadlineEntity: freezed == calendarDeadlineEntity ? _self.calendarDeadlineEntity : calendarDeadlineEntity // ignore: cast_nullable_to_non_nullable
as CalendarDeadlineEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeadlineState].
extension DeadlineStatePatterns on DeadlineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeadlineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeadlineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeadlineState value)  $default,){
final _that = this;
switch (_that) {
case _DeadlineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeadlineState value)?  $default,){
final _that = this;
switch (_that) {
case _DeadlineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeadlineModeStatus status,  CalendarDeadlineEntity? calendarDeadlineEntity,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeadlineState() when $default != null:
return $default(_that.status,_that.calendarDeadlineEntity,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeadlineModeStatus status,  CalendarDeadlineEntity? calendarDeadlineEntity,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DeadlineState():
return $default(_that.status,_that.calendarDeadlineEntity,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeadlineModeStatus status,  CalendarDeadlineEntity? calendarDeadlineEntity,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DeadlineState() when $default != null:
return $default(_that.status,_that.calendarDeadlineEntity,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DeadlineState implements DeadlineState {
  const _DeadlineState({this.status = DeadlineModeStatus.initial, this.calendarDeadlineEntity = null, this.errorMessage});
  

@override@JsonKey() final  DeadlineModeStatus status;
@override@JsonKey() final  CalendarDeadlineEntity? calendarDeadlineEntity;
@override final  String? errorMessage;

/// Create a copy of DeadlineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadlineStateCopyWith<_DeadlineState> get copyWith => __$DeadlineStateCopyWithImpl<_DeadlineState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeadlineState&&(identical(other.status, status) || other.status == status)&&(identical(other.calendarDeadlineEntity, calendarDeadlineEntity) || other.calendarDeadlineEntity == calendarDeadlineEntity)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,calendarDeadlineEntity,errorMessage);

@override
String toString() {
  return 'DeadlineState(status: $status, calendarDeadlineEntity: $calendarDeadlineEntity, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DeadlineStateCopyWith<$Res> implements $DeadlineStateCopyWith<$Res> {
  factory _$DeadlineStateCopyWith(_DeadlineState value, $Res Function(_DeadlineState) _then) = __$DeadlineStateCopyWithImpl;
@override @useResult
$Res call({
 DeadlineModeStatus status, CalendarDeadlineEntity? calendarDeadlineEntity, String? errorMessage
});




}
/// @nodoc
class __$DeadlineStateCopyWithImpl<$Res>
    implements _$DeadlineStateCopyWith<$Res> {
  __$DeadlineStateCopyWithImpl(this._self, this._then);

  final _DeadlineState _self;
  final $Res Function(_DeadlineState) _then;

/// Create a copy of DeadlineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? calendarDeadlineEntity = freezed,Object? errorMessage = freezed,}) {
  return _then(_DeadlineState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeadlineModeStatus,calendarDeadlineEntity: freezed == calendarDeadlineEntity ? _self.calendarDeadlineEntity : calendarDeadlineEntity // ignore: cast_nullable_to_non_nullable
as CalendarDeadlineEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
