import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Book? book;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  String RepComment = '';
  String DocId = "";
  FocusNode inputNode = FocusNode();

  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    book = Get.arguments as Book;
    initializeFlutterFire();
    super.initState();
    FirebaseFirestore.instance.disableNetwork();
    FirebaseFirestore.instance.enableNetwork();
  }

  void initializeFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          firebaseUser = user;
        });
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget commentChild() {
    final themeProv = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Stack(
      children: [
        ListView(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: OctoImage(
                  image: CachedNetworkImageProvider(
                    book!.imagePath,
                  ),
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    textAlign: TextAlign.center,
                    localprovider.localelang!.languageCode == 'en'
                        ? book!.bk_Name as String
                        : book!.bk_Name_Ar as String,
                    style: theme.textTheme.headlineLarge!
                        .copyWith(fontSize: 18, height: 1.2),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('comment/${book!.bk_ID}/ForumComment')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          localprovider.localelang!.languageCode == 'en'
                              ? 'There is no comment'
                              : 'لا يوجد تعليق',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Text(
                          'Loading',
                          style: TextStyle(color: Colors.white),
                        ));
                      }
                      return ListView(
                        children: [
                          Column(children: getListComment(snapshot)),
                          const SizedBox(
                            height: 300,
                          )
                        ],
                      );
                    })),
          ],
        )
      ],
    );
  }

  List<Widget> getListComment(AsyncSnapshot<QuerySnapshot> snapshot) {
    DateTime Date = DateTime.now();
    return snapshot.data!.docs
        .map((doc) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentTreeWidget<Comment, Comment>(
                  Comment(
                      id: doc.id,
                      avatar:
                          doc['image'] != null ? doc['image'] as String : '',
                      userName:
                          doc['name'] != null ? doc['name'] as String : '',
                      content: doc['text'] != null ? doc['text'] as String : '',
                      reply: doc['reply'] as List,
                      time: doc['timestamp'] != null
                          ? (doc['timestamp'] as Timestamp).toDate()
                          : Date), //
                  [
                    for (var i = 0; i < ((doc['reply'].length) as num); i++)
                      Comment(
                          id: doc.id,
                          avatar: doc['reply'][i]['image'] != null
                              ? doc['reply'][i]['image'] as String
                              : '',
                          userName: doc['reply'][i]['name'] != null
                              ? doc['reply'][i]['name'] as String
                              : '',
                          content: doc['reply'][i]['text'] != null
                              ? doc['reply'][i]['text'] as String
                              : '',
                          reply: doc['reply'] as List,
                          time: doc['reply'][i]['timestamp'] != null
                              ? (doc['reply'][i]['timestamp'] as Timestamp)
                                  .toDate()
                              : Date),
                  ],
                  treeThemeData: const TreeThemeData(
                      lineColor: Colors.transparent, lineWidth: 3),
                  avatarRoot: (context, data) => PreferredSize(
                    preferredSize: Size.fromRadius(18),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        data.avatar!,
                      ),
                    ),
                  ),
                  avatarChild: (context, data) => PreferredSize(
                    preferredSize: Size.fromRadius(12),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        data.avatar!,
                      ),
                    ),
                  ),
                  contentChild: (context, data) {
                    final themeProv = Provider.of<ThemeProvider>(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: themeProv.isDarkTheme!
                                  ? Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${data.userName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: themeProv.isDarkTheme!
                                                ? Colors.white
                                                : ColorDark.background),
                                  ),
                                  Text(
                                    '${DateFormat('dd-MMM-yyy – kk:mm').format(data.time!)}', //Date.toString().split(' ')[0],
                                    style: TextStyle(
                                        color: Colors.blue[700], fontSize: 10),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: themeProv.isDarkTheme!
                                            ? Colors.white
                                            : ColorDark.background),
                              ),
                            ],
                          ),
                        ),
                        DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: ColorDark.primary,
                                  fontWeight: FontWeight.bold),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                // TextButton(
                                //   style: TextButton.styleFrom(
                                //     textStyle: const TextStyle(
                                //       fontSize: 12,
                                //     ),
                                //   ),
                                //   onPressed: () {
                                //     setState(() {
                                //       RepComment = "replay";
                                //       DocId = data.id as String;
                                //     });
                                //     FocusScope.of(context)
                                //         .requestFocus(inputNode);
                                //   },
                                //   child: Row(
                                //     children: [
                                //       const Text(
                                //         'Reply',
                                //         style: TextStyle(
                                //             color: ColorLight.primary),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  contentRoot: (context, data) {
                    final themeProv = Provider.of<ThemeProvider>(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              color: themeProv.isDarkTheme!
                                  ? Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${data.userName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: themeProv.isDarkTheme!
                                                ? Colors.white
                                                : ColorDark.background),
                                  ),
                                  Text(
                                    '${DateFormat('dd-MMM-yyy – kk:mm').format(data.time!)}', //.toString().split(' ')[0]}',
                                    style: TextStyle(color: Colors.blue[700]),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${data.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: themeProv.isDarkTheme!
                                            ? Colors.white
                                            : ColorDark.background),
                              ),
                            ],
                          ),
                        ),
                        DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: ColorLight.primary,
                                  fontWeight: FontWeight.bold),
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                //  Padding(
                                //    padding: const EdgeInsets.only(top:6.0),
                                //    child: Text('Like',
                                //                 style: TextStyle(
                                //                   fontSize: 13,
                                //                   color: ColorLight.primary,
                                //                     fontWeight: FontWeight.bold)),
                                //  ),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      RepComment = "replay";
                                      DocId = data.id as String;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(inputNode);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.comment_outlined,
                                        size: 20.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        'Reply',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: ColorLight.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Scaffold(
        body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
          // A flexible app bar
          SliverAppBar(
            backgroundColor: theme.colorScheme.background,
            foregroundColor: themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
            actions: [
              // SizedBox(
              //     width: 50,
              //     height: 50,
              //     child: FittedBox(
              //       child: FloatingActionButton(
              //         onPressed: () {
              //           Get.toNamed(Routes.comment);
              //         },
              //         backgroundColor: Colors.blue,
              //         elevation: 0,
              //         child: const Icon(
              //           Icons.chat,
              //           color: Colors.white,
              //           size: 25,
              //         ),
              //       ),
              //     )),
            ],
          ),
          SliverFillRemaining(
            child: Container(
              child: CommentBox(
                userImage: CommentBox.commentImageParser(
                    imageURLorPath: firebaseUser != null
                        ? (firebaseUser!.photoURL ?? Const.avatar1)
                        : Const.avatar1),
                child: commentChild(),
                labelText: localprovider.localelang!.languageCode == 'en'
                    ? 'Write a comment...'
                    : 'أكتب تعليقا...',
                errorText: localprovider.localelang!.languageCode == 'en'
                    ? 'Comment cannot be blank'
                    : 'لا يمكن أن يكون التعليق فارغاً',
                focusNode: inputNode,
                withBorder: false,
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    String? comID = book!.bk_ID;
                    if (RepComment == '') {
                      communityPageComment(commentController.text, comID!);
                    } else {
                      replyToComment(commentController.text, comID!, DocId);
                    }
                    setState(() {});
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print('Not validated');
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.transparent,
                textColor: themeProv.isDarkTheme!
                    ? Colors.white
                    : ColorDark.background,
                sendWidget: Icon(Icons.send_sharp,
                    size: 30,
                    color: themeProv.isDarkTheme!
                        ? Colors.white
                        : ColorDark.background),
              ),
            ),
          )
        ]));
  }

//********************* posting or commenting wih firebase ***********/

  communityPageComment(String comment, String comId) async {
    String displayname = mybox!.get('name');
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.displayName == null) {
        await _auth.currentUser!.updateDisplayName(displayname);
      }
      if (_auth.currentUser!.photoURL == null) {
        await _auth.currentUser!.updatePhotoURL(
            "https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/apple%2Favatar.jpeg?alt=media&token=0cd72d6c-bfc9-4208-83c2-78a69d44f7b8");
      }
    }
    FirebaseFirestore.instance
        .collection('comment')
        .doc(comId)
        .collection('ForumComment')
        .doc()
        .set({
      'name':
          _auth.currentUser != null ? _auth.currentUser!.displayName : "Apple",
      'image': firebaseUser != null
          ? (firebaseUser!.photoURL != null ? firebaseUser!.photoURL :"https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/apple%2Favatar.jpeg?alt=media&token=0cd72d6c-bfc9-4208-83c2-78a69d44f7b8")
          : "https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/apple%2Favatar.jpeg?alt=media&token=0cd72d6c-bfc9-4208-83c2-78a69d44f7b8",
      'timestamp': FieldValue.serverTimestamp(),
      'text': comment,
      'reply':
          [] // here will be where all the replies of this post will be in Map...
    });
  }

//********************* replyToComment wih firebase ***********/
  replyToComment(String comment, String comId, String DocId) async {
    String displayname = mybox!.get('name');
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.displayName == null) {
        await _auth.currentUser!.updateDisplayName(displayname);
      }
      if (_auth.currentUser!.photoURL == null) {
        await _auth.currentUser!.updatePhotoURL(
            "https://cdn-icons-png.flaticon.com/512/6386/6386976.png");
      }
    }
    Map data = {
     'name':
          _auth.currentUser != null ? _auth.currentUser!.displayName : "Apple",
      'image': firebaseUser != null
          ? (firebaseUser!.photoURL != null ? firebaseUser!.photoURL :"https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/apple%2Favatar.jpeg?alt=media&token=0cd72d6c-bfc9-4208-83c2-78a69d44f7b8")
          : "https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/apple%2Favatar.jpeg?alt=media&token=0cd72d6c-bfc9-4208-83c2-78a69d44f7b8",
     
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'text': comment,
      'reply': []
    };

    FirebaseFirestore.instance
        .collection('comment')
        .doc(comId)
        .collection('ForumComment')
        .doc(DocId)
        .update({
      'reply': FieldValue.arrayUnion([data])
    });
    setState(() {
      RepComment = "";
    });
  }

  ////*************** *********************/
}
