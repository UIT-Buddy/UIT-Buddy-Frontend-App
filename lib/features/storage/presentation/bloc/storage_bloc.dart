import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/create_files_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/create_folder_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/get_download_url_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/get_folder_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({
    required GetFolderUsecase getFolderUsecase,
    required GetDownloadUrlUsecase getDownloadUrlUsecase,
    required CreateFolderUsecase createFolderUsecase,
    required CreateFilesUsecase createFilesUsecase,
  }) : _getFolderUsecase = getFolderUsecase,
       _getDownloadUrlUsecase = getDownloadUrlUsecase,
       _createFolderUsecase = createFolderUsecase,
       _createFilesUsecase = createFilesUsecase,
       super(const StorageState()) {
    on<StorageStarted>(_onStorageStarted);
    on<StorageFolderOpened>(_onFolderOpened);
    on<StorageBackPressed>(_onBackPressed);
    on<StorageViewTypeToggled>(_onViewTypeToggled);
    on<StorageFileDownloadRequested>(_onFileDownloadRequested);
    on<StorageCreateFolder>(_onCreateFolder);
    on<StorageCreateFiles>(_onCreateFiles);
  }

  final GetFolderUsecase _getFolderUsecase;
  final GetDownloadUrlUsecase _getDownloadUrlUsecase;
  final CreateFolderUsecase _createFolderUsecase;
  final CreateFilesUsecase _createFilesUsecase;

  Future<void> _onStorageStarted(
    StorageStarted event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(isFolderLoading: true, viewMode: StorageViewMode.folder),
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
        ),
      ),
    );
  }

  Future<void> _onFolderOpened(
    StorageFolderOpened event,
    Emitter<StorageState> emit,
  ) async {
    emit(
      state.copyWith(
        viewMode: StorageViewMode.folder,
        currentFolder: () => null,
        isFolderLoading: true,
      ),
    );

    // Use provided folderId, or extract from folder (classCode for class folders)
    final folderId = event.folderId ?? event.folder?.classCode;
    if (folderId == null) return; // No folder ID available

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

  Future<void> _onFileDownloadRequested(
    StorageFileDownloadRequested event,
    Emitter<StorageState> emit,
  ) async {
    final result = await _getDownloadUrlUsecase(event.file.id);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
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
    emit(state.copyWith(isCreating: true));
    final parentFolderId = state.currentFolder?.id;
    final result = await _createFolderUsecase(
      CreateFolderParams(
        folderName: event.folderName,
        parentFolderId: parentFolderId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isCreating: false, errorMessage: () => failure.message),
      ),
      (_) => emit(state.copyWith(isCreating: false)),
    );

    // Refresh the current folder to show newly created folder
    if (result.isRight() && parentFolderId != null) {
      final refreshResult = await _getFolderUsecase(parentFolderId);
      refreshResult.fold(
        (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
        (folder) => emit(
          state.copyWith(currentFolder: () => folder, errorMessage: () => null),
        ),
      );
    }
  }

  Future<void> _onCreateFiles(
    StorageCreateFiles event,
    Emitter<StorageState> emit,
  ) async {
    emit(state.copyWith(isCreating: true));
    final folderId = state.currentFolder?.id;
    final result = await _createFilesUsecase(
      CreateFilesParams(files: event.files, folderId: folderId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: () => failure.message, isCreating: false),
      ),
      (_) => emit(state.copyWith(isCreating: false)),
    );

    // Refresh the current folder to show newly created files
    if (result.isRight() && folderId != null) {
      final refreshResult = await _getFolderUsecase(folderId);
      refreshResult.fold(
        (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
        (folder) => emit(
          state.copyWith(currentFolder: () => folder, errorMessage: () => null),
        ),
      );
    }
  }
}
