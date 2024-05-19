import 'package:ejazapp/data/models/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TagsExplore extends StatefulWidget {
  const TagsExplore({super.key});

  @override
  State<TagsExplore> createState() => _TagsExploreState();
}

class _TagsExploreState extends State<TagsExplore> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tags(
        alignment: WrapAlignment.start,
        spacing: 5,
        itemCount: tagslist.length,
        itemBuilder: (int index) {
          final _tags = tagslist[index];
          return Tooltip(
            message: _tags.nametagsEn,
            child: ItemTags(
              textStyle:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              color: _tags.colortag,
              splashColor: _tags.colortag,
              colorShowDuplicate: _tags.colortag,
              // textActiveColor: _tags.colortag,
              title: _tags.nametagsEn,
              index: index,
            ),
          );
        },
      ),
    );
  }
}
