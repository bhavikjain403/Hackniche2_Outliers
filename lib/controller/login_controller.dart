import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nomnom/models/common_res.dart';
import 'package:nomnom/screens/home/home_screen.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/data_source.dart';
import 'package:nomnom/utils/enums.dart';
import 'package:nomnom/utils/shared_prefs.dart';
import 'package:nomnom/utils/utils.dart';

class LoginController extends GetxController {
  Rx<OzoneState> loginState = OzoneState.loaded.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  void login({required String username, required String password}) async {
    loginState.value = OzoneState.loading;

    final Map<String, dynamic> data = {"email": username, "password": password};
    //update();
    // print(data);
    await DataSource.login(data, successCompletion: (CommonResponse c) {
      //debugPrint(c.data);
      SharedPrefs.saveToken(c.data['token']);
      SharedPrefs.saveId(c.data['user']['_id']);
      SharedPrefs.setIsFirstInstalled();
      Get.off(() => const HomeScreen());
      loginState.value = OzoneState.loaded;
    }, errCompletion: (CommonResponse c) {
      Utils.showBottomSnackBar(
          ic: const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.errorColor,
          ),
          title: "Failed to login !",
          message: c.message ?? "");
      loginState.value = OzoneState.loaded;
      debugPrint(c.message);
    });
  }
}
