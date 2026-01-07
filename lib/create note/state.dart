class CreateNoteState {
  final String title;
  final String content;
  final bool isSaving;
  final String? error;
  final bool isSuccess;

  CreateNoteState({
    required this.title,
    required this.content,
    required this.isSaving,
    required this.error,
    required this.isSuccess,
  });

  factory CreateNoteState.initial() {
    return CreateNoteState(
      title: '',
      content: '',
      isSaving: false,
      error: null,
      isSuccess: false,
    );
  }

  CreateNoteState copyWith({
    String? title,
    String? content,
    bool? isSaving,
    String? error,
    bool? isSuccess,
  }) {
    return CreateNoteState(
      title: title ?? this.title,
      content: content ?? this.content,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
