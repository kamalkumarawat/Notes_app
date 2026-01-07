// note_detail_event.dart
import 'package:equatable/equatable.dart';

import '../screens/home/model.dart';

abstract class NoteDetailEvent extends Equatable {
  const NoteDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadNoteDetail extends NoteDetailEvent {
  final Notes? notes;

  const LoadNoteDetail(this.notes);

  @override
  List<Object?> get props => [notes];
}

class UpdateNoteDetail extends NoteDetailEvent {
  final Notes? note;

  const UpdateNoteDetail(this.note);

  @override
  List<Object?> get props => [note];
}
