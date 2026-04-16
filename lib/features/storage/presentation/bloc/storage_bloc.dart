import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/create_files_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/create_folder_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/delete_file_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/get_download_url_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/get_folder_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/update_file_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({
    required GetFolderUsecase getFolderUsecase,
    required GetDownloadUrlUsecase getDownloadUrlUsecase,
    required CreateFolderUsecase createFolderUsecase,
    required CreateFilesUsecase createFilesUsecase,
    required UpdateFilesUsecase updateFilesUsecase,
    required DeleteFileUsecase deleteFileUsecase,
  }) : _getFolderUsecase = getFolderUsecase,
       _getDownloadUrlUsecase = getDownloadUrlUsecase,
       _createFolderUsecase = createFolderUsecase,
       _createFilesUsecase = createFilesUsecase,
       _updateFilesUsecase = updateFilesUsecase,
       _deleteFileUsecase = deleteFileUsecase,
       super(const StorageState()) {
    on<StorageStarted>(_onStorageStarted);
    on<StorageFolderOpened>(_onFolderOpened);
    on<StorageBackPressed>(_onBackPressed);
    on<StorageViewTypeToggled>(_onViewTypeToggled);
    on<StorageRefreshed>(_onRefreshed);
    on<StorageFileDownloadRequested>(_onFileDownloadRequested);
    on<StorageCreateFolder>(_onCreateFolder);
    on<StorageCreateFiles>(_onCreateFiles);
    on<StorageFileRenamed>(_onFileRenamed);
    on<StorageFileDeleted>(_onFileDeleted);
    on<StorageMoveStarted>(_onMoveStarted);
    on<StorageMoveCancelled>(_onMoveCancelled);
    on<StorageMoveConfirmed>(_onMoveConfirmed);
    on<StorageFeedbackCleared>(_onFeedbackCleared);
  }

  final GetFolderUsecase _getFolderUsecase;
  final GetDownloadUrlUsecase _getDownloadUrlUsecase;
  final CreateFolderUsecase _createFolderUsecase;
  final CreateFilesUsecase _createFilesUsecase;
  final UpdateFilesUsecase _updateFilesUsecase;
  final DeleteFileUsecase _deleteFileUsecase;

  Future<void> _onStorageStarted(
    StorageStarted event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(
        isFolderLoading: true,
        viewMode: StorageViewMode.folder,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final result = await _getFolderUsecase(null);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isFolderLoading: false,
          errorMessage: () => failure.message,
        ),
      ),
      (folder) => emit(
        state.copyWith(
          isFolderLoading: false,
          currentFolder: () => folder,
          folderStack: [folder],
          errorMessage: () => null,
          isMoveMode: false,
          movingFile: () => null,
          moveSourceFolderId: () => null,
        ),
      ),
    );
  }

  Future<void> _onFolderOpened(
    StorageFolderOpened event,
    Emitter<StorageState> emit,
  ) async {
    // Use provided folderId, or extract from folder (classCode for class folders)
    final folderId = event.folderId ?? event.folder?.classCode;
    if (folderId == null) {
      emit(
        state.copyWith(actionErrorMessage: () => 'Could not open this folder.'),
      );
      return;
    }

    emit(
      state.copyWith(viewMode: StorageViewMode.folder, isFolderLoading: true),
    );

    final result = await _getFolderUsecase(folderId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isFolderLoading: false,
          errorMessage: () => failure.message,
        ),
      ),
      (folder) {
        final newStack = [...state.folderStack, folder];
        return emit(
          state.copyWith(
            isFolderLoading: false,
            currentFolder: () => folder,
            folderStack: newStack,
            errorMessage: () => null,
          ),
        );
      },
    );
  }

  Future<void> _onBackPressed(
    StorageBackPressed event,
    Emitter<StorageState> emit,
  ) async {
    if (state.folderStack.isEmpty) {
      emit(
        state.copyWith(
          viewMode: StorageViewMode.topLevel,
          currentFolder: () => null,
          folderStack: [],
          errorMessage: () => null,
        ),
      );
      return;
    }

    final newStack = [...state.folderStack];
    newStack.removeLast();

    if (newStack.isEmpty) {
      emit(
        state.copyWith(
          viewMode: StorageViewMode.topLevel,
          currentFolder: () => null,
          folderStack: [],
          errorMessage: () => null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentFolder: () => newStack.last,
          folderStack: newStack,
          errorMessage: () => null,
        ),
      );
    }
  }

  void _onViewTypeToggled(
    StorageViewTypeToggled event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        viewType: state.viewType == StorageViewType.grid
            ? StorageViewType.list
            : StorageViewType.grid,
      ),
    );
  }

  Future<void> _onRefreshed(
    StorageRefreshed event,
    Emitter<StorageState> emit,
  ) async {
    if (state.isCreating || state.isFolderLoading) {
      return;
    }

    final folderId = state.currentFolder?.id;
    if (folderId == null) {
      await _onStorageStarted(const StorageStarted(), emit);
      return;
    }

    emit(
      state.copyWith(
        isFolderLoading: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final result = await _getFolderUsecase(folderId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isFolderLoading: false,
          actionErrorMessage: () => failure.message,
        ),
      ),
      (folder) => emit(
        state.copyWith(
          isFolderLoading: false,
          currentFolder: () => folder,
          folderStack: _replaceFolderInStack(folder),
          errorMessage: () => null,
        ),
      ),
    );
  }

  Future<void> _onFileDownloadRequested(
    StorageFileDownloadRequested event,
    Emitter<StorageState> emit,
  ) async {
    final result = await _getDownloadUrlUsecase(event.file.id);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionErrorMessage: () => failure.message)),
      (downloadUrl) {
        // Emit a state or handle download event
        // This could be expanded with a separate event and state handling
      },
    );
  }

  Future<void> _onCreateFolder(
    StorageCreateFolder event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(
        isCreating: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );
    final parentFolderId = state.currentFolder?.id;
    final result = await _createFolderUsecase(
      CreateFolderParams(
        folderName: event.folderName,
        parentFolderId: parentFolderId,
      ),
    );

    String? failureMessage;
    result.fold((failure) => failureMessage = failure.message, (_) {});

    if (failureMessage != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () => failureMessage,
        ),
      );
      return;
    }

    String? refreshError;
    if (parentFolderId != null) {
      refreshError = await _refreshCurrentFolder(
        emit,
        folderId: parentFolderId,
      );
    }

    if (refreshError != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () =>
              'Folder created, but failed to refresh: $refreshError',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: false,
        actionSuccessMessage: () => 'Folder created successfully.',
      ),
    );
  }

  Future<void> _onCreateFiles(
    StorageCreateFiles event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(
        isCreating: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );
    final folderId = state.currentFolder?.id;
    final result = await _createFilesUsecase(
      CreateFilesParams(files: event.files, folderId: folderId),
    );

    String? failureMessage;
    result.fold((failure) => failureMessage = failure.message, (_) {});

    if (failureMessage != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () => failureMessage,
        ),
      );
      return;
    }

    String? refreshError;
    if (folderId != null) {
      refreshError = await _refreshCurrentFolder(emit, folderId: folderId);
    }

    if (refreshError != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () =>
              'Files uploaded, but failed to refresh: $refreshError',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: false,
        actionSuccessMessage: () => 'Files uploaded successfully.',
      ),
    );
  }

  Future<void> _onFileRenamed(
    StorageFileRenamed event,
    Emitter<StorageState> emit,
  ) async {
    final trimmedName = event.newFileName.trim();
    if (trimmedName.isEmpty) {
      emit(
        state.copyWith(actionErrorMessage: () => 'File name cannot be empty.'),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final folderId = state.currentFolder?.id;
    final result = await _updateFilesUsecase(
      UpdateFilesParams(
        documentId: event.documentId,
        fileName: trimmedName,
        folderId: folderId,
      ),
    );

    String? failureMessage;
    result.fold((failure) => failureMessage = failure.message, (_) {});

    if (failureMessage != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () => failureMessage,
        ),
      );
      return;
    }

    String? refreshError;
    if (folderId != null) {
      refreshError = await _refreshCurrentFolder(emit, folderId: folderId);
    }

    if (refreshError != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () =>
              'File renamed, but failed to refresh: $refreshError',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: false,
        actionSuccessMessage: () => 'File renamed successfully.',
      ),
    );
  }

  Future<void> _onFileDeleted(
    StorageFileDeleted event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(
        isCreating: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final folderId = state.currentFolder?.id;
    final result = await _deleteFileUsecase(event.documentId);

    String? failureMessage;
    result.fold((failure) => failureMessage = failure.message, (_) {});

    if (failureMessage != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () => failureMessage,
        ),
      );
      return;
    }

    String? refreshError;
    if (folderId != null) {
      refreshError = await _refreshCurrentFolder(emit, folderId: folderId);
    }

    if (refreshError != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () =>
              'File deleted, but failed to refresh: $refreshError',
        ),
      );
      return;
    }

    final isDeletedMovingFile = state.movingFile?.id == event.documentId;
    emit(
      state.copyWith(
        isCreating: false,
        isMoveMode: isDeletedMovingFile ? false : null,
        movingFile: isDeletedMovingFile ? () => null : null,
        moveSourceFolderId: isDeletedMovingFile ? () => null : null,
        actionSuccessMessage: () => 'File deleted successfully.',
      ),
    );
  }

  void _onMoveStarted(StorageMoveStarted event, Emitter<StorageState> emit) {
    final sourceFolderId = state.currentFolder?.id;
    if (sourceFolderId == null) {
      emit(
        state.copyWith(
          actionErrorMessage: () =>
              'Could not start move mode. Please open a folder first.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isMoveMode: true,
        movingFile: () => event.file,
        moveSourceFolderId: () => sourceFolderId,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );
  }

  void _onMoveCancelled(
    StorageMoveCancelled event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        isMoveMode: false,
        movingFile: () => null,
        moveSourceFolderId: () => null,
      ),
    );
  }

  Future<void> _onMoveConfirmed(
    StorageMoveConfirmed event,
    Emitter<StorageState> emit,
  ) async {
    final file = state.movingFile;
    final destinationFolderId = state.currentFolder?.id;

    if (file == null || destinationFolderId == null) {
      emit(
        state.copyWith(
          actionErrorMessage: () => 'Please select a destination folder.',
        ),
      );
      return;
    }

    if (destinationFolderId == state.moveSourceFolderId) {
      emit(
        state.copyWith(
          actionErrorMessage: () => 'Please choose a different folder.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: true,
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );

    final result = await _updateFilesUsecase(
      UpdateFilesParams(
        documentId: file.id,
        fileName: file.name,
        folderId: destinationFolderId,
      ),
    );

    String? failureMessage;
    result.fold((failure) => failureMessage = failure.message, (_) {});

    if (failureMessage != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () => failureMessage,
        ),
      );
      return;
    }

    final refreshError = await _refreshCurrentFolder(
      emit,
      folderId: destinationFolderId,
    );

    if (refreshError != null) {
      emit(
        state.copyWith(
          isCreating: false,
          actionErrorMessage: () =>
              'File moved, but failed to refresh: $refreshError',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreating: false,
        isMoveMode: false,
        movingFile: () => null,
        moveSourceFolderId: () => null,
        actionSuccessMessage: () => 'File moved successfully.',
      ),
    );
  }

  void _onFeedbackCleared(
    StorageFeedbackCleared event,
    Emitter<StorageState> emit,
  ) {
    emit(
      state.copyWith(
        actionErrorMessage: () => null,
        actionSuccessMessage: () => null,
      ),
    );
  }

  Future<String?> _refreshCurrentFolder(
    Emitter<StorageState> emit, {
    required String folderId,
  }) async {
    final refreshResult = await _getFolderUsecase(folderId);

    String? refreshError;
    refreshResult.fold(
      (failure) => refreshError = failure.message,
      (folder) => emit(
        state.copyWith(
          currentFolder: () => folder,
          folderStack: _replaceFolderInStack(folder),
          errorMessage: () => null,
        ),
      ),
    );

    return refreshError;
  }

  List<FolderEntity> _replaceFolderInStack(FolderEntity folder) {
    if (state.folderStack.isEmpty) {
      return [folder];
    }

    final updatedStack = [...state.folderStack];
    final existingIndex = updatedStack.lastIndexWhere((f) => f.id == folder.id);

    if (existingIndex != -1) {
      updatedStack[existingIndex] = folder;
      return updatedStack.sublist(0, existingIndex + 1);
    }

    updatedStack[updatedStack.length - 1] = folder;
    return updatedStack;
  }
}
