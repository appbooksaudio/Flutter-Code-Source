import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/collections.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';

class MyGroupes extends StatelessWidget {
  const MyGroupes({super.key});
  @override
  Widget build(BuildContext context) {
    List<Collections> collectionActive = [];
    for (var i = 0; i < collectionList.length; i++) {
      if (collectionList[i].bc_Active != false)
        collectionActive.add(collectionList[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 270,
          child: ListView.builder(
            itemCount: collectionActive.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: Const.margin),
            itemBuilder: (context, index) {
              final collection = collectionActive[index];
              return GroupBookVerticalCard(collection: collection);
            },
          ),
        )
      ],
    );
  }
}

class Populardiscussions extends StatelessWidget {
  const Populardiscussions({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 270,
          child: ListView.builder(
            itemCount: mockBookList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: Const.margin),
            itemBuilder: (context, index) {
              final book = mockBookList[index];
              return PopularVerticalCard(book: book);
            },
          ),
        )
      ],
    );
  }
}
