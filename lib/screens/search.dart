import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/models/common_res.dart';
import 'package:nomnom/models/food.dart';
import 'package:nomnom/utils/data_source.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final controller = Get.find<FoodScreenController>();
  final Dio dio = Dio();

  Future<List<Food>> getFoodByName(String name) async {
    List<Food> searchList = List.empty(growable: true);

    Response res = await dio.get(
        'https://foodtruck-poi9.onrender.com/api/menu/getFoodByName?name=${name}');


    if (res.data['data'] != null) {
      for (int i = 0; i < res.data['data'].length; i++) {
        searchList.add(Food.fromJson(res.data['data'][i]));
      }
    }
    return searchList;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: getFoodByName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext c, int index) {
              final Food food = snapshot.data![index];
              return Visibility(
                  visible: food.complete ?? true,
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
                                              '${food.img}')),
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
                                          "${food.name} • ₹ ${food.price}",
                                          softWrap: true,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "${food.description}",
                                          softWrap: true,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        //       (fc.menuItems[index].name!.toLowerCase() ==
                                        //               'burger')
                                        //           ? TextButton(
                                        //               child: Text('Customize'),
                                        //               onPressed: () => Get.to(
                                        //                   () => Customization3D(),
                                        //                   arguments: {
                                        //                     'ix': index,
                                        //                     'name': fc.menuItems[index].name!
                                        //                   }),
                                        //             )
                                        //           : SizedBox(),
                                        //       fc.menuItems[index].qty > 0
                                        //           ? Row(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment.center,
                                        //               children: [
                                        //                   IconButton(
                                        //                     onPressed: () {
                                        //                       fc.orderAmt -= (fc
                                        //                               .menuItems[index]
                                        //                               .price ??
                                        //                           0);
                                        //                       int q = fc.menuItems[index].qty;
                                        //                       q -= 1;
                                        //                       if (q == 0) {
                                        //                         fc.totalItems.value -= 1;
                                        //                       }
                                        //                       fc.setFoodItems(
                                        //                           fc.menuItems, index, q);
                                        //                     },
                                        //                     icon: const Icon(
                                        //                       Icons.remove,
                                        //                       color: Colors.green,
                                        //                     ),
                                        //                   ),
                                        //                   const SizedBox(width: 6),
                                        //                   Text(fc.menuItems[index].qty
                                        //                       .toString()),
                                        //                   const SizedBox(width: 6),
                                        //                   IconButton(
                                        //                     onPressed: () {
                                        //                       fc.orderAmt += (fc
                                        //                               .menuItems[index]
                                        //                               .price ??
                                        //                           0);
                                        //                       int q = fc.menuItems[index].qty;
                                        //                       q += 1;
                                        //                       fc.setFoodItems(
                                        //                           fc.menuItems, index, q);
                                        //                     },
                                        //                     icon: const Icon(
                                        //                       Icons.add,
                                        //                       color: Colors.green,
                                        //                     ),
                                        //                   ),
                                        //                 ])
                                        //           : TextButton(
                                        //               onPressed: () {
                                        //                 fc.orderAmt +=
                                        //                     fc.menuItems[index].price ?? 0;
                                        //                 int q = fc.menuItems[index].qty;
                                        //                 q += 1;
                                        //                 fc.totalItems.value += 1;
                                        //                 fc.setFoodItems(
                                        //                     fc.menuItems, index, q);
                                        //               },
                                        //               style: TextButton.styleFrom(
                                        //                   padding: const EdgeInsets.all(0),
                                        //                   minimumSize: const Size(110, 35),
                                        //                   maximumSize: const Size(110, 35),
                                        //                   backgroundColor:
                                        //                       AppColors.orangeAccent,
                                        //                   foregroundColor:
                                        //                       AppColors.whiteColor,
                                        //                   textStyle: const TextStyle(
                                        //                       fontWeight: FontWeight.bold),
                                        //                   //<-- SEE HERE
                                        //                   shape: RoundedRectangleBorder(
                                        //                       borderRadius:
                                        //                           BorderRadius.circular(10))),
                                        //               child: const Text(
                                        //                 'ADD',
                                        //               ),
                                        //             ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // // const Spacer(),
                                        // // Padding(
                                        // //   padding: const EdgeInsets.symmetric(
                                        // //       vertical: 10, horizontal: 10),
                                        // //   child: SvgPicture.asset(
                                        // //     "assets/img/veg-icon.svg",
                                        // //     //theme: SvgTheme(currentColor: AppColors.greenAccent),
                                        // //     color: AppColors.greenAccent,
                                        // //     width: 40,
                                        // //     height: 40,
                                        // //   ),
                                        // // )
                                      ],
                                    ),
                                  ),
                                ])),
                      )));
            },
            itemCount: snapshot.data?.length,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
