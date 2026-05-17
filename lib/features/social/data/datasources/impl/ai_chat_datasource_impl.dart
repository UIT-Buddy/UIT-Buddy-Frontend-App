import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/ai_chat_datasource_interface.dart';

class AIChatDatasourceImpl implements AIChatDatasourceInterface {
  AIChatDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<String> sendMessage(String message) async {
    final body = <String, dynamic>{'question': message};
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/chat',
      data: body,
    );
    final res = response.data!['data'];
    return res['answer'] as String;
  }
}
