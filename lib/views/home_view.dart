import 'package:flutter/material.dart';
import 'package:my_notes_provider_sqflite/controllers/note_controller.dart';
import 'package:my_notes_provider_sqflite/views/add_note_view.dart';
import 'package:my_notes_provider_sqflite/widgets/note_card.dart';
import 'package:my_notes_provider_sqflite/widgets/staggered_dual_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late NoteController noteController;
  final String title = 'My notes';

  final Duration duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    noteController = context.read<NoteController>();
    noteController.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NoteController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          if (controller.isMultiSelected) {
            context.read<NoteController>().changeStatus();
            return false;
          } else {
            return true;
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.sort),
                ),
                pinned: true,
                elevation: 0,
                actions: controller.isMultiSelected
                    ? [
                        IconButton(
                          onPressed: () {
                            context.read<NoteController>().deleteNotes();
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ]
                    : [],
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
                expandedHeight: size.width * 0.8,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final isExpanded =
                        constraints.maxHeight > kToolbarHeight * 2.2;

                    return FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      titlePadding: EdgeInsets.zero,
                      centerTitle: true,
                      title: AnimatedOpacity(
                        opacity: isExpanded ? 0 : 1,
                        duration: duration,
                        child: SizedBox(
                          height: kToolbarHeight,
                          child: Center(
                            child: Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      background: AnimatedOpacity(
                        duration: duration,
                        opacity: isExpanded ? 1 : 0,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          margin: const EdgeInsets.only(top: kToolbarHeight),
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: size.width * 0.13,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: StaggeredDualView(
            notes: controller.notes,
            spacing: size.width * 0.04,
            itemBuilder: (note) {
              return NoteCard(
                note: note,
                isMultiSelected: controller.isMultiSelected,
                onLongPress: () {
                  if (!controller.isMultiSelected) {
                    final ctr = context.read<NoteController>();
                    ctr.changeStatusSelected();
                    ctr.selectedNotes(note: note);
                  }
                },
                onTap: () {
                  final ctr = context.read<NoteController>();
                  ctr.selectedNotes(note: note);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: controller.isMultiSelected
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNoteView(),
                    ));
              },
              backgroundColor: Colors.amberAccent.shade100,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
    );
  }
}
