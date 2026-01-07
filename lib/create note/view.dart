import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/create%20note/state.dart';

import '../internet_service.dart';
import '../no_internet.dart';
import '../note_service.dart';
import 'bloc.dart';
import 'event.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final noteService = NoteService();
  late StreamSubscription<bool> internetSubscription;
  bool hasInternet = true;
  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: hasInternet == false
          ? NoInternetView(
              onRetry: () {
                InternetService.instance.initialize();
              },
            )
          : BlocConsumer<CreateNoteBloc, CreateNoteState>(
              listener: (context, state) {
                if (state.error == 'No Internet') {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                }
                if (state.isSuccess) {
                  Navigator.pop(context, true);
                  context.read<CreateNoteBloc>().add(ResetCreateNoteState());
                }
              },

              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<CreateNoteBloc>().add(
                            TitleChanged(value.trim()),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: contentController,
                        maxLines: 15,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Note',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (value) {
                          context.read<CreateNoteBloc>().add(
                            ContentChanged(value.trim()),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            context.read<CreateNoteBloc>().add(
                              SaveNotePressed(),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: state.isSaving
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
