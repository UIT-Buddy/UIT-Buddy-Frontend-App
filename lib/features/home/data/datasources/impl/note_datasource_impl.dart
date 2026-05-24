import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/note_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/models/note_model.dart';

class NoteDatasourceImpl implements NoteDatasource {
  NoteDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<NoteModel> getNote() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/note');
    return NoteModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> upsertNote(String content) async {
    await _dio.put('/api/note', data: {'content': content});
  }

  @override
  Future<void> newNote() async {
    await _dio.post('/api/note/new');
  }

  @override
  Future<String> saveToDocument(String fileName, String folderId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/note/save-to-document',
      data: {'fileName': fileName, 'folderId': folderId},
    );
    return response.data!['data'] as String;
  }
}
