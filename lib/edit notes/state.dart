// note_detail_state.dart
import 'package:equatable/equatable.dart';

import '../screens/home/model.dart';

abstract class NoteDetailState extends Equatable {
  const NoteDetailState();

  @override
  List<Object?> get props => [];
}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoading extends NoteDetailState {}
class NoteUpdateLoading extends NoteDetailState {}

class NoteDetailLoaded extends NoteDetailState {
  final Notes? note;

  const NoteDetailLoaded(this.note);

  @override
  List<Object?> get props => [note];
}
class NoteUpdated extends NoteDetailState {
  final Notes? note;

  const NoteUpdated(this.note);

  @override
  List<Object?> get props => [note];
}
// Error state
class NoteDetailError extends NoteDetailState {
  final String message;

  const NoteDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
class NoteUpdateError extends NoteDetailState {
  final String message;

  const NoteUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
