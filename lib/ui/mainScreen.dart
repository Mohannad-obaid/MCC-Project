
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palliative_care/ui/post/add_post.dart';
import 'package:palliative_care/ui/post/home.dart';
import '../controller/sharedPreferences_Controller.dart';
import '../utils/helpers.dart';
import 'Chat/chatAll.dart';
import 'categories/categories.dart';
import 'setting/listSetting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with Helpers {
   int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<String> _title = ['الرئيسية', 'الاقسام', 'المحادثات', 'الاعدادات','اضافة مقالة'];
  List pageUser = [
    const HomeScreen(),
    Categories(),
    UserChatScreen(uid: '51ds6f51ds6f51dsf', name: 'Mohannad',),
    listPage(),

  ];
  List pageDoctor = [
    const HomeScreen(),
    Categories(),
    UserChatScreen(uid: '51ds6f51ds6f51dsf', name: 'Mohannad',),
    listPage(),
    const AddPost(),
  ];

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
    appBar:  AppBar(
        title: Text(_title[_selectedIndex],style: GoogleFonts.aBeeZee(color: Colors.white),),
        backgroundColor: Colors.green.shade400,
        centerTitle: true,
      actions: [
        SpHelper.getIsDoctor()! ?  _selectedIndex == 1 ?  IconButton(
          onPressed: (){
            Get.toNamed('/addCategory');
          }, icon: const Icon(Icons.add_box_outlined),) : const SizedBox() : const SizedBox(),


        _selectedIndex == 0 ?  IconButton(
          onPressed: (){
            Get.toNamed('/search');
          }, icon: const Icon(Icons.search_rounded),) : const SizedBox(),
      ],


      ),

      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children:   [

           if(SpHelper.getIsDoctor()!)
            ...pageDoctor
          else
            ...pageUser

        ],
      ),



      bottomNavigationBar:
      SpHelper.getIsDoctor()! ? BottomNavigationBar(
          items:  <BottomNavigationBarItem>
          [
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 0 ? AssetImage('images/icons/img_8.png') : AssetImage('images/icons/img.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الرئيسية',


            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 1 ? AssetImage('images/icons/img_6.png') : AssetImage('images/icons/img_1.png'),

                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الاقسام',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 2 ? AssetImage('images/icons/img_7.png') : AssetImage('images/icons/img_2.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: ' المحادثات',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 3 ? AssetImage('images/icons/img_10.png') : AssetImage('images/icons/img_9.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الاعدادات',
            ),
            BottomNavigationBarItem(
              icon: Icon( Icons.add_circle_outline_outlined,
                color: _selectedIndex == 4 ? Colors.green.shade400 : Colors.grey.shade400,
                size: 25.0,),
              label: 'اضافة مقالة',
            ),
          ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade400,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });
        }
      )
          : BottomNavigationBar(
          items:  <BottomNavigationBarItem>
          [
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 0 ? AssetImage('images/icons/img_8.png') : AssetImage('images/icons/img.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الرئيسية',


            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 1 ? AssetImage('images/icons/img_6.png') : AssetImage('images/icons/img_1.png'),

                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الاقسام',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 2 ? AssetImage('images/icons/img_7.png') : AssetImage('images/icons/img_2.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: ' المحادثات',
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: _selectedIndex == 3 ? AssetImage('images/icons/img_10.png') : AssetImage('images/icons/img_9.png'),
                width: 25.0,
                height: 25.0,
                fit: BoxFit.contain,
              ),
              label: 'الاعدادات',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green.shade400,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          }
      ),

    );
  }




}
