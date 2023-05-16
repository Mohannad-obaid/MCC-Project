import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/doctorModel.dart';
import '../Model/userModel.dart';
import '../controller/sharedPreferences_Controller.dart';

class FirestoreController {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('doctor');
  final CollectionReference _collectionReference2 = FirebaseFirestore.instance.collection('users');

  Future<bool> addToFirestore({required UserModel userModel}) async {
    return await  _collectionReference
        .doc(userModel.id)
        .set(userModel.toJson())
        .then((value) {
      return true;
    }).catchError((onError) {
      print('Error adding document');
      print(onError);
      return false;
    });
  }

  Future<bool> addToFirestoreDoctor({required DoctorModel doctorModel}) async {
    return await  _collectionReference2
        .doc(doctorModel.id)
        .set(doctorModel.toJson())
        .then((value) {
      return true;
    }).catchError((onError) {
      print('Error adding document');
      print(onError);
      return false;
    });
  }

  Future<bool> update({required UserModel userModel}) async {
    await _collectionReference
        .doc(userModel.id)
        .update(userModel.toJson())
        .then((value) => true)
        .catchError((onError) => false);
    return false;
  }

  Future<bool> delete({required String path}) async {
    await _collectionReference
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((onError) => false);
    return false;
  }

  Stream<QuerySnapshot> getData() async* {
    yield* _collectionReference.snapshots();
  }

  getTypeUser(String id) async {
    DocumentSnapshot  documentSnapshot = await _collectionReference.doc(id).get();
    if(documentSnapshot.exists){
      SpHelper.isDoctor(true);
      SpHelper.saveId(id);
      SpHelper.saveName((documentSnapshot.data() as Map<String, dynamic>)?['name']);
      SpHelper.saveImage((documentSnapshot.data() as Map<String, dynamic>)?['image']);
      SpHelper.saveSpecialty((documentSnapshot.data() as Map<String, dynamic>)?['specialty']);
      return true;
    }
    DocumentSnapshot  documentSnapshot2 = await _collectionReference2.doc(id).get();
    if(documentSnapshot2.exists){
      SpHelper.isDoctor(false);
      SpHelper.saveId(id);
      return false;
    }

  }

  checkProfile(String id)async {
    bool type = await getTypeUser(id);
    var snapshot = await FirebaseFirestore.instance.collection(type ?'doctor' :'users').doc(id).get();

    if(await snapshot.data()?['image'] == null){
      return false;
    }
      return true;

  }
}



