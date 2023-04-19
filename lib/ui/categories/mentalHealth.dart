import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palliative_care/ui/categories/specific_post.dart';
class MentalHealth extends StatefulWidget {
  const MentalHealth({Key? key}) : super(key: key);

  @override
  State<MentalHealth> createState() => _MentalHealthState();
}

class _MentalHealthState extends State<MentalHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصحة النفسية',style: GoogleFonts.aBeeZee(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
      ),
      body:  ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                onTap: () {
                  Get.to(SpecificPost());
                },
                title: Text(
                  'عنوان المقالة',
                  style: GoogleFonts.aBeeZee(fontSize: 20, color: Colors.white),
                ),
                subtitle: Text(
                  'الموضوع',
                  style: GoogleFonts.aBeeZee(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}