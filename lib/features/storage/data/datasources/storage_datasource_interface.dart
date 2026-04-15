import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/folder_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/shared_student_model.dart';

abstract interface class StorageDatasourceInterface {
  Future<FolderModel> getFolder(String? folderId);

  Future<void> createFolder({
    required String folderName,
    String? parentFolderId,
  });

  Future<void> createFiles({required List<FileModel> files, String? folderId});

  Future<List<FileModel>> searchDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    required String keyword,
  });

  Future<String> getDownloadUrl(String fileId);

  Future<void> updateFile({
    required String documentId,
    required String fileName,
    String? folderId,
  });

  Future<void> shareResource({
    required String resourceType,
    required String resourceId,
    required String targetMssv,
  });

  Future<PagedResult<SharedStudentModel>> getSharedUsers({
    required String resourceType,
    required String resourceId,
    int page = 1,
    int limit = 15,
    String sortType = 'desc',
    String sortBy = 'sharedAt',
  });

  Future<void> deleteFile({required String documentId});

  Future<void> unShare({
    required String resourceId,
    required String resourceType,
    required String targetMssv,
  });

  Future<List<FileModel>> searchSharedDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    required String keyword,
  });
}
