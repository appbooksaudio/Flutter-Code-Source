import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejazapp/data/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<Usermodel> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
       if(user.data() != null){
final snapuser = user.data()!;
      return Usermodel(
          _auth.currentUser!.displayName as String,
          _auth.currentUser!.displayName as String,
          _auth.currentUser!.photoURL as String ,
          _auth.currentUser!.email as String);
       } else{

      return Usermodel(
          _auth.currentUser!.displayName as String,
          _auth.currentUser!.displayName as String,
          _auth.currentUser!.photoURL !=null ? _auth.currentUser!.photoURL as String : 'null' ,
          _auth.currentUser!.email as String);
       }   
      
    } on FirebaseException catch (e) {
      throw (e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required String location,
    required String typeFile,
    required String duration,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    var previeImage="";
    if(typeFile =="video"){
    previeImage="https://cdn.shopify.com/s/files/1/0747/0491/2661/files/profile.png?v=1691401880";
    }else{
      previeImage=postImage;
    }
   DocumentSnapshot<Map<String, dynamic>> data_storis =await _firebaseFirestore.collection('ejaz_stories_db').doc(_auth.currentUser!.uid).get();
    Map<String, dynamic>? docData = data_storis.data();
   print(docData);
   if(docData !=null){
     List<dynamic> fileStories =
        (docData["file"] as List<dynamic>)
            .map((file) => Map<String, dynamic>.from(file))
            .toList();

    fileStories.add({'fileTitle':{'en':caption},'filetype':typeFile,'duration':duration,'url':{'en':postImage}});    
    await _firebaseFirestore.collection('ejaz_stories_db').doc(_auth.currentUser!.uid).set({
      'file': fileStories,
      'username': user.username,
      // ignore: unnecessary_null_comparison
      'previewImage': user.profile != 'null' ? user.profile :previeImage,
      'previewTitle': {'en':user.username.split(' ')[0]},
      'location': location,
      'email': user.email,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'date': data,
      
    });

   }else{
    await _firebaseFirestore.collection('ejaz_stories_db').doc(_auth.currentUser!.uid).set({
      'file': [{'fileTitle':{'en':caption},'filetype':typeFile,'duration':duration,'url':{'en':postImage}},],
      'username': user.username,
      // ignore: unnecessary_null_comparison
      'previewImage': user.profile != 'null' ? user.profile :previeImage,
      'previewTitle': {'en':user.username.split(' ')[0]},
      'location': location,
      'email': user.email,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'date': data,
      
    });
   }
    return true;
  }

  Future<bool> CreatReels({
    required String video,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('reels').doc(uid).set({
      'reelsvideo': video,
      'username': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data
    });
    return true;
  }

  Future<bool> Comments({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    var uid = Uuid().v4();
    Usermodel user = await getUser();
    await _firebaseFirestore
        .collection(type)
        .doc(uidd)
        .collection('comments')
        .doc(uid)
        .set({
      'comment': comment,
      'username': user.username,
      'profileImage': user.profile,
      'CommentUid': uid,
    });
    return true;
  }
}