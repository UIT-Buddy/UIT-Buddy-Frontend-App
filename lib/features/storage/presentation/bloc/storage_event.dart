import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object?> get props => [];
}

class StorageStarted extends StorageEvent {
  const StorageStarted();
}

class StorageFolderOpened extends StorageEvent {
  const StorageFolderOpened({this.folder, this.folderId});

  final SubjectClassEntity? folder;
  final String? folderId;

  @override
  List<Object?> get props => [folder, folderId];
}

class StorageBackPressed extends StorageEvent {
  const StorageBackPressed();
}

class StorageViewTypeToggled extends StorageEvent {
  const StorageViewTypeToggled();
}

class StorageFileDownloadRequested extends StorageEvent {
  const StorageFileDownloadRequested({required this.file});

  final FileEntity file;

  @override
  List<Object?> get props => [file];
}

class StorageCreateFolder extends StorageEvent {
  const StorageCreateFolder({required this.folderName});

  final String folderName;

  @override
  List<Object?> get props => [folderName];
}

class StorageCreateFiles extends StorageEvent {
  const StorageCreateFiles({required this.files});

  final List<FileEntity> files;

  @override
  List<Object?> get props => [files];
}
