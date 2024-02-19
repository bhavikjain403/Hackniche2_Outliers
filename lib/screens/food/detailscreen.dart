import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/models/foodTruck.dart';
import 'package:nomnom/screens/food/cart.dart';
import 'package:nomnom/screens/food/customize.dart';
import 'package:nomnom/screens/food/tts.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/utils.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/wrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FoodTruckDetails extends StatelessWidget {
  FoodTruckDetails({super.key, required this.ft});
  final FoodTruck ft;
  final fc = Get.find<FoodScreenController>();

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
        child: FocusedLayout(
            fab: Stack(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Get.to(() => Cart(), arguments: ft.routeMarker);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        shape: BoxShape.circle,
                        // You can use like this way or like the below line
                        //borderRadius: new BorderRadius.circular(30.0),
                        color: AppColors.orangeAccent,
                      ),
                      child: Center(
                        child: Obx(
                          () => Text(
                            fc.totalItems.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                )
              ],
            ),
            appBarTitle: ft.name ?? '',
            isScrollable: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            trailing: IconButton(
                              icon: Icon(EvaIcons.shareOutline),
                              onPressed: () async {
                                final bytes = await rootBundle
                                    .load('assets/images/logo.png');
                                final list = bytes.buffer.asUint8List();
                                final tempDir = await getTemporaryDirectory();
                                final file =
                                    await File('${tempDir.path}/logo.png')
                                        .create();
                                file.writeAsBytesSync(list);
                                Share.shareFiles(['${file.path}'],
                                    text:
                                        "Great Food Experience With ${ft.name} at ${ft.city}");
                              },
                            ),
                            title: Text(
                              ft.name ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  EvaIcons.starOutline,
                                  color: Colors.green,
                                ),
                                Text(
                                  '${ft.rating}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  ' (${ft.numberOfRatings}+ Reviews)',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('${ft.cuisine}'),
                          ),
                          ListTile(
                            onTap: () => Utils.openLink(
                                'google.navigation:q=${ft.latitude},${ft.longitude}&mode=d'),
                            leading: Icon(EvaIcons.navigation2Outline),
                            title: Text('Get Directions'),
                            dense: true,
                          ),
                          ListTile(
                            onTap: () => Utils.openLink('tel:${ft.phone}'),
                            leading: Icon(EvaIcons.phoneCallOutline),
                            title: Text('Call'),
                            dense: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 5),
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: AppColors.orangeAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.orangeAccent)),
                                  ),
                                  const Text("Your Location",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 17),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                  color: AppColors.orangeAccent,
                                ))),
                                child: Text(
                                  'Distance\n${ft.distance}',
                                  style: TextStyle(),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 5),
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: AppColors.orangeAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.orangeAccent)),
                                  ),
                                  const Text("Truck's Position",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fc.selectedCuisine.value.isNotEmpty
                            ? fc.selectedCuisine.value
                            : 'Available Items',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.to(() => SpeakToOrder(), arguments: ft);
                          },
                          icon: Icon(
                            EvaIcons.micOutline,
                            color: AppColors.orangeAccent,
                          ))
                    ],
                  ),
                  Obx(
                    () => fc.menuItems.length == 0
                        ? Text('Loading...')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: fc.menuItems.length,
                            itemBuilder: (context, index) {
                              return Visibility(
                                visible: fc.menuItems[index].complete ?? true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      '${fc.menuItems[index].img}')),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${fc.menuItems[index].name} • ₹ ${fc.menuItems[index].price}",
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  "${fc.menuItems[index].description}",
                                                  softWrap: true,
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                (fc.menuItems[index].name!
                                                            .toLowerCase() ==
                                                        'burger')
                                                    ? TextButton(
                                                        child:
                                                            Text('Customize'),
                                                        onPressed: () => Get.to(
                                                            () =>
                                                                Customization3D(),
                                                            arguments: {
                                                              'ix': index,
                                                              'name': fc
                                                                  .menuItems[
                                                                      index]
                                                                  .name!
                                                            }),
                                                      )
                                                    : SizedBox(),
                                                fc.menuItems[index].qty > 0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                fc.orderAmt -= (fc
                                                                        .menuItems[
                                                                            index]
                                                                        .price ??
                                                                    0);

                                                                if (fc.customizations[
                                                                        index] !=
                                                                    null) {
                                                                  String s =
                                                                      fc.customizations[
                                                                          index];
                                                                  if (s.contains(
                                                                      'tomato')) {
                                                                    fc.orderAmt -=
                                                                        50;
                                                                  }
                                                                  if (s.contains(
                                                                      'salad')) {
                                                                    fc.orderAmt -=
                                                                        50;
                                                                  }
                                                                  if (s.contains(
                                                                      'cheese')) {
                                                                    fc.orderAmt -=
                                                                        50;
                                                                  }
                                                                }

                                                                int q = fc
                                                                    .menuItems[
                                                                        index]
                                                                    .qty;
                                                                q -= 1;
                                                                if (q == 0) {
                                                                  fc.totalItems
                                                                      .value -= 1;
                                                                }
                                                                fc.setFoodItems(
                                                                    fc.menuItems,
                                                                    index,
                                                                    q);
                                                              },
                                                              icon: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 6),
                                                            Text(fc
                                                                .menuItems[
                                                                    index]
                                                                .qty
                                                                .toString()),
                                                            const SizedBox(
                                                                width: 6),
                                                            IconButton(
                                                              onPressed: () {
                                                                fc.orderAmt += (fc
                                                                        .menuItems[
                                                                            index]
                                                                        .price ??
                                                                    0);
                                                                if (fc.customizations[
                                                                        index] !=
                                                                    null) {
                                                                  String s =
                                                                      fc.customizations[
                                                                          index];
                                                                  if (s.contains(
                                                                      'tomato')) {
                                                                    fc.orderAmt +=
                                                                        50;
                                                                  }
                                                                  if (s.contains(
                                                                      'salad')) {
                                                                    fc.orderAmt +=
                                                                        50;
                                                                  }
                                                                  if (s.contains(
                                                                      'cheese')) {
                                                                    fc.orderAmt +=
                                                                        50;
                                                                  }
                                                                }
                                                                int q = fc
                                                                    .menuItems[
                                                                        index]
                                                                    .qty;
                                                                q += 1;
                                                                fc.setFoodItems(
                                                                    fc.menuItems,
                                                                    index,
                                                                    q);
                                                              },
                                                              icon: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ])
                                                    : TextButton(
                                                        onPressed: () {
                                                          fc.orderAmt += fc
                                                                  .menuItems[
                                                                      index]
                                                                  .price ??
                                                              0;
                                                          if (fc.customizations[
                                                                  index] !=
                                                              null) {
                                                            String s =
                                                                fc.customizations[
                                                                    index];
                                                            if (s.contains(
                                                                'tomato')) {
                                                              fc.orderAmt += 50;
                                                            }
                                                            if (s.contains(
                                                                'salad')) {
                                                              fc.orderAmt += 50;
                                                            }
                                                            if (s.contains(
                                                                'cheese')) {
                                                              fc.orderAmt += 50;
                                                            }
                                                          }
                                                          int q = fc
                                                              .menuItems[index]
                                                              .qty;
                                                          q += 1;
                                                          fc.totalItems.value +=
                                                              1;
                                                          fc.setFoodItems(
                                                              fc.menuItems,
                                                              index,
                                                              q);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                        0),
                                                                minimumSize:
                                                                    const Size(
                                                                        110, 35),
                                                                maximumSize:
                                                                    const Size(
                                                                        110,
                                                                        35),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .orangeAccent,
                                                                foregroundColor:
                                                                    AppColors
                                                                        .whiteColor,
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                //<-- SEE HERE
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(10))),
                                                        child: const Text(
                                                          'ADD',
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          // const Spacer(),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       vertical: 10, horizontal: 10),
                                          //   child: SvgPicture.asset(
                                          //     "assets/img/veg-icon.svg",
                                          //     //theme: SvgTheme(currentColor: AppColors.greenAccent),
                                          //     color: AppColors.greenAccent,
                                          //     width: 40,
                                          //     height: 40,
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            )));
  }
}
