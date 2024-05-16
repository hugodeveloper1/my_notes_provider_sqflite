import 'package:flutter/material.dart';
import 'package:my_notes_provider_sqflite/models/note_model.dart';
import 'package:my_notes_provider_sqflite/utils/note_utils.dart';

class NoteController extends ChangeNotifier {
  List<NoteModel> _notes = [];
  List<NoteModel> get notes {
    _notes.sort((a, b) => a.updatedDate.compareTo(b.updatedDate));
    final list = _notes.reversed.toList();
    return list;
  }

  bool _isMultiSelected = false;
  bool get isMultiSelected => _isMultiSelected;

  void getNotes() async {
    final allNotes = await NoteUtils().getAllNotes();
    _notes = allNotes;
    notifyListeners();
  }

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final newNote = await NoteUtils().addNote(
      title: title,
      content: content,
    );
    _notes.add(newNote);
    notifyListeners();
  }

  void selectedNotes({
    required NoteModel note,
  }) {
    final nts = _notes.map((e) {
      if (e.id == note.id) return e.copyWith(isSelected: !note.isSelected);
      return e;
    }).toList();

    _notes = nts;

    bool f = _notes.any((element) => element.isSelected);

    if (!f) {
      _isMultiSelected = false;
    }

    notifyListeners();
  }

  Future<void> deleteNotes() async {
    List<NoteModel> nts = [];
    for (var element in _notes) {
      if (element.isSelected) {
        await NoteUtils().deleteNote(noteId: element.id ?? 0);
      } else {
        nts.add(element);
      }
    }

    _notes = nts;
    notifyListeners();

    changeStatus();
  }

  Future<void> deleteNote({
    required NoteModel note,
  }) async {
    await NoteUtils().deleteNote(noteId: note.id ?? 0);
    _notes.remove(note);
    notifyListeners();
  }

  void changeStatusSelected() {
    _isMultiSelected = !_isMultiSelected;
    notifyListeners();
  }

  void changeStatus() {
    final nts = _notes.map((e) {
      return e.copyWith(isSelected: false);
    }).toList();

    _notes = nts;
    _isMultiSelected = !_isMultiSelected;
    notifyListeners();
  }

  Future<void> editNote({
    required NoteModel note,
    required String title,
    required String content,
  }) async {
    notifyListeners();

    final newNote = await NoteUtils().editNote(
      note: note,
      title: title,
      content: content,
    );

    final nts = _notes.map((e) {
      if (e.id == note.id) return newNote;
      return e;
    }).toList();

    _notes = nts;
    notifyListeners();
  }
}
