import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palliative_care/controller/sharedPreferences_Controller.dart';
import '../../controller/profileController.dart';
import '../../utils/helpers.dart';


class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with Helpers {
  ProfileController controller = Get.put(ProfileController());

  XFile? _pickedFile;
  double? _indicatorValue = 0;
  ImagePicker imagePicker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref().child('images/');
  String? _imageUrl;
  File? file;



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الصفحة الشخصية',
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),

        backgroundColor: Colors.green.shade400,
        centerTitle: true
         ,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: controller.getPostAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||  snapshot.connectionState == ConnectionState.none)  {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
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
                            ?Image.network(
                          snapshot.data!['image'],
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          File(_pickedFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: IconButton(
                          onPressed: () async{
                          await pickImage();
                            final connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                              uoloadImage();
                            } else {
                              showSnackBar(context: context, content: 'No internet connection', error: true);
                            }
                          },
                          icon: const Icon(Icons.camera_alt),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.3),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  snapshot.data!['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
               Text(
                 SpHelper.getIsDoctor()! ? snapshot.data!['specialty'] : snapshot.data!['interest'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ) ,
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                  ),
                  onPressed: () {},
                  child: Text(
                    'مراسلة الطبيب',
                    style: GoogleFonts.aBeeZee(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.email,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Text(
                    ':  ${snapshot.data!['email']}',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    size: 30,
                    color: Colors.red,
                  ),
                  title: Text(
                    ':  ${snapshot.data!['address']}',
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    size: 30,
                    color: Colors.green.shade400,
                  ),
                  title: Text(':  ${snapshot.data!['phone']}',
                      style: GoogleFonts.aBeeZee(fontSize: 20)),
                ),
              ],
            );
          }
        },

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
      storageRef.child("image_${controller.idUserLogin}").putFile(file);
      _imageUrl = uploadTask.snapshot.ref.getDownloadURL().then((value) => {
        controller.updateImageProfile(value),
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
