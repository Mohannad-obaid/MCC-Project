import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CategoryController extends GetxController {

  TextEditingController nameController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchCategory();
  }

  Stream<QuerySnapshot> fetchCategory() async* {
    yield* FirebaseFirestore.instance.collection('category').snapshots();
  }

  Future<void> addCategory(String name,String imageUrl) async {
    await FirebaseFirestore.instance.collection('category').add({
      'name': name,
      'image': imageUrl,
    }).then((value) => Get.showSnackbar(
        const GetSnackBar(
          message: 'تم اضافة القسم بنجاح',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        )
    )).catchError((e) => Get.showSnackbar(
        const GetSnackBar(
          message: 'حدث خطأ ما',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )
    ));
  }

}