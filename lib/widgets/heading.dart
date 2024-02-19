import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomnom/utils/colors.dart';

class Heading extends StatelessWidget {
  const Heading({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        title,
        style: TextStyle(
            color: AppColors.orangeAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}