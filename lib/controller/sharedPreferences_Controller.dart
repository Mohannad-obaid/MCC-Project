import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  static late SharedPreferences  sharedPreferences;

  static initSp() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static saveName(String name) async {
    sharedPreferences.setString('name', name);
  }
  static String? getName(){
    return sharedPreferences.getString('name');
  }
  static deleteName() async{
    sharedPreferences.remove('name');
  }

  static saveId(String id) async {
    sharedPreferences.setString('id', id);
  }
  static String? getId(){
    return sharedPreferences.getString('id');
  }
  static deleteId() async{
    sharedPreferences.remove('id');
  }

  static saveImage(String image) async {
    sharedPreferences.setString('image', image);
  }
  static String? getImage(){
    return sharedPreferences.getString('image');
  }
  static deleteImage() async{
    sharedPreferences.remove('image');
  }

  static saveSpecialty(String specialty) async {
    sharedPreferences.setString('specialty', specialty);
  }
  static String? getSpecialty(){
    return sharedPreferences.getString('specialty');
  }
  static deleteSpecialty() async{
    sharedPreferences.remove('specialty');
  }

  static isDoctor(bool isDoctor) async {
    sharedPreferences.setBool('isDoctor', isDoctor);
  }

  static bool? getIsDoctor(){
    return sharedPreferences.getBool('isDoctor');
  }

  static deleteIsDoctor() async{
    sharedPreferences.remove('isDoctor');
  }

}