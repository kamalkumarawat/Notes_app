import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/screens/home/bloc.dart';
import 'package:shop/screens/home/state.dart';

import '../../connection_service.dart';
import '../../internet_service.dart';
import '../../no_internet.dart';
import '../../routes.dart';
import 'event.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Notes>? notes;
  late StreamSubscription<bool> internetSubscription;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    InternetService.instance.initialize();
    loadUserNotes();

    internetSubscription = InternetService.instance.onStatusChange.listen((
      status,
    ) {
      setState(() {
        hasInternet = status;
      });
      if (status) {
        loadUserNotes();
      }
    });
  }
  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  void loadUserNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      context.read<HomeBloc>().add(LoadUserNotes(user.uid));
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: hasInternet == false
            ? NoInternetView(
                onRetry: () {
                  InternetService.instance.initialize();
                },
              )
            : BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is HomeLoading ) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeLoaded) {
                    if (state.notes!.isEmpty) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                Routes.createNote,
                              );
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null && result == true) {
                                context.read<HomeBloc>().add(
                                  LoadUserNotes(user.uid),
                                );
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 8,
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/login');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: 16,
                                      ),
                                      child: Icon(Icons.logout),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: const Text("No notes found"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text("Notes"),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  Routes.createNote,
                                );
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null && result == true) {
                                  context.read<HomeBloc>().add(
                                    LoadUserNotes(user.uid),
                                  );
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Icon(Icons.add),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed('/login');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.logout),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.notes?.length,
                              itemBuilder: (context, index) {
                                final note = state.notes?[index];

                                return GestureDetector(
                                  onTap: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minHeight: 100,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    note?['title'] ?? "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    note?['content'] ?? "",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () async {
                                                    final noteModel =
                                                        Notes.fromJson(
                                                          note.data()
                                                              as Map<
                                                                String,
                                                                dynamic
                                                              >,
                                                          note.id,
                                                        );
                                                    final result =
                                                        await Navigator.pushNamed(
                                                          context,
                                                          Routes.notesDetails,
                                                          arguments: noteModel,
                                                        );
                                                    if (result == true) {
                                                      final user = FirebaseAuth
                                                          .instance
                                                          .currentUser;
                                                      context
                                                          .read<HomeBloc>()
                                                          .add(
                                                            LoadUserNotes(
                                                              user?.uid,
                                                            ),
                                                          );
                                                    }
                                                  },
                                                ),
                                                SizedBox(width: 8),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    final confirm =
                                                        await showDialog<bool>(
                                                          context: context,
                                                          builder: (_) => AlertDialog(
                                                            title: const Text(
                                                              'Delete Note',style: TextStyle(fontSize: 16),
                                                            ),
                                                            content: const Text(
                                                              'Are you sure?',style: TextStyle(fontSize: 13)
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                      false,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      'Cancel',
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                      true,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      'Delete',
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                    if (confirm == true &&
                                                        context.mounted) {
                                                      context
                                                          .read<HomeBloc>()
                                                          .add(
                                                            DeleteNote(
                                                              noteId: note.id,
                                                            ),
                                                          );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Text('something went wrong');
                },
              ),
      ),
    );
  }
}
