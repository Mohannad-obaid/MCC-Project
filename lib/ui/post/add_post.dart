import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/postModel.dart';
import '../controller/add_post_controller.dart';
import '../utils/helpers.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> with Helpers {
  PostController _postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
          future: _postController.getCurrentUser(),
          builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Text("حدث خطأ ما");
            }

            if (!snapshot.hasData) {
              return const Text("لا يوجد بيانات");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Image.network(
                          snapshot.data['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          snapshot.data['name'],
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          snapshot.data['specialty'],
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _postController.title,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'العنوان',
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _postController.subject,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'بم تفكر؟',
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _pickedFile != null
                          ? Image.file(
                        File(_pickedFile!.path),
                        fit: BoxFit.cover,
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await pickImage();
                              },
                              child: Image.asset(
                                'images/icons/picture.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            const Text('Category: '),
                            Center(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('category').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  List<DropdownMenuItem<String>> items = snapshot
                                      .data!.docs
                                      .map((document) =>
                                      DropdownMenuItem<String>(
                                        value: document.id,
                                        child: Text(document['name']),
                                      ))
                                      .toList();

                                  return DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 16,
                                    //  isExpanded: true,
                                    hint: const Text('Select Category'),
                                    value: _postController.selectedItem,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _postController.selectedItem = newValue!;
                                      });
                                    },
                                    items: items,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_postController.title.text.isNotEmpty && _postController.subject.text.isNotEmpty && _pickedFile != null) {
                                   uoloadImage();
                              } else {
                              showSnackBar(context: context, content: 'الرجاء التاكد من ادخال المعلومات كاملة', error: true);
                            }
                          },
                          child: const Text('Post'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );
          }



  XFile? _pickedFile;
  double? _indicatorValue = 0;
  ImagePicker imagePicker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref().child('images/');
  String? _imageUrl;
  File? file;




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
      storageRef.child("image_1200").putFile(file);
      PostModel postModell ;
      bool check;
      _imageUrl =  uploadTask.snapshot.ref.getDownloadURL().then((value) async => {
       postModell =  PostModel(
      id: '1',
      title: _postController.title.text,
      body: _postController.subject.text,
      userId:   FirebaseAuth.instance.currentUser!.uid,
      createdAt: Timestamp.now(),
      category: _postController.selectedItem!,
      image: value,

      ),
     check =   await _postController.createPost(postModell,),
        if(check){
          showSnackBar(
              context: context,
              content: 'تم اضافة المنشور بنجاح',
              error: false),
        }else{
          showSnackBar(
              context: context,
              content: 'حدث خطأ ما',
              error: true),
        },

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
