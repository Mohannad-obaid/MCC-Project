import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class GetPostsController extends GetxController {

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot>  getAllPosts(String idTopic) async* {
    yield* firebase
        .collection('Post')
        .where('category', isEqualTo: idTopic)
        .snapshots();
  }


}
