import 'package:flutter/material.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalPaymentPage extends StatefulWidget {
  const PayPalPaymentPage({super.key});
  @override
  State<PayPalPaymentPage> createState() => _PayPalPaymentPageState();
}

class _PayPalPaymentPageState extends State<PayPalPaymentPage> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url
                .startsWith('https://www.paypal.com/paypalme/dickyrey')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.paypal.com/paypalme/dickyrey'));
    // #enddocregion webview_controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: controller)),
          Positioned(
            top: 50,
            left: Const.margin,
            child: CircleAvatar(
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
          ),
        ],
      ),
    );
  }
}
