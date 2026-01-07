import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/create%20note/state.dart';
import 'package:shop/note_service.dart';
import 'package:shop/screens/home/model.dart';

import '../connection_service.dart';
import 'event.dart';

class CreateNoteBloc extends Bloc<CreateNoteEvent, CreateNoteState> {
  final NoteService noteService;

  CreateNoteBloc({required this.noteService}) : super(CreateNoteState.initial()) {
    on<TitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<ContentChanged>((event, emit) {
      emit(state.copyWith(content: event.content));
    });
    on<ResetCreateNoteState>((event, emit) {
      emit(CreateNoteState.initial());
    });
    on<SaveNotePressed>((event, emit) async {
      var hasInternet = await InternetChecker.hasInternet();
      if(!hasInternet){
        emit(state.copyWith(isSaving: false,error: "No Internet"));
      }
      emit(state.copyWith(isSaving: true));

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(state.copyWith(error: "user not found"));
        return;
      }
    try{
      final note = Notes(
        id: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notes')
            .doc()
            .id,
        title: state.title,
        content: state.content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: currentUser.uid.toString(),
      );
      await noteService.createNote(note);
      emit(state.copyWith( isSuccess: true,isSaving: false));

    }catch(e){
      emit(state.copyWith(error: e.toString(), isSuccess: false));
    }
    });
  }
}
