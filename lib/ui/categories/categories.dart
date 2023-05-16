import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/catController.dart';
import '../../widgets/category_box.dart';

class Categories extends StatefulWidget {
   Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: categoryController.fetchCategory(),
        builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData  ) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {

          return Center(child: const CircularProgressIndicator());
          }

          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 15
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: (){
                        var ar = [snapshot.data!.docs[index].id,snapshot.data!.docs[index]['name']];
                        Navigator.pushNamed(context, '/sokariScreen', arguments: ar);
                    },
                    child: CategotyBox(
                      categoryName: snapshot.data!.docs[index]['name'],
                      imageName: snapshot.data!.docs[index]['image'],
                    )
                );
              },
            ),
          );
    }
    );
  }
}


