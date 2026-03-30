import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/folder_model.dart';

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
}
