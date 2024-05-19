import 'package:ejazapp/core/class/crud.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Start
    Get.put(Crud());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
