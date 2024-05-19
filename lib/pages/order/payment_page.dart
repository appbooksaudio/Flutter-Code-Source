import 'package:ejazapp/data/models/order.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { cod, paypal }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _paymentMethod = PaymentMethod.cod;
  Order? order;

  @override
  void initState() {
    super.initState();
    order = Get.arguments as Order;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: Const.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  iconSize: 18,
                  onPressed: () => Get.back<dynamic>(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.payment_methods,
              style: theme.textTheme.headlineLarge,
            ),
            Text(
              AppLocalizations.of(context)!.choose_your_payment_method,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(Const.cod, height: 50),
              ),
              contentPadding: EdgeInsets.zero,
              leading: Radio<PaymentMethod>(
                value: PaymentMethod.cod,
                activeColor: theme.primaryColor,
                groupValue: _paymentMethod,
                onChanged: (PaymentMethod? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                //child: Image.asset(Const.paypal, height: 50),
              ),
              contentPadding: EdgeInsets.zero,
              leading: Radio(
                value: PaymentMethod.paypal,
                activeColor: theme.primaryColor,
                groupValue: _paymentMethod,
                onChanged: (PaymentMethod? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.detail_transaction,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  buildCheckoutDetail(
                    theme,
                    title: order!.book!.bk_Name!,
                    trailing: order!.book!.quantity * order!.book!.price!,
                  ),
                  const SizedBox(height: 5),
                  buildCheckoutDetail(
                    theme,
                    title: AppLocalizations.of(context)!.shipping_cost,
                    trailing: 5,
                  ),
                  const SizedBox(height: 5),
                  buildCheckoutDetail(
                    theme,
                    title: AppLocalizations.of(context)!.total,
                    trailing: order!.book!.quantity * order!.book!.price! + 5,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            MyRaisedButton(
              label: AppLocalizations.of(context)!.place_my_order,
              onTap: placeMyOrderOnTap,
            ),
            const SizedBox(height: 15),

            Center(
              child: InkWell(
                onTap: () => Get.offAllNamed<dynamic>(Routes.order),
                child: Text(
                  AppLocalizations.of(context)!.back_to_my_order,
                  style: theme.textTheme.titleLarge!
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
            //radio (cod / paypal)
            // if cod selected
            // then go back to order page and change status from pending to ondelivery
            // if paypal
            // navigate to paypal webpage

            // subtotal price and shipping payment

            // button (place my oder)
            // secondary (go back to my order)
            //done
          ],
        ),
      ),
    );
  }

  Row buildCheckoutDetail(
    ThemeData theme, {
    required String title,
    int? trailing,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.bodyLarge),
        Text(
          NumberFormat.currency(
            symbol: r'$',
            decimalDigits: 0,
            locale: Const.localeUS,
          ).format(trailing),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          style: theme.textTheme.titleLarge!.copyWith(
            color: isTotal ? theme.primaryColor : null,
            fontWeight: isTotal ? FontWeight.bold : null,
          ),
        ),
      ],
    );
  }

  void placeMyOrderOnTap() {
    if (_paymentMethod == PaymentMethod.cod) {
      final orderItem =
          mockOrderList.firstWhereOrNull((item) => item.id == order!.id);
      if (orderItem != null) {
        setState(() {
          orderItem.orderStatus = OrderStatus.onDelivery;
        });

        Get.offAllNamed<dynamic>(Routes.order);
        showToast(
          msg: AppLocalizations.of(context)!
              .thank_you_your_order_will_be_delivered_soon,
        );
      }
    } else if (_paymentMethod == PaymentMethod.paypal) {
      Get.toNamed<dynamic>(Routes.paypal);
    } else {
      showToast(msg: AppLocalizations.of(context)!.select_your_payment);
    }
  }
}
