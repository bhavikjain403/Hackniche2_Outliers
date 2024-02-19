// ignore_for_file: deprecated_member_use
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:nomnom/controller/feedback_controller.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/enums.dart';
import 'package:nomnom/utils/utils.dart';
import 'package:nomnom/widgets/empty.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/form_item.dart';
import 'package:nomnom/widgets/wrapper.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});
  final FoodScreenController controller = Get.find();
  final FeedBackController fcb = Get.put(FeedBackController());

  Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
    final ita = a.iterator;
    final itb = b.iterator;
    bool hasa, hasb;
    while ((hasa = ita.moveNext()) | (hasb = itb.moveNext())) {
      if (hasa) yield ita.current;
      if (hasb) yield itb.current;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      child: FocusedLayout(
        appBarTitle: 'My Orders',
        child: Obx(() => controller.myOrders.isEmpty
            ? controller.orderState.value == OzoneState.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const EmptyWidget(
                    assetName: "assets/img/empty_orders.svg",
                    label: 'You have no past orders !!',
                    subtitle: '',
                  )
            : ListView.separated(
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                ),
                shrinkWrap: true,
                itemCount: controller.myOrders.length,
                itemBuilder: (context, index) {
                  List<String> n = List.empty(growable: true);
                  List<String> q = List.empty(growable: true);
                  controller.myOrders[index].items!.forEach(
                    (element) {
                      n.add(element.name ?? '');
                    },
                  );

                  controller.myOrders[index].items!.forEach(
                    (element) {
                      q.add('(${element.quantity})-');
                    },
                  );
                  List<dynamic> items = zip(n, q).toList();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            dense: true,
                            isThreeLine: false,
                            title: Text(
                              "${controller.myOrders[index].adminId}",
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "₹ ${controller.myOrders[index].amount}",
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.greyColor),
                            ),
                            trailing: controller.myOrders[index].orderStatus ==
                                    'picked'
                                ? const Icon(
                                    FontAwesomeIcons.circleCheck,
                                    size: 24,
                                    color: AppColors.greenAccent,
                                  )
                                : const Icon(
                                    EvaIcons.clockOutline,
                                    size: 24,
                                    color: Colors.amber,
                                  )),
                        Row(
                          children: List.generate(
                              170 ~/ 10,
                              (index) => Expanded(
                                    child: Container(
                                      color: index % 2 == 0
                                          ? Colors.transparent
                                          : Colors.grey,
                                      height: 1.2,
                                    ),
                                  )),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            items
                                .toString()
                                .replaceAll(',', '')
                                .replaceAll(')-', ') ,')
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            Utils.getDayMonth(
                                controller.myOrders[index].placedTime!),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.greyColor),
                          ),
                        ),
                        Obx(
                          () => fcb.myReviews[controller.myOrders[index].sId] !=
                                  null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        EvaIcons.star,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                          '  ${fcb.myReviews[controller.myOrders[index].sId]}')
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextButton(
                                      onPressed: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text('Rate'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: 3,
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    fcb.currentRating.value =
                                                        rating;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                FormItem(
                                                    question: 'Review',
                                                    controller:
                                                        fcb.reviewController)
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.greenAccent,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                onPressed: () => fcb.addReview(
                                                    controller.myOrders[index]
                                                            .adminId ??
                                                        '',
                                                    controller.myOrders[index]
                                                            .sId ??
                                                        ''),
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  "Close",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.errorColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                onPressed: () => Get.back(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text('Rate Your Order')),
                                ),
                        )
                      ],
                    ),
                  );
                },
              )),
      ),
    );
  }
}
