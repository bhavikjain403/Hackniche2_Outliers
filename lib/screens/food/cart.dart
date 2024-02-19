import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/models/foodTruck.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/wrapper.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class Cart extends StatefulWidget {
  Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FoodScreenController controller = Get.find<FoodScreenController>();
  TextEditingController timeinput = TextEditingController();
  final List<RouteMarker> routeMaker = Get.arguments;
  String minTime = '0';
  String maxTime = '0';

  TimeOfDay minutesToTimeOfDay(int minutes) {
    Duration duration = Duration(minutes: minutes);
    List<String> parts = duration.toString().split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void initState() {
    timeinput.text = DateFormat.jm().format(DateTime.now());
    if (routeMaker.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        int hms = routeMaker[0].startTime ?? 0;
        int ems = routeMaker[0].endTime ?? 1440;
        TimeOfDay s = minutesToTimeOfDay(hms);
        TimeOfDay e = minutesToTimeOfDay(ems);
        minTime = s.format(context);
        maxTime = e.format(context);
        setState(() {});
      });

      // setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
        child: FocusedLayout(
            pos: FloatingActionButtonLocation.centerDocked,
            isScrollable: true,
            fab: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ConfirmationSlider(
                height: 64,
                // width: double.infinity,
                onConfirmation: () => controller.openCheckout(),
                text: 'Slide to Pay ₹${controller.orderAmt}',
                //  / width: 350,
                iconColor: AppColors.greenAccent,
                sliderButtonContent: const Icon(
                  EvaIcons.chevronRightOutline,
                  size: 40,
                  color: AppColors.greenAccent,
                ),
                foregroundColor: AppColors.whiteColor,
                backgroundColor: AppColors.greenAccent,
                textStyle: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            appBarTitle: "My Cart",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: routeMaker.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Pickup Slot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '$minTime - $maxTime',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            color: AppColors.greenAccent,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Items',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.menuItems.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: controller.menuItems[index].qty != 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  // crossAxisAlignment: CrossAxisAlignment.start,

                                  leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              controller.menuItems[index].img ??
                                                  '')),

                                  title: Text(
                                    '${controller.menuItems[index].name}',
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  subtitle: controller.customizations[index] !=
                                          null
                                      ? Text(
                                          'Addons : ${controller.customizations[index].toString().replaceAll("[", "").replaceAll("]", "")}')
                                      : null,

                                  trailing: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        // border: Border.all(width: 2),
                                        shape: BoxShape.circle,
                                        // You can use like this way or like the below line
                                        //borderRadius: new BorderRadius.circular(30.0),
                                        color: AppColors.orangeAccent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${controller.menuItems[index].qty}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    //const Spacer(),
                  ],
                ),
              ),
            )));
  }
}
