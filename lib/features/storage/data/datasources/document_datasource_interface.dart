import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/document_model.dart';

abstract interface class DocumentDatasourceInterface {
  Future<ApiResponse<DocumentListModel>> getFiles({
    required String classCode,
  });
}