import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/document_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/domain/usecases/subject_class_usecase.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_event.dart';
import 'package:uit_buddy_mobile/features/storage/presentation/bloc/storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({
    required SubjectClassUsecase subjectClassUsecase,
    required DocumentUsecase documentUsecase,
  }) : _subjectClassUsecase = subjectClassUsecase,
       _documentUsecase = documentUsecase,
       super(const StorageState()) {
    on<StorageStarted>(_onStorageStarted);
    on<StorageFolderOpened>(_onFolderOpened);
    on<StorageBackPressed>(_onBackPressed);
    on<StorageViewTypeToggled>(_onViewTypeToggled);
  }

  final SubjectClassUsecase _subjectClassUsecase;
  final DocumentUsecase _documentUsecase;

  Future<void> _onStorageStarted(
    StorageStarted event,
    Emitter<StorageState> emit,
  ) async {
    emit(state.copyWith(isClassesLoading: true));

    final result = await _subjectClassUsecase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          isClassesLoading: false,
          errorMessage: () => failure.message,
        ),
      ),
      (classes) => emit(
        state.copyWith(
          isClassesLoading: false,
          classes: classes,
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
        currentFolder: () => event.folder,
        isDocumentsLoading: true,
        documents: () => null,
      ),
    );

    final result = await _documentUsecase(
      DocumentParams(classCode: event.folder.classCode),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isDocumentsLoading: false,
          errorMessage: () => failure.message,
        ),
      ),
      (docs) => emit(
        state.copyWith(
          isDocumentsLoading: false,
          documents: () => docs,
          errorMessage: () => null,
        ),
      ),
    );
  }

  void _onBackPressed(StorageBackPressed event, Emitter<StorageState> emit) {
    emit(
      state.copyWith(
        viewMode: StorageViewMode.topLevel,
        currentFolder: () => null,
        documents: () => null,
        errorMessage: () => null,
      ),
    );
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
}
