import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/screens/food/foodscreen.dart';
import 'package:nomnom/screens/history.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/enums.dart';
import 'package:nomnom/widgets/wrapper.dart';

import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final fc = Get.put(FoodScreenController());
  final _tabs = [FoodScreen(), OrderHistory()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        int currentIndex = homeController.currentState.value.index;
        return ThemeWrapper(
          child: Scaffold(
            body: _tabs[homeController.currentState.value.index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: BottomNavigationBar(
                selectedItemColor: AppColors.orangeAccent,
                backgroundColor: AppColors.whiteColor,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),

                type: BottomNavigationBarType.fixed,
                // unselectedFontSize: 14,
                currentIndex: currentIndex,
                onTap: (newIndex) {
                  homeController.currentState.value =
                      HomeState.values[newIndex];
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      FluentIcons.food_24_regular,
                      size: 26,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      EvaIcons.personOutline,
                      size: 26,
                    ),
                    label: 'Orders',
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        );
      },
    );
  }
}
