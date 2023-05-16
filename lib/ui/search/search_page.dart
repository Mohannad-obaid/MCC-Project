// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  bool search = false;
 late Stream<QuerySnapshot<Object?>>? ss = Stream.empty();

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("Post");

  Stream<QuerySnapshot> searchByName(String searchQuery) async* {
    yield* userCollection.where(
      "allText",
      isGreaterThanOrEqualTo: searchQuery,
      isLessThanOrEqualTo: '$searchQuery\uf8ff',
     //whereIn: ["title", "body",],
    ).snapshots();
  }
  Stream<QuerySnapshot> searchBy(String searchQuery) async* {
    yield* userCollection.where(
      'body',
      isGreaterThanOrEqualTo: searchQuery,
      isLessThanOrEqualTo: '$searchQuery\uf8ff',
     //whereIn: ["title", "body",],
    ).snapshots();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups....",
                        hintStyle:
                        TextStyle(color: Colors.white, fontSize: 16)),
                    onSubmitted: (value) async{
                      if (value.isNotEmpty) {
                        searchController.text = value;
                        ss =   ( await searchByName(searchController.text).isEmpty ? searchBy(searchController.text) : searchByName(searchController.text));
                        print(ss.toString());
                        setState(()  {
                          searchController.text = value;
                          search = true;
                           ss ;
                           print(ss.toString());
                        });
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {

                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          search
              ? Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:  ss,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (!snapshot.hasData) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/postDetails',arguments: ds['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
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
                                    ds['title'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade400),
                                  ),

                                  Text(
                                    ds['body'],
                                    maxLines:2,
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),

                                  const SizedBox(height: 20,),

                                  Text(
                                    DateFormat('EEEE   d/MM/y').format(ds['createdAt'].toDate()),
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
                            ds['image']
                            ),
                            fit: BoxFit.cover,
                            )),
                            ),
                            ),
                            ],
                            ),
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: Colors.black, thickness: 1, height: 1, indent: 10, endIndent: 10,);
                },);
              },
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}


/*
Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    DocumentSnapshot ds = snapshot.data!.docs[index];
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                         ds['title'],
                                          style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade400),
                                        ),

                                        Text(
                                          ds['body'],
                                          maxLines:2,
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo),
                                        ),

                                        const SizedBox(height: 20,),

                                        Text(
                                          DateFormat('EEEE   d/MM/y').format(ds['createdAt'].toDate()),
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
                                                ds['image']
                                            ),
                                            fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ],
                            ),
 */

