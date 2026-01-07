import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/screens/home/model.dart';

class NoteService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

   Future<void> createNote(Notes note) async{
    final uid = auth.currentUser?.uid;

      await firestore
          .collection('users')
          .doc(uid)
          .collection('notes')
          .doc(note.id)
          .set({
        'title': note.title,
        'content': note.content,
        'createdAt': note.createdAt,
        'updatedAt': note.updatedAt,
        'userId': uid,
      });
    }
   }