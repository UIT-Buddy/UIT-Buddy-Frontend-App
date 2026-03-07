import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

enum StorageViewMode { topLevel, folder }

enum StorageViewType { grid, list }

class StorageState extends Equatable {
  const StorageState({
    this.viewMode = StorageViewMode.topLevel,
    this.viewType = StorageViewType.grid,
    this.isClassesLoading = false,
    this.isDocumentsLoading = false,
    this.classes = const [],
    this.currentFolder,
    this.documents,
    this.errorMessage,
  });

  final StorageViewMode viewMode;
  final StorageViewType viewType;
  final bool isClassesLoading;
  final bool isDocumentsLoading;
  final List<SubjectClassEntity> classes;
  final SubjectClassEntity? currentFolder;
  final DocumentListEntity? documents;
  final String? errorMessage;

  StorageState copyWith({
    StorageViewMode? viewMode,
    StorageViewType? viewType,
    bool? isClassesLoading,
    bool? isDocumentsLoading,
    List<SubjectClassEntity>? classes,
    SubjectClassEntity? Function()? currentFolder,
    DocumentListEntity? Function()? documents,
    String? Function()? errorMessage,
  }) {
    return StorageState(
      viewMode: viewMode ?? this.viewMode,
      viewType: viewType ?? this.viewType,
      isClassesLoading: isClassesLoading ?? this.isClassesLoading,
      isDocumentsLoading: isDocumentsLoading ?? this.isDocumentsLoading,
      classes: classes ?? this.classes,
      currentFolder:
          currentFolder != null ? currentFolder() : this.currentFolder,
      documents: documents != null ? documents() : this.documents,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        viewMode,
        viewType,
        isClassesLoading,
        isDocumentsLoading,
        classes,
        currentFolder,
        documents,
        errorMessage,
      ];
}
