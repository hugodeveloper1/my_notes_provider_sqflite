import 'package:flutter/material.dart';
import 'package:my_notes_provider_sqflite/controllers/note_controller.dart';
import 'package:my_notes_provider_sqflite/models/note_model.dart';
import 'package:provider/provider.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key, this.note});

  final NoteModel? note;

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late NoteController noteController;

  @override
  void initState() {
    super.initState();
    noteController = context.read<NoteController>();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                centerTitle: true,
                title: Text(
                  'New Note',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Card(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          controller: titleController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Card(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            controller: contentController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              border: InputBorder.none,
                              hintText: 'Content',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: widget.note != null
          ? floatingActionButton(
              value: 'Edit',
              icon: Icons.edit,
              onTap: () async {
                await context.read<NoteController>().editNote(
                      note: widget.note!,
                      title: titleController.text,
                      content: contentController.text,
                    );
              })
          : floatingActionButton(
              value: 'Publish',
              icon: Icons.add,
              onTap: () async {
                await context.read<NoteController>().addNote(
                      title: titleController.text,
                      content: contentController.text,
                    );
              },
            ),
    );
  }

  Widget? floatingActionButton({
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return titleController.text.trim().isNotEmpty &&
            contentController.text.trim().isNotEmpty
        ? FloatingActionButton.extended(
            icon: Icon(icon, color: Colors.black),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  contentController.text.trim().isNotEmpty) {
                onTap.call();
              }
            },
            backgroundColor: Colors.amberAccent.shade100,
            label: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : null;
  }
}
