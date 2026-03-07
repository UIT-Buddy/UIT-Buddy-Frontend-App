import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/document_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/document_model.dart';

class DocumentDatasourceImpl implements DocumentDatasourceInterface {
  @override
  Future<ApiResponse<DocumentListModel>> getFiles({required String classCode}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final mockData = <String, List<DocumentModel>>{
        'SE347.Q11': [
          DocumentModel(id: '1', classCode: 'SE347.Q11', fileUrl: 'https://example.com',
              fileName: 'đề cương.pdf', accessLevel: 'PUBLIC', priority: 'MEDIUM'),
          DocumentModel(id: '2', classCode: 'SE347.Q11', fileUrl: 'https://example.com',
              fileName: 'slide chương 1.pptx', accessLevel: 'PUBLIC', priority: 'LOW'),
          DocumentModel(id: '3', classCode: 'SE347.Q11', fileUrl: 'https://example.com',
              fileName: 'bài tập 1.docx', accessLevel: 'CLASS_ONLY', priority: 'HIGH'),
        ],
        'SE346.Q21': [
          DocumentModel(id: '4', classCode: 'SE346.Q21', fileUrl: 'https://example.com',
              fileName: 'đề cương.pdf', accessLevel: 'PUBLIC', priority: 'MEDIUM'),
          DocumentModel(id: '5', classCode: 'SE346.Q21', fileUrl: 'https://example.com',
              fileName: 'ghi chú.txt', accessLevel: 'PUBLIC', priority: 'LOW'),
          DocumentModel(id: '6', classCode: 'SE346.Q21', fileUrl: 'https://example.com',
              fileName: 'slide chương 1.pptx', accessLevel: 'PUBLIC', priority: 'LOW'),
        ],
        'CS427.Q11': [
          DocumentModel(id: '7', classCode: 'CS427.Q11', fileUrl: 'https://example.com',
              fileName: 'lab 1.pdf', accessLevel: 'CLASS_ONLY', priority: 'HIGH'),
          DocumentModel(id: '8', classCode: 'CS427.Q11', fileUrl: 'https://example.com',
              fileName: 'project requirements.docx', accessLevel: 'PUBLIC', priority: 'URGENT'),
          DocumentModel(id: '9', classCode: 'CS427.Q11', fileUrl: 'https://example.com',
              fileName: 'Flutter basics.pptx', accessLevel: 'PUBLIC', priority: 'LOW'),
        ],
      };

      return ApiResponse<DocumentListModel>(
        data: DocumentListModel(classCode: classCode, items: mockData[classCode] ?? []),
        message: 'Documents fetched successfully.',
        statusCode: 200,
      );
    } catch (e) {
      return ApiResponse<DocumentListModel>(
        data: null,
        message: 'Failed to fetch documents.',
        statusCode: 500,
      );
    }
  }
}
