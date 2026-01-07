abstract class HomeEvent {}

class LoadUserNotes extends HomeEvent {
  final dynamic userId;
  LoadUserNotes(this.userId);
}

class DeleteNote extends HomeEvent {
  final dynamic? noteId;

  DeleteNote({required this.noteId});
}