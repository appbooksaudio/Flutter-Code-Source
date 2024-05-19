import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';

class SelfDevelopent extends StatelessWidget {
  final String category;
  const SelfDevelopent({super.key, required this.category});
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
              Book? book;
              if (mockBookList[index].categories.length > 0) {
                if (mockBookList[index].categories[0]['ct_Name'] ==
                    'Self Development') {
                  book = mockBookList[index];
                  return BookCard(book: book);
                } else {
                  return Text('');
                }
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

class ListFilterCategory extends StatelessWidget {
  final String category;
  const ListFilterCategory({super.key, required this.category});
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
              Book? book;
              if (mockBookList[index].categories.length > 0) {
                if (mockBookList[index].categories[0]['ct_Name'] == category) {
                  book = mockBookList[index];
                  return BookCard(book: book);
                } else {
                  return Text('');
                }
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}
