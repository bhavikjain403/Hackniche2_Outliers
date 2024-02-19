import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void showBottomSnackBar(
      {required String title, required String message, required Icon ic}) {
    Get.snackbar(
      title,
      message,
      icon: ic,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.whiteColor,
    );
  }


  // static Future<void> openLink(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  static Future<void> openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getTime(String date) {
    DateTime dt = DateTime.tryParse(date) ?? DateTime.now();
    dt = dt.toLocal();
    return DateFormat.jm().format(dt);
  }

  static String getDateMonth(String date) {
    DateTime dt = DateTime.tryParse(date) ?? DateTime.now();
    dt = dt.toLocal();
    return '${DateFormat.d().format(dt)}\n${DateFormat.LLL().format(dt)}';
  }

  static String getDayMonth(String date) {
    DateTime dt = DateTime.tryParse(date) ?? DateTime.now();
    dt = dt.toLocal();
    return DateFormat.MMMEd().format(dt);
  }

  static String getCheckIN(String date) {
    DateTime dt = DateTime.tryParse(date) ?? DateTime.now();
    dt = dt.toLocal();
    dt = dt.add(const Duration(minutes: 30));
    return DateFormat.jm().format(dt);
  }

  static String getAmPmTime(String time) {
    time = '$time:00+05:30';
    return DateFormat.jm().format(DateFormat("hh:mm:ss").parse(time).toLocal());
  }
}



extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
