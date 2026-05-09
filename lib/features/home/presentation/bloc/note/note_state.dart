import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/note_entity.dart';

sealed class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteLoaded extends NoteState {
  const NoteLoaded({required this.note});

  final NoteEntity note;

  @override
  List<Object> get props => [note];
}

final class NoteError extends NoteState {
  const NoteError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class NoteSaveSuccess extends NoteState {
  const NoteSaveSuccess();
}
