import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/get_note_usecase.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/new_note_usecase.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/save_to_document_usecase.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/upsert_note_usecase.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc({
    required GetNoteUsecase getNoteUsecase,
    required UpsertNoteUsecase upsertNoteUsecase,
    required NewNoteUsecase newNoteUsecase,
    required SaveToDocumentUsecase saveToDocumentUsecase,
  }) : _getNoteUsecase = getNoteUsecase,
       _upsertNoteUsecase = upsertNoteUsecase,
       _newNoteUsecase = newNoteUsecase,
       _saveToDocumentUsecase = saveToDocumentUsecase,
       super(NoteInitial()) {
    on<FetchNoteRequested>(_onFetchNoteRequested);
    on<SaveNoteRequested>(_onSaveNoteRequested);
    on<ClearNoteRequested>(_onClearNoteRequested);
    on<SaveNoteToDocumentRequested>(_onSaveNoteToDocumentRequested);
  }

  final GetNoteUsecase _getNoteUsecase;
  final UpsertNoteUsecase _upsertNoteUsecase;
  final NewNoteUsecase _newNoteUsecase;
  final SaveToDocumentUsecase _saveToDocumentUsecase;

  Future<void> _onFetchNoteRequested(
    FetchNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());

    final failureOrNote = await _getNoteUsecase.call(NoParams());

    failureOrNote.fold(
      (failure) => emit(NoteError(message: failure.message)),
      (note) => emit(NoteLoaded(note: note)),
    );
  }

  Future<void> _onSaveNoteRequested(
    SaveNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());

    final failureOrSuccess = await _upsertNoteUsecase.call(event.content);

    failureOrSuccess.fold(
      (failure) => emit(NoteError(message: failure.message)),
      (_) => emit(const NoteSaveSuccess()),
    );
  }

  Future<void> _onClearNoteRequested(
    ClearNoteRequested event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());

    final failureOrSuccess = await _newNoteUsecase.call(NoParams());

    failureOrSuccess.fold(
      (failure) => emit(NoteError(message: failure.message)),
      (_) => emit(const NoteClearSuccess()),
    );
  }

  Future<void> _onSaveNoteToDocumentRequested(
    SaveNoteToDocumentRequested event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());

    final failureOrSuccess = await _saveToDocumentUsecase.call(
      SaveToDocumentParams(fileName: event.fileName, folderId: event.folderId),
    );

    failureOrSuccess.fold(
      (failure) => emit(NoteError(message: failure.message)),
      (docUrl) => emit(NoteSaveToDocumentSuccess(docUrl: docUrl)),
    );
  }
}
