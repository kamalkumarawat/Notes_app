import 'package:cloud_firestore/cloud_firestore.dart';

class Notes {
  final String id;
   String? title;
   String content;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notes({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notes.fromJson(Map<String, dynamic> json, String id) {
    return Notes(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Notes copyWith({String? title, String? content}) {
    return Notes(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
