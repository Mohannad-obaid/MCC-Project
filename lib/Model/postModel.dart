import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String id;
  late String title;
  late String body;
  late String category;
  late String userId;
  late String image;
  late Timestamp createdAt ;



  PostModel(
  {
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.image,
    required this.category,
    required this.createdAt,
}
  );

  factory PostModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      title: data['title'],
      body: data['body'],
      userId: data['userId'],
      image: data['image'],
      category: data['category'],
      createdAt: data['createdAt'],

    );
  }

   Map<String, dynamic> toMap() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['id'] = id;
     data['title'] = title;
     data['body'] = body;
     data['userId'] = userId;
     data['image'] = image;
     data['category'] = category;
     data['createdAt'] = createdAt;
     data['allText'] = '$title $body';

     return data;
   }


  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    userId = json['userId'];
    image = json['image'];
    category = json['category'];
  }

}
