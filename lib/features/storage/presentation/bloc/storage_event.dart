import 'package:equatable/equatable.dart';
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
  const StorageFolderOpened({required this.folder});

  final SubjectClassEntity folder;

  @override
  List<Object?> get props => [folder];
}

class StorageBackPressed extends StorageEvent {
  const StorageBackPressed();
}

class StorageViewTypeToggled extends StorageEvent {
  const StorageViewTypeToggled();
}
