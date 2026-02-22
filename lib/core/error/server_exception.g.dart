// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerException _$ServerExceptionFromJson(Map<String, dynamic> json) =>
    _ServerException(
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'],
      code: json['code'] as String?,
      raw: json['raw'],
    );

Map<String, dynamic> _$ServerExceptionToJson(_ServerException instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
      'data': instance.data,
      'code': instance.code,
      'raw': instance.raw,
    };
