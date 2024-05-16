import 'package:flutter/material.dart';
import 'package:my_notes_provider_sqflite/models/note_model.dart';
import 'package:intl/intl.dart';
import 'package:my_notes_provider_sqflite/views/add_note_view.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.isMultiSelected = false,
    required this.onLongPress,
    required this.onTap,
  });

  final NoteModel note;
  final bool isMultiSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.isSelected ? const Color(0xFFF5F5F5) : Colors.white,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: isMultiSelected
            ? onTap
            : () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNoteView(
                    note: note,
                  );
                }));
              },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        note.content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    dateText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            isMultiSelected
                ? Positioned(
                    top: 7,
                    right: 7,
                    child: note.isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Colors.amberAccent.shade100,
                            size: 20,
                          )
                        : const Icon(
                            Icons.check_circle_outline,
                            color: Colors.black,
                            size: 20,
                          ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String get dateText {
    // Convertir la cadena ISO 8601 a un objeto DateTime
    final DateTime parsedDate = DateTime.parse(note.date);

    // Usar intl para formatear la fecha
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = dateFormatter.format(parsedDate);
    return formattedDate;
  }
}
