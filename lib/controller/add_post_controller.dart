import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Firebase/auth_firebase.dart';
import '../Firebase/firestore.dart';
import '../Model/postModel.dart';


class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedItem;


  late TextEditingController title;
  late TextEditingController subject;
  late TextEditingController selectedCategory;
  RxInt numImage = 0.obs;


  @override
  void onInit() {
    getData();
    getCurrentUser();
    title = TextEditingController();
    subject = TextEditingController();
    selectedCategory = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    title.dispose();
    subject.dispose();
    selectedCategory.dispose();

    super.dispose();
  }

  Future<bool> createPost(PostModel post) async {
    try {
       await _firestore
          .collection('Post')
          .add(post.toMap())
          .then((value) =>
          FirebaseFirestore.instance
              .collection('Post')
              .doc(value.id)
              .update({'id': value.id})
      );

       Get.showSnackbar(const GetSnackBar(
         message: 'تم اضافة المنشور بنجاح',
         duration: Duration(seconds: 2),
         snackPosition: SnackPosition.BOTTOM,
         backgroundColor: Colors.green,
       ));

       return true;
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: 'حدث خطأ ما',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
      return false;

    }

  }

  void getData() async {
    final post = await _firestore.collection('posts').get();
    for (var data in post.docs) {
      print(data.data());
    }
  }

  Future getCurrentUser() async {
    String? id =  FbAuthController().getUser?.uid;
    bool type = await  FirestoreController().getTypeUser(id!);
    if(type){
      return await _firestore.collection('doctor').doc(id).get();
    }else{
      return await _firestore.collection('users').doc(id).get();
    }
  }

}


