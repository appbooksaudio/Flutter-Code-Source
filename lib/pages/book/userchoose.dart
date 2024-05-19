import 'package:ejazapp/helpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChoose extends StatelessWidget {
  const UserChoose({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        InkWell(
          onTap: () => Get.toNamed(Routes.comentpage),
          child: const Text(
            "View Comment",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () => Get.toNamed(Routes.comment),
          child: const Text("Chat",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}
