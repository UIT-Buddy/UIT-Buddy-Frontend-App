import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/subject_class_model.dart';

abstract interface class SubjectClassDatasourceInterface {
  Future<ApiResponse<List<SubjectClassModel>>> getClasses();
}
