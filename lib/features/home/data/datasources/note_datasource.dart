import 'package:uit_buddy_mobile/features/home/data/models/note_model.dart';

abstract interface class NoteDatasource {
  Future<NoteModel> getNote();
  Future<void> upsertNote(String content);
  Future<void> newNote();
  Future<String> saveToDocument(String fileName, String folderId);
}
