import 'package:my_notes_provider_sqflite/db/note_db_helper.dart';
import 'package:my_notes_provider_sqflite/models/note_model.dart';

class NoteUtils {
  final dbHelper = NoteDBHelper.instance;

  Future<List<NoteModel>> getAllNotes() async {
    try {
      final notes = await dbHelper.getAllNotes();

      return notes;
    } catch (e) {
      throw 'err: $e';
    }
  }

  Future<NoteModel> addNote({
    required String title,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final date = now.toIso8601String();

      final note = NoteModel(
        title: title,
        content: content,
        date: date,
        updatedDate: date,
      );

      final id = await dbHelper.insertNote(note);
      return note.copyWith(id: id);
    } catch (e) {
      throw 'err: $e';
    }
  }

  Future<int> deleteNote({
    required int noteId,
  }) async {
    try {
      final id = await dbHelper.deleteNote(noteId);
      return id;
    } catch (e) {
      throw 'err: $e';
    }
  }

  Future<NoteModel> editNote({
    required NoteModel note,
    required String title,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final date = now.toIso8601String();

      final newNote = NoteModel(
        title: title,
        content: content,
        date: note.date,
        updatedDate: date,
      );

      final id = await dbHelper.updateNote(newNote);
      return newNote.copyWith(id: id);
    } catch (e) {
      throw 'err: $e';
    }
  }
}
