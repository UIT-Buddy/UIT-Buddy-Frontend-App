import 'package:equatable/equatable.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

final class FetchNoteRequested extends NoteEvent {
  const FetchNoteRequested();
}

final class SaveNoteRequested extends NoteEvent {
  const SaveNoteRequested({required this.content});

  final String content;

  @override
  List<Object> get props => [content];
}
