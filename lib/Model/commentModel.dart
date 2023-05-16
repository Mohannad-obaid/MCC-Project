import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String postId;
  final String userId;
  final String comment;
  final Timestamp timestamp = Timestamp.now();

  CommentModel({
    required this.postId,
    required this.userId,
    required this.comment, required timestamp,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      postId: data['postId'],
      userId: data['userId'] ,
      comment: data['comment'] ,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  static List<CommentModel> fromFirestore2(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
  }
}

