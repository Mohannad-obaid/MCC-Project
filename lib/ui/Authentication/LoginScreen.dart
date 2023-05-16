import 'package:flutter/material.dart';
import 'package:palliative_care/Firebase/auth_firebase.dart';
import '../../Firebase/firestore.dart';
import '../../controller/sharedPreferences_Controller.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();

bool _showPassword2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String value) {
                    emailController.text = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'البريد الالكتروني',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'الرجاء ادخال البريد الالكتروني';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18.0,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _showPassword2,
                  onFieldSubmitted: (String value) {
                    passwordController.text = value;
                  },
                  textDirection: TextDirection.rtl,
                  decoration:  InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        _showPassword2 = !_showPassword2;
                      });
                    }, icon: Icon(_showPassword2 ? Icons.visibility : Icons.visibility_off,)),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'الرجاء ادخال كلمة المرور';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {

                      bool check = await  FbAuthController().signIn(
                        context,
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (check) {
                        String? id = FbAuthController().getUser?.uid;
                       bool checkProfile = await FirestoreController().checkProfile(id!);
                       print(SpHelper.getId());
                       if(!checkProfile){
                          Navigator.pushReplacementNamed(context, '/profile');
                        }else{
                          Navigator.pushReplacementNamed(context, '/mainScreen');
                       }

                      }

                    }
                  },
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ليس لديك حساب؟',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/who');
                      },
                      child: Text(
                        'تسجيل جديد',
                        style: TextStyle( color: Colors.green.shade400,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
