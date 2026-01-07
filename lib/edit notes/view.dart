import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/edit%20notes/state.dart';

import '../internet_service.dart';
import '../no_internet.dart';
import '../screens/home/model.dart';
import 'bloc.dart';
import 'event.dart';

class NoteDetailScreen extends StatefulWidget {
  final Notes? note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  late StreamSubscription<bool> internetSubscription;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    InternetService.instance.initialize();
    internetSubscription = InternetService.instance.onStatusChange.listen((
      status,
    ) {
      setState(() {
        hasInternet = status;
      });
    });

    if (widget.note != null) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteDetailBloc()..add(LoadNoteDetail(widget.note!)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text(''), backgroundColor: Colors.white),
        body: hasInternet == false
            ? NoInternetView(
                onRetry: () {
                  InternetService.instance.initialize();
                },
              )
            : BlocConsumer<NoteDetailBloc, NoteDetailState>(
                listener: (context, state) {
                  if (state is NoteUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note updated successfully'),
                      ),
                    );
                    Navigator.of(context).pop(true);
                  }
                },
                builder: (context, state) {
                  if (state is NoteDetailError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  Notes? currentNote;
                  if (state is NoteDetailLoaded) {
                    currentNote = state.note;
                  } else if (state is NoteUpdateLoading) {
                    currentNote = widget.note;
                  } else {
                    currentNote = widget.note;
                  }

                  if (currentNote == null) {
                    return const Center(child: Text('Note not found'));
                  }

                  final isUpdating = state is NoteUpdateLoading;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: titleController,
                            enabled: !isUpdating,
                            style: TextStyle(
                              fontSize: 16,
                              backgroundColor: Colors.white,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            onChanged: (value) {
                              currentNote?.title = value;
                            },
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: contentController,
                            enabled: !isUpdating,
                            maxLines: 15,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            onChanged: (value) {
                              currentNote?.content = value;
                            },
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: isUpdating
                                  ? null
                                  : () {
                                      currentNote?.title = titleController.text;
                                      currentNote?.content =
                                          contentController.text;

                                      context.read<NoteDetailBloc>().add(
                                        UpdateNoteDetail(currentNote),
                                      );
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isUpdating
                                      ? Colors.grey
                                      : Colors.black,
                                  border: Border.all(
                                    color: isUpdating
                                        ? Colors.grey
                                        : Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: isUpdating
                                      ? Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          textAlign: TextAlign.center,
                                          'Update Note',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
