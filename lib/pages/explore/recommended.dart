import 'package:ejazapp/data/models/category.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';

class RecommendedExplore extends StatefulWidget {
  const RecommendedExplore({super.key});

  @override
  State<RecommendedExplore> createState() => _RecommendedExploreState();
}

class _RecommendedExploreState extends State<RecommendedExplore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: ListView.builder(
            itemCount: CategoryList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: Const.margin),
            itemBuilder: (context, index) {
              final category = CategoryList[index];
              return BookCardCategory(category: category);
            },
          ),
        )
      ],
    );
  }
}
