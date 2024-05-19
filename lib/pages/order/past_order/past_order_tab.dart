import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/data/models/order.dart';
import 'package:ejazapp/widgets/order_book_card.dart';

class PastOrderTab extends StatelessWidget {
  const PastOrderTab({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return (mockPastOrderList.isEmpty)
        ? Center(
            child: Column(
              children: [
                Image.asset(
                  Const.empty,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Text(
                  AppLocalizations.of(context)!.ouch_hungry,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!
                      .seems_like_you_have_not_have_an_in_progress_order_yet,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: mockPastOrderList.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              final order = mockPastOrderList[index];
              return OrderBookCard(order: order);
            },
          );
  }
}
