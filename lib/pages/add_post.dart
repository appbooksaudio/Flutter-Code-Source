import 'dart:io';
import 'dart:typed_data';

import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/pages/addpost_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/theme_provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool islooding = true;
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  final List<String> typeFiles = [];
   List<int> _selectedIndexList = [];
  bool selectionMode = false;
  File? _file;
  int currentPage = 0;
  int? lastPage;
  var typeFile ="";
  @override
  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.all);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            typeFiles.add("image");
            _file = path[0];
            typeFile=typeFiles[0];
            print("image");
          }
        }else if(asset.type == AssetType.video){
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            typeFiles.add("video");
            _file = path[0];
            typeFile=typeFiles[0];
             print("video");
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
             
              if (snapshot.connectionState == ConnectionState.done)
             
                return 
                   Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          )
                        ),
                      ],
                    ),
                 
                );
             
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
         islooding = false;
        currentPage++;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNewMedia();
  }

  int indexx = 0;

  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  themeProv.isDarkTheme!
                                    ? ColorDark.background
                                    : Colors.white,
        elevation: 0,
        title:  Text(
         AppLocalizations.of(context)!.newpost,
          style: TextStyle(color:  themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background,),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPostTextScreen(_file!,typeFile),
                  ));
                },
                child: Text(
                  AppLocalizations.of(context)!.next,
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: islooding
              ? Center(
                  child: CircularProgressIndicator(
                  color: themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background,
                ))
              :
         SizedBox(
           height: MediaQuery.of(context).size.height,
           child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
             child: Column(
               children: [
                 SizedBox(
                   height: MediaQuery.of(context).size.height * 0.4,
                   child: GridView.builder(
                     physics: NeverScrollableScrollPhysics(),
                     itemCount: _mediaList.isEmpty ? _mediaList.length : 1,
                     gridDelegate:
                         const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 1,
                       mainAxisSpacing: 1,
                       crossAxisSpacing: 1,
                     ),
                     itemBuilder: (context, index) {
                       return _mediaList[indexx];
                     },
                   ),
                 ),
                   Container(
                     width: double.infinity,
                     height: 40,
                     color: Colors.white,
                     child: Row(
                       children: [
                         SizedBox(width: 10),
                         Text(
                           'Recent',
                           style: TextStyle(
                               fontSize: 15, fontWeight: FontWeight.w600,color: Colors.black),
                         ),
                       ],
                     ),
                   ),
                   Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                     child: GridView.builder(
                       physics: ScrollPhysics(),
                       shrinkWrap: true,
                       itemCount: _mediaList.length,
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                         mainAxisSpacing: 1,
                         crossAxisSpacing: 2,
                       ),
                       itemBuilder: (context, index) {
                         return GestureDetector(
                           onTap: () {
                             setState(() {
                               indexx = index;
                               _file = path[index];
                               typeFile = typeFiles[index];
                             });
                           },
                           child: _mediaList[index],
                         );
                       },
                     ),
                   ),
               ],
             ),
           ),
         ),
      ),
    );
  }
}