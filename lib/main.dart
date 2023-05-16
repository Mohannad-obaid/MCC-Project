import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:palliative_care/Firebase/auth_firebase.dart';
import 'package:palliative_care/ui/Authentication/LoginScreen.dart';
import 'package:palliative_care/ui/Authentication/signUp_1.dart';
import 'package:palliative_care/ui/Authentication/Who.dart';
import 'package:palliative_care/ui/post/add_post.dart';
import 'package:palliative_care/ui/categories/addCategory.dart';
import 'package:palliative_care/ui/categories/categories.dart';
import 'package:palliative_care/ui/Chat/chat.dart';
import 'package:palliative_care/ui/categories/getPostwithID.dart';
import 'package:palliative_care/ui/post/home.dart';
import 'package:palliative_care/ui/post/singlePost_page.dart';
import 'package:palliative_care/ui/setting/listSetting.dart';
import 'package:palliative_care/ui/mainScreen.dart';
import 'package:palliative_care/ui/setting/notification.dart';
import 'package:palliative_care/ui/setting/profile.dart';
import 'package:palliative_care/ui/setting/settings.dart';
import 'package:palliative_care/ui/test.dart';
import 'controller/sharedPreferences_Controller.dart';
import 'firebase_options.dart';
import 'ui/Authentication/signUp_2.dart';
import 'ui/search/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SpHelper.initSp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Palliative Care',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lora',
        primaryColor: const Color(0xFF66CA98),
        secondaryHeaderColor: Colors.green.shade400,
      ),
      themeMode: ThemeMode.dark,
      textDirection: TextDirection.rtl,


      routes: {
        '/who':(context) => const Who(),
        '/login':(context) => LoginScreen(),
        '/signup':(context) => SignUp(),
        '/signup2':(context) => SignUp_2(),
        '/home':(context) => const HomeScreen(),
        '/chat':(context) => const ChatScreen(),
        '/notifications':(context) => NotificationScreen(),
        '/categories':(context) =>  Categories(),
        '/add_post':(context) => const AddPost(),
        '/settings':(context) => const Settings(),
        '/profile':(context) =>  ProfilePage(),
        '/list':(context) =>  listPage(),
      //  '/':(context) => const MainScreen(),
        '/chatScreen':(context) => const ChatScreen(),
        '/sokariScreen':(context) => const categoryIDScreen(),
        '/mainScreen':(context) => const MainScreen(),
        '/test':(context) =>  Test(),
        '/addCategory':(context) =>  const AddCategory(),
        '/search':(context) =>  const SearchPage(),
        '/postDetails':(context) =>  const PostDetails(),
      },
      initialRoute: FbAuthController().isLogin? '/mainScreen' : '/login',

    );
  }
}
