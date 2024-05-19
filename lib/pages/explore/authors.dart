import 'package:ejazapp/data/models/authors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';

class AuthorsExplore extends StatefulWidget {
  const AuthorsExplore({super.key});

  @override
  State<AuthorsExplore> createState() => _AuthorsExploreState();
}

class _AuthorsExploreState extends State<AuthorsExplore> {
  @override
  Widget build(BuildContext context) {
    List<Authors> listauthors = [];
    for (int i = 0; i < mockAuthors.length; i++) {
      if (mockAuthors[i].at_Active == true) {
        listauthors.add(mockAuthors[i]);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: 23,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: Const.margin),
            itemBuilder: (context, index) {
              final authors = listauthors[index];
              return AuthorsCard(authors: authors);
            },
          ),
        )
      ],
    );
  }
}
