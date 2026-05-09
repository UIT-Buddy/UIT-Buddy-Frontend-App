import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  const NoteEntity({this.mssv, this.content, this.updatedAt});

  final String? mssv;
  final String? content;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [mssv, content, updatedAt];
}
