import 'package:uit_buddy_mobile/features/home/data/models/note_model.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/note_entity.dart';

extension NoteModelMapper on NoteModel {
  NoteEntity toEntity() =>
      NoteEntity(mssv: mssv, content: content, updatedAt: updatedAt);
}
