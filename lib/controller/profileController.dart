import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palliative_care/controller/sharedPreferences_Controller.dart';
import '../Firebase/auth_firebase.dart';
import '../Firebase/firestore.dart';

class ProfileController extends GetxController {

  CollectionReference userRef   = FirebaseFirestore.instance.collection('users');
  CollectionReference doctorRef = FirebaseFirestore.instance.collection('doctor');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? idUserLogin =  FbAuthController().getUser?.uid;
  RxBool typeUser = false.obs;
  RxBool isUserUpdateIamge = false.obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getImageProfile();
    getPostAuth();


  }

  Future<DocumentSnapshot> getPostAuth() async {
    String? id = SpHelper.getId();
    bool? type = SpHelper.getIsDoctor();
    print('id $id');
    if(type!){

      return doctorRef.doc(id).get();
    }else{
      return await userRef.doc(id).get();
    }


  }

  Future<void> signOut() async {
    SpHelper.deleteId();
    SpHelper.deleteName();
    SpHelper.deleteImage();
    SpHelper.deleteIsDoctor();
    SpHelper.deleteSpecialty();
    await _firebaseAuth.signOut();
  }

  Future updateImageProfile(String urlImage ) async {
    String? id =  FbAuthController().getUser?.uid;
    bool type = await  FirestoreController().getTypeUser(id!);
    if(type){
      doctorRef.doc(id).update({
        'image': urlImage,
      }).then((value) {
        isUserUpdateIamge.value = true;
        update();
        Get.showSnackbar(const GetSnackBar(
          message: 'تم تحديث الصورة بنجاح',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
      }

      ).catchError((error) => Get.showSnackbar(const GetSnackBar(
        message: 'حدث خطأ ما',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      )));
    }else{
      userRef.doc(id).update({
        'image': urlImage,
      }).then((value) => Get.showSnackbar(const GetSnackBar(
        message: 'تم تحديث الصورة بنجاح',
        duration: Duration(seconds: 2),
      ))).catchError((error) => Get.showSnackbar(const GetSnackBar(
        message: 'حدث خطأ ما',
        duration: Duration(seconds: 2),
      )));
    }
  }

  getImageProfile() async {
    String? id =FbAuthController().getUser?.uid;
    bool type = await  FirestoreController().getTypeUser(id!);
    if(type){
     await FirebaseFirestore.instance.collection('doctor').doc(id).get().then((value) => value.data()?['image'] == null ? isUserUpdateIamge.value = false : isUserUpdateIamge.value = true);
      update();
    }else{
      await FirebaseFirestore.instance.collection('users').doc(id).get().then((value) => value.data()?['image'] == null ? isUserUpdateIamge.value = false : isUserUpdateIamge.value = true);
      update();
    }
  }
}