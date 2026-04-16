import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/subject_class_entity.dart';

enum StorageViewMode { topLevel, folder }

enum StorageViewType { grid, list }

class StorageState extends Equatable {
  const StorageState({
    this.viewMode = StorageViewMode.topLevel,
    this.viewType = StorageViewType.grid,
    this.isClassesLoading = false,
    this.isFolderLoading = false,
    this.isCreating = false,
    this.isMoveMode = false,
    this.classes = const [],
    this.currentFolder,
    this.folderStack = const [],
    this.errorMessage,
    this.movingFile,
    this.moveSourceFolderId,
    this.actionErrorMessage,
    this.actionSuccessMessage,
  });

  final StorageViewMode viewMode;
  final StorageViewType viewType;
  final bool isClassesLoading;
  final bool isFolderLoading;
  final bool isCreating;
  final bool isMoveMode;
  final List<SubjectClassEntity> classes;
  final FolderEntity? currentFolder;
  final List<FolderEntity> folderStack;
  final String? errorMessage;
  final FileEntity? movingFile;
  final String? moveSourceFolderId;
  final String? actionErrorMessage;
  final String? actionSuccessMessage;

  StorageState copyWith({
    StorageViewMode? viewMode,
    StorageViewType? viewType,
    bool? isClassesLoading,
    bool? isFolderLoading,
    bool? isCreating,
    bool? isMoveMode,
    List<SubjectClassEntity>? classes,
    FolderEntity? Function()? currentFolder,
    List<FolderEntity>? folderStack,
    String? Function()? errorMessage,
    FileEntity? Function()? movingFile,
    String? Function()? moveSourceFolderId,
    String? Function()? actionErrorMessage,
    String? Function()? actionSuccessMessage,
  }) {
    return StorageState(
      viewMode: viewMode ?? this.viewMode,
      viewType: viewType ?? this.viewType,
      isClassesLoading: isClassesLoading ?? this.isClassesLoading,
      isFolderLoading: isFolderLoading ?? this.isFolderLoading,
      isCreating: isCreating ?? this.isCreating,
      isMoveMode: isMoveMode ?? this.isMoveMode,
      classes: classes ?? this.classes,
      currentFolder: currentFolder != null
          ? currentFolder()
          : this.currentFolder,
      folderStack: folderStack ?? this.folderStack,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      movingFile: movingFile != null ? movingFile() : this.movingFile,
      moveSourceFolderId: moveSourceFolderId != null
          ? moveSourceFolderId()
          : this.moveSourceFolderId,
      actionErrorMessage: actionErrorMessage != null
          ? actionErrorMessage()
          : this.actionErrorMessage,
      actionSuccessMessage: actionSuccessMessage != null
          ? actionSuccessMessage()
          : this.actionSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
    viewType,
    isClassesLoading,
    isFolderLoading,
    isCreating,
    isMoveMode,
    classes,
    currentFolder,
    folderStack,
    errorMessage,
    movingFile,
    moveSourceFolderId,
    actionErrorMessage,
    actionSuccessMessage,
  ];
}
