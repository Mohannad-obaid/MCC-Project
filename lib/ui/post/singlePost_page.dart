import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/commentModel.dart';
import '../../Model/likeModel.dart';
import '../../Model/postModel.dart';
import '../../controller/homeController.dart';
import '../../controller/sharedPreferences_Controller.dart';
import '../../widgets/commentForm.dart';
import '../../widgets/readMore.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostModel>(
        future: controller.getSinglePost(),
        builder: (context, document) {
          if (document.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            PostModel post = document.data!;
           controller.getAllCommentsSinglePost(post.id);
            return  Scaffold(
            body: SingleChildScrollView(
                child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('doctor').doc(post.userId).get(),
                                builder: (context, snapshot2) {
                                  if (snapshot2.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return ListTile(
                                      minLeadingWidth: 10,
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot2.data!['image']),
                                      ),
                                      title: Text(
                                        snapshot2.data!['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        snapshot2.data!['specialty'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.more_vert),
                                      ),
                                    );
                                  }
                                }),
                            const SizedBox(height: 10),
                            Text(
                              post.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            ReadMoreText(
                              text: post.body,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      post.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {


                                      },
                                      icon:  const Icon(
                                          Icons.favorite,
                                          color:  Colors.grey,
                                        )

                                    ),

                                    Text(
                                      //snapshot.data!.size.toString(),
                                      "",
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                      const Icon(Icons.comment),
                                    ),
                                    Text(
                                      "",
                                      style: const TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.share),
                                    ),
                                  ],
                                ),
                              ],
                            ),


                            const SizedBox(height: 10),
                            CommentForm(
                              onSubmit: (comment) async {
                                CommentModel commentModel = CommentModel(
                                    postId: post.id,
                                    userId:SpHelper.getId()!,
                                    comment: comment,
                                    timestamp: Timestamp.now()

                                );
                                await  controller.addComment(commentModel);
                                controller.update();
                              },
                            ),

                            Obx(() => SizedBox(
                                    width: double.infinity,
                                    child: ListView.builder(
                                      itemCount: controller.commentsListSingelPost.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index2) {

                                        return Obx(() => controller.commentsListSingelPost.isEmpty || controller.userListSingelPost.isEmpty
                                            ?  Container()
                                            : ListTile(
                                                leading: CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage: NetworkImage(
                                                   controller.userListSingelPost[index2].image
                                                  ),
                                                ),
                                                title: Text(
                                                    controller.userListSingelPost[index2].name),
                                                subtitle: Text(
                                                    controller.commentsListSingelPost[index2]
                                                        .comment),
                                              ));
                                      },
                                    ),
                                  )),




                          ],
                        ),
                      ),
                    ],
                  )
          ),
          );
          }
        });
  }
}

/*
ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context,index){
                  PostModel post = controller.posts[index];
                  controller.getPostAuth(id: post.userId);


                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => controller.user.isEmpty ? const Center(child: CircularProgressIndicator())
                                :
                            ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    controller.user[index].image),
                              ),
                              title: Text(
                                controller.user[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                controller.user[index].interest,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Container(
                                margin: const EdgeInsets.only(right: 50),
                                child: IconButton(
                                  onPressed: () {
                                    /// TO DO
                                  },
                                  icon: const Icon(Icons.more_horiz),
                                ),
                              ),

                            ),),
                            const SizedBox(height: 10),
                            ReadMoreText(
                                text:
                                post.body
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image:  DecorationImage(
                                  image: NetworkImage(
                                    post.image,),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    LikeModel like = LikeModel(
                                      postId: post.id,
                                      userId: controller.user[index].id,
                                    );

                                    if(controller.liked == false) {
                                      controller.liked = !controller.liked;
                                      controller.addLikePost(like);
                                      controller.likeCount++;

                                    }else{
                                      controller.liked = !controller.liked;
                                      controller.removeLike(like);
                                      controller.likeCount--;
                                    }
                                  },
                                  icon: Icon(
                                    controller.liked ? Icons.favorite : Icons.favorite_border,
                                    color: controller.liked ? Colors.red : null,
                                  ),
                                ),

                                // ignore: unrelated_type_equality_checks
                                Obx(() =>   controller.likeCounts != 0.obs
                                    ? TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:  Text('Likes'),
                                            content: SizedBox(
                                              height: 200,
                                              child: ListView.builder(
                                                  itemCount: controller.likeCount,
                                                  itemBuilder: (context, index) {
                                                    return const ListTile(
                                                      title: Text('mohannad'),
                                                    );
                                                  }),
                                            ),
                                          );
                                        });
                                  },

                                  child: Text(
                                    '${controller.likeCount != 0
                                        ? controller.likeCount
                                        : ''} '
                                        '${controller.likeCount != 0 ? 'اعجاب' : ' '}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : const SizedBox(width: 7),
                                ),

                                //  const SizedBox(width: 7),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/post');
                                  },
                                  icon: const Icon(Icons.comment),
                                ),

                                  const Text(
                                        ''
                               //  ' ${comments.isNotEmpty ? 'تعليق'  : ' '}'
                               //      ' ${comments.isNotEmpty ? comments.length : ''}'
                                  ,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,

                                ),
                                  ),
                                const SizedBox(width: 7),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            CommentForm(
                              onSubmit: (comment) {
                                CommentModel commentModel = CommentModel(
                                  postId: post.id,
                                  userId: controller.user[index].id,
                                  comment: comment,
                                  timestamp: Timestamp.now(),
                                );
                                controller.addComment(commentModel);

                              },
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: 2,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {

                                  return  ListTile(
                                    leading: const CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                        'https://img.freepik.com/premium-vector/doctor-icon-avatar-white_136162-58.jpg?w=2000',
                                      ),
                                    ),
                                    title: Text('Dr. Jane Smith'),
                                    subtitle: Text(
                                       ' comments[index].comment'
                                      // _comments[index]
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/post');
                                    },
                                    child: const Text('المزيد من التعليقات')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
            )
 */
/*\
  SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: controller..length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading:  CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                       // 'https://img.freepik.com/premium-vector/doctor-icon-avatar-white_136162-58.jpg?w=2000',
                                         controller.user[index].image
                                      ),
                                    ),
                                    title: Text( controller.user[index].name),
                                    subtitle: Text(' comments[index].comment'
                                        // _comments[index]
                                        ),
                                  );
                                },
                              ),
                            ),
 */
