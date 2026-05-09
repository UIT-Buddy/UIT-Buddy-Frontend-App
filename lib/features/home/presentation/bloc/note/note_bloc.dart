import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/get_note_usecase.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/upsert_note_usecase.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/note/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc({
    required GetNoteUsecase getNoteUsecase,
    required UpsertNoteUsecase upsertNoteUsecase,
  }) : _getNoteUsecase = getNoteUsecase,
       _upsertNoteUsecase = upsertNoteUsecase,
       super(NoteInitial()) {
    on<FetchNoteRequested>(_onFetchNoteRequested);
    on<SaveNoteRequested>(_onSaveNoteRequested);
  }

  final GetNoteUsecase _getNoteUsecase;
  final UpsertNoteUsecase _upsertNoteUsecase;

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
}
