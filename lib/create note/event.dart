abstract class CreateNoteEvent {}

class TitleChanged extends CreateNoteEvent {
  final String title;
  TitleChanged(this.title);
}

class ContentChanged extends CreateNoteEvent {
  final String content;
  ContentChanged(this.content);
}

class SaveNotePressed extends CreateNoteEvent {}
class ResetCreateNoteState extends CreateNoteEvent {}
