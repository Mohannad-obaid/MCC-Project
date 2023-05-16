import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/catController.dart';
import '../../utils/helpers.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> with Helpers{

  CategoryController categoryController = Get.put(CategoryController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = TextEditingController().text;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  TextEditingController nameController = TextEditingController();

  XFile? _pickedFile;
  double? _indicatorValue = 0;
  ImagePicker imagePicker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref().child('images/');
  String? _imageUrl;
  File? file;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
               SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: _pickedFile == null
                          ?  const Icon(
                        Icons.person,
                      )
                          : Image.file(
                        File(_pickedFile!.path),
                        fit: BoxFit.cover,
                      ),
                    ),),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: IconButton(
                        onPressed: () async{
                          await pickImage();

                        },
                        icon: const Icon(Icons.camera_alt),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.3),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text('اضافة قسم جديد',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'اسم القسم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء ادخال اسم القسم';
                    }
                  },
                  onFieldSubmitted: (value) {
                    nameController.text = value;

                  },
                ),
              ),
              const SizedBox(height: 10,),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: ()async{
                  if(formKey.currentState!.validate() && _pickedFile != null && nameController.text.isNotEmpty){
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ) {
                      uoloadImage();
                      Get.back();
                    } else {
                      Get.snackbar('خطأ', 'تأكد من اتصالك بالانترنت');
                      Get.back();

                    }

                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('اضافة',style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> pickImage() async {
    try {
      _pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (_pickedFile != null) {
        setState(() {
          _pickedFile = _pickedFile;
        });
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          file = File(result.files.single.path!);
        });
      }else{
        showSnackBar(
            context: context,
            content: 'No internet connection',
            error: true);



      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void uploadImage({required File file, required void Function(bool state, TaskState status, String message)eventHandler}) {
    try {
      UploadTask uploadTask =
      storageRef.child("image_${DateTime.now}").putFile(file);
      _imageUrl = uploadTask.snapshot.ref.getDownloadURL().then((value) => {
        categoryController.addCategory(nameController.text, value),
        print(value),
      } ).toString();
      setState(() async{
        _imageUrl = _imageUrl;

        //  await  controller.updateImageProfile(_imageUrl!);
      });
      uploadTask.snapshotEvents.listen((event) {
        if (event.state == TaskState.running) {
          print('running');
          eventHandler(false, event.state, '');
        } else if (event.state == TaskState.success) {
          print('success');
          eventHandler(true, event.state, 'Upload Image Successfully');
        } else if (event.state == TaskState.error) {
          print('error');
          eventHandler(false, event.state, 'Upload Image Failed');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void uoloadImage() async {
    if (_indicatorValue != null) {
      // await  pickImage();
      try {
        uploadImage(
            file: File(_pickedFile!.path),
            eventHandler: (status, TaskState state, message) {
              if (status) {
                //upload successfully
                changeIndicatorValue(1);
                Get.showSnackbar(const GetSnackBar(
                  message: 'Pick image to uploada!',
                  duration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                ));
              } else if (state == TaskState.running) {
                //uploading
              } else {
                changeIndicatorValue(0);
                showSnackBar(context: context, content: message, error: true);
              }
            });
      } catch (e) {
        showSnackBar(
            context: context, content: 'Pick image to uploada!', error: true);
      }
    } else {
      showSnackBar(
          context: context, content: 'Pick image to uploada!', error: true);
    }
  }

  void uoloadFile() async {
    if (_indicatorValue != null) {
      // await  pickImage();
      try {
        uploadImage(
            file: file!,
            eventHandler: (status, TaskState state, message) {
              if (status) {
                //upload successfully
                changeIndicatorValue(1);
                showSnackBar(context: context, content: message, error: false);
              } else if (state == TaskState.running) {
                //uploading
              } else {
                changeIndicatorValue(0);
                showSnackBar(context: context, content: message, error: true);
              }
            });
      } catch (e) {
        showSnackBar(context: context, content: 'Pick image to uploada!', error: true);
      }
    } else {
      showSnackBar(context: context, content: 'Pick image to uploada!', error: true);
    }
  }

  void changeIndicatorValue(double? value) {
    setState(() {
      _indicatorValue = value;
    });
  }
}
