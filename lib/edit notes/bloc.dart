// note_detail_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/edit%20notes/state.dart';

import 'event.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  NoteDetailBloc() : super(NoteDetailInitial()) {
    on<LoadNoteDetail>((event, emit) async {
      emit(NoteDetailLoading());
      try {
        emit(NoteDetailLoaded(event.notes));
      } catch (e) {
        emit(NoteDetailError('Note not found'));
      }
    });

    on<UpdateNoteDetail>((event, emit) async {
      emit(NoteUpdateLoading());
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(NoteUpdateError("User not found"));
        return;
      }
      try {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('notes')
            .doc(event.note?.id);

        await docRef.update({
          'title': event.note?.title,
          'content': event.note?.content,
          'updatedAt': Timestamp.now(),
        });
        print("note updated");
        emit(NoteUpdated(event.note));
      } catch (e) {
        emit(NoteDetailError("Failed to update note: $e"));
      }
    });
  }
}
