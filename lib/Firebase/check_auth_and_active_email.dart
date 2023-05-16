import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CheckAuth{
 // final FirebaseAuth  _firebaseAuth = FirebaseAuth.instance;

  Future<bool> checkActiveEmail(BuildContext context, {required UserCredential userCredential})async{
    if(userCredential.user!.emailVerified == false){
      userCredential.user!.sendEmailVerification();
      showSnackBar(context: context, content:'الرجاء تفعيل الايميل',error:false);
      return false;
    }

    return true;
  }

  void controllerErrorCode(BuildContext context,  FirebaseAuthException authException) {
    switch (authException.code) {
      case 'email-already-in-use':
        showSnackBar(context: context, content:'الايميل مستخدم ',error:true);
        break;

      case 'invalid-email':
        showSnackBar(context: context, content:'ايميل غير صالح',error:true);
        break;

      case 'operation-not-allowed':
        showSnackBar(context: context, content:'حدث خطا الرجاء اثناء عملية التسجيل',error:true);
        break;

      case 'weak-password':
        showSnackBar(context: context, content:'كلمة مرور ضعيفة',error:true);
        break;

      case 'user-not-found':
        showSnackBar(context: context, content:'لم يتم العثور على المستخدم',error:true);
        break;
      case 'wrong-password':
        showSnackBar(context: context, content:'كلمة المرور خطأ',error:true);
        break;

      case 'network-request-failed':
         showSnackBar(context: context, content:'الرجاء التاكد من الاتصال بالشبكة',error:true);
        break;

    default:
      showSnackBar(context: context, content:'حدث خطا',error:true);
    //  break;

    }
  }

  void showSnackBar({required BuildContext context, required String content, required bool error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: error ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }




}


