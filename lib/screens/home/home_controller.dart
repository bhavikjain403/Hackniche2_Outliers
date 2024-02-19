import 'package:get/get.dart';
import 'package:nomnom/utils/enums.dart';

class HomeController extends GetxController {
  final Rx<HomeState> currentState = HomeState.meetings.obs;
}