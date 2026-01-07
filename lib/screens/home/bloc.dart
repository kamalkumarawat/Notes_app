import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';
import 'model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadUserNotes>(_onLoadUserNotes);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadUserNotes(
    LoadUserNotes event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    await emit.forEach<QuerySnapshot>(
      FirebaseFirestore.instance
          .collection('users')
          .doc(event.userId)
          .collection('notes')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      onData: (snapshot) {
        return HomeLoaded(notes: snapshot.docs);
      },
      onError: (error, _) {
        return HomeError(error.toString());
      },
    );
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes')
          .doc(event.noteId)
          .delete();

    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
