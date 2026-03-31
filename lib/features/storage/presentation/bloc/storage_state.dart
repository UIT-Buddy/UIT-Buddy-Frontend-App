import 'package:equatable/equatable.dart';
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
    this.classes = const [],
    this.currentFolder,
    this.folderStack = const [],
    this.errorMessage,
  });

  final StorageViewMode viewMode;
  final StorageViewType viewType;
  final bool isClassesLoading;
  final bool isFolderLoading;
  final bool isCreating;
  final List<SubjectClassEntity> classes;
  final FolderEntity? currentFolder;
  final List<FolderEntity> folderStack;
  final String? errorMessage;

  StorageState copyWith({
    StorageViewMode? viewMode,
    StorageViewType? viewType,
    bool? isClassesLoading,
    bool? isFolderLoading,
    bool? isCreating,
    List<SubjectClassEntity>? classes,
    FolderEntity? Function()? currentFolder,
    List<FolderEntity>? folderStack,
    String? Function()? errorMessage,
  }) {
    return StorageState(
      viewMode: viewMode ?? this.viewMode,
      viewType: viewType ?? this.viewType,
      isClassesLoading: isClassesLoading ?? this.isClassesLoading,
      isFolderLoading: isFolderLoading ?? this.isFolderLoading,
      isCreating: isCreating ?? this.isCreating,
      classes: classes ?? this.classes,
      currentFolder: currentFolder != null
          ? currentFolder()
          : this.currentFolder,
      folderStack: folderStack ?? this.folderStack,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
    viewType,
    isClassesLoading,
    isFolderLoading,
    isCreating,
    classes,
    currentFolder,
    folderStack,
    errorMessage,
  ];
}
