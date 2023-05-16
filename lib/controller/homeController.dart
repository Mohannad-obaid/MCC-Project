
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:palliative_care/Model/doctorModel.dart';
import 'package:palliative_care/Model/postModel.dart';
import '../Model/commentModel.dart';
import '../Model/likeModel.dart';
import '../Model/userModel.dart';


class HomeController extends GetxController {

  RxList likeList = [].obs;
  RxList<CommentModel> commentsList = <CommentModel>[].obs;
  RxList<CommentModel> commentsListSingelPost = <CommentModel>[].obs;
  RxList userList = [].obs;
  RxList userListSingelPost = [].obs;
  RxString postId = ''.obs;


  RxList<LikeModel> postLike = <LikeModel>[].obs;



  CollectionReference postRef = FirebaseFirestore.instance.collection('Post');
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference doctorRef = FirebaseFirestore.instance.collection('doctor');

  Future<void> addLike(LikeModel likeModel) async {
    await postRef.doc(likeModel.postId).collection('like')
        .add(likeModel.toFirestore())
        .then((value) => print("like Added"))
        .catchError((error) => print("Failed to add like: $error"));
  }

  Future getLikeCount(String postId) async {
    postRef.doc(postId).collection('like').snapshots().listen((event) {
      likeList.value = event.docs;
      print(likeList.length);
      update();
    });
  }

  Future addComment(CommentModel commentModel) async {
    await postRef.doc(commentModel.postId).collection('comment')
        .add(commentModel.toFirestore())
        .then((value) => print("comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }

  Stream getComment2(String idPost) async* {
    yield* postRef.doc(idPost).collection('comment').snapshots();

  }

  Future getComment01(String postID) async {
    QuerySnapshot snapshot =  await postRef.doc(postID).collection('comment').snapshots().first;
    List<CommentModel> comments = snapshot.docs.map((doc) {
      getAouthor(doc['userId']);
      return CommentModel.fromFirestore(doc);
    }).toList();
    commentsList.assignAll(comments);
    update();
    return comments;
  }

  Future getAouthor(String id) async {

    DocumentSnapshot snapshot = await userRef.doc(id).get();

    if(snapshot.exists) {
      UserModel user = UserModel.fromSnapshot(snapshot);
      userList.add(user);
      update();
    }else{
      DocumentSnapshot snapshot = await doctorRef.doc(id).get();
      DoctorModel user = DoctorModel.fromSnapshot(snapshot);
      userList.add(user);
      update();
    }




  }



  Future getAouthoruserSingelPost(String id) async {

    DocumentSnapshot snapshot = await userRef.doc(id).get();

    if(snapshot.exists) {
      UserModel user = UserModel.fromSnapshot(snapshot);
      userListSingelPost.add(user);
      update();
    }else{
      DocumentSnapshot snapshot = await doctorRef.doc(id).get();
      DoctorModel user = DoctorModel.fromSnapshot(snapshot);
      userListSingelPost.add(user);
      update();
    }

  }

  Future<PostModel>? getSinglePost() async {
    DocumentSnapshot snapshot = await postRef.doc(postId.value).get();
    PostModel post = PostModel.fromSnapshot(snapshot);
    return post;
  }

    getAllCommentsSinglePost(String idPost) async {
      postRef.doc(idPost).collection('comment').orderBy('timestamp', descending: true).snapshots().listen((event) {
        commentsListSingelPost.value = event.docs.map((doc) {
          getAouthoruserSingelPost(doc['userId']);
          print(doc['userId']);
          return CommentModel.fromFirestore(doc);
        }).toList();
        update();
    });

  }

  getLike(String idPost) async {
    postRef.doc(idPost).collection('like').snapshots().listen((event) {
      postLike.value = event.docs.map((doc) {
        return LikeModel.fromFirestore(doc);
      }).toList();
      update();
    });


  }

  RxList<QuerySnapshot> qsList = <QuerySnapshot>[].obs;

  Future getComment011(String postID) async {
    QuerySnapshot snapshot =  await postRef.doc(postID).collection('comment').get();

    for(int i = 0; i < snapshot.size; i++){
      qsList.add(snapshot);
      update();
    }

  }

}






