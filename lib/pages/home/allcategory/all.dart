import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});
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
            itemCount:20,// mockBookList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: Const.margin),
            itemBuilder: (context, index) {
              final book = mockBookList[index];
              return BookCard(book: book);
            },
          ),
        )
      ],
    );
  }
}
