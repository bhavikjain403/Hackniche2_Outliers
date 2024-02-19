import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/models/common_res.dart';
import 'package:nomnom/utils/data_source.dart';

class FeedBackController extends GetxController {
  final fc = Get.find<FoodScreenController>();
  TextEditingController reviewController = TextEditingController();
  RxDouble currentRating = RxDouble(0);
  RxMap<dynamic, dynamic> myReviews = {}.obs;

  void addReview(String adminId, String orderId) async {
    Map<String, dynamic> body = {
      "adminId": adminId,
      "userId": fc.uid,
      "orderId": orderId,
      "rating": currentRating.value,
      "review": reviewController.text
    };

    await DataSource.addReview(body, fc.token,
        successCompletion: (CommonResponse c) {
      print(c.data.toString());
      myReviews[orderId] = currentRating.value;
      Get.back();
      //print('hi');
    }, errCompletion: (CommonResponse c) {});
  }

  void getReviews() async {
    await DataSource.getReviews(fc.uid, fc.token,
        successCompletion: (CommonResponse c) {
      //  print(c.data.toString());
      if (c.data != null && c.data.length > 0) {
        for (int i = 0; i < c.data.length; i++) {
          myReviews[c.data[i]['orderId']] = c.data[i]['rating'];
        }
      }
      print(myReviews);
      //print('hi');
    }, errCompletion: (CommonResponse c) {});
  }

  @override
  void onInit() {
    getReviews();
    super.onInit();
  }
}
