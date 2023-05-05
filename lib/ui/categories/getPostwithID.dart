import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/get_posts_controller.dart';

class SokariScreen extends StatefulWidget {
  const SokariScreen({Key? key}) : super(key: key);

  @override
  State<SokariScreen> createState() => _SokariScreenState();
}
class _SokariScreenState extends State<SokariScreen> {


  @override
  Widget build(BuildContext context) {
   // late String? idCategory =  ModalRoute.of(context)?.settings.arguments.toString();
    List<dynamic> _data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    print(_data[0]);

    return Scaffold(
      appBar:
        AppBar(
          title:  Text(_data[1],style: TextStyle(fontSize: 30,color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.green.shade400,
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: GetPostsController().getAllPosts(_data[0]),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  print(DateFormat.yMMMMEEEEd().add_jms().format(snapshot.data!.docs[index]['createdAt'].toDate()),);
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (!snapshot.hasData  ) {
                    return const Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {

                    return const Center(child: CircularProgressIndicator());
                  }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [

                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['title'],
                                          style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade400),
                                        ),

                                        Text(
                                          snapshot.data!.docs[index]['body'],
                                          maxLines:2,
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo),
                                        ),

                                        const SizedBox(height: 20,),

                                        Text(
                                          DateFormat('EEEE   d/MM/y').format(snapshot.data!.docs[index]['createdAt'].toDate()),
                                          style: GoogleFonts.roboto(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 200,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data!.docs[index]['image']
                                            ),
                                            fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )
                      ],
                    );

                },
              );
            },
          ),
        ));
  }
}
