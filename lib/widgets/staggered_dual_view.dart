import 'package:flutter/material.dart';
import 'package:my_notes_provider_sqflite/models/note_model.dart';

class StaggeredDualView extends StatelessWidget {
  const StaggeredDualView({
    super.key,
    required this.notes,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
    this.spacing = 15,
    required this.itemBuilder,
  });

  final List<NoteModel> notes;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double spacing;
  final Widget? Function(NoteModel) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constains) {
      double width = MediaQuery.of(context).size.width;
      double itemHeight = (width * 0.5) / childAspectRatio!;
      return GridView.builder(
        itemCount: notes.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount!,
          childAspectRatio: childAspectRatio!,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        padding: EdgeInsets.only(
          top: spacing,
          right: spacing,
          left: spacing,
          bottom: notes.length.isOdd ? spacing : spacing + (itemHeight * 0.3),
        ),
        itemBuilder: (context, index) {
          final note = notes[index];

          return Transform.translate(
            offset: Offset(0.0, index.isOdd ? itemHeight * 0.3 : 0),
            child: itemBuilder(note),
          );
        },
      );
    });
  }
}
