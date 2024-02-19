import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/screens/auth/onboarding.dart';
import 'package:nomnom/screens/food/detailscreen.dart';
import 'package:nomnom/screens/history.dart';
import 'package:nomnom/screens/search.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/shared_prefs.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:nomnom/widgets/wrapper.dart';

class FoodScreen extends StatefulWidget {
  FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final fc = Get.find<FoodScreenController>();

  late PageController _pageController;

  int activePage = 1;

  List<String> images = [
    "assets/images/c1.jpg",
    "assets/images/c2.jpg",
    "assets/images/c3.jpg",
  ];

  List<String> cuisines = [
    'North Indian',
    'Chinese',
    'South Indian',
    'Italian',
    'Beverages',
    'Desserts'
  ];

  List<String> cuisineImg = [
    'assets/images/north.jpg',
    'assets/images/chinese.jpg',
    'assets/images/south.jpg',
    'assets/images/italian.jpg',
    'assets/images/bev.jpg',
    'assets/images/ice.jpg',
  ];

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
    super.initState();
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 5 : 10;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(images[pagePosition]))),
    );
  }

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
        // isScrollable: true,
        child: Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(() => OnBoardingScreen());
                SharedPrefs.clear();
              },
              icon: Icon(
                EvaIcons.logOutOutline,
                color: AppColors.greyColor,
              ))
        ],
        title: ListTile(
          title: Text(
            'My Location',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Obx(() => Text(fc.currLoc.value)),
          leading: Icon(
            EvaIcons.pinOutline,
            color: AppColors.orangeAccent,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Get.width,
                  height: 48,
                  child: OutlinedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Search For Pizza..',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Icon(
                            EvaIcons.search,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(48, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))
                        //primary: Colors.teal,
                        ),
                    onPressed: () async {
                      await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: PageView.builder(
                      itemCount: images.length,
                      pageSnapping: true,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        bool active = pagePosition == activePage;
                        return slider(images, pagePosition, active);
                      }),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(images.length, activePage)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "WHAT ARE YOU CRAVING TODAY ? 🤔",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return GridView.builder(
                    // padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cuisines.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        fc.getCuisineItems(cuisines[index]);
                        // Get.to(() => Cuisines());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 90.0,
                            height: 90.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(cuisineImg[index]),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            cuisines[index],
                            style: TextStyle(fontWeight: FontWeight.w700),
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisCount: 3,
                      //    childAspectRatio: 5,
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "NEAREST TRUCK PICKS FOR YOU 📍",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // SizedBox(
                //   height: 150,
                //   child: Obx(
                //     () => ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       // padding: EdgeInsets.all(0),
                //       shrinkWrap: true,
                //       // physics: const NeverScrollableScrollPhysics(),
                //       itemCount: fc.nearbyTrucks.length,
                //       itemBuilder: (context, index) => Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Column(
                //           children: [
                //             Card(
                //               elevation: 2,
                //               child: Container(
                //                 width: 90.0,
                //                 height: 90.0,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(20),
                //                   image: DecorationImage(
                //                     image: CachedNetworkImageProvider(
                //                         'https://5.imimg.com/data5/KU/SE/JE/SELLER-10365776/food-truck-500x500.jpg',
                //                         maxHeight: 90,
                //                         maxWidth: 90),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Text(
                //               fc.nearbyTrucks[index].name ?? '',
                //               style: TextStyle(fontWeight: FontWeight.w700),
                //               maxLines: 2,
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                // const Text(
                //   "DISCOVER NEW FOODTRUCKS 🚚🌭",
                //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const Text(
                //   '215 Food Trucks To Explore',
                //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                Obx(
                  () => fc.nearbyTrucks.length == 0
                      ? Text('Loading...')
                      : ListView.builder(
                          itemCount: fc.nearbyTrucks.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                fc.getMenuItems(
                                    fc.nearbyTrucks[index].sId ?? '');
                                fc.truckId = fc.nearbyTrucks[index].sId ?? '';
                                Get.to(() => FoodTruckDetails(
                                      ft: fc.nearbyTrucks[index],
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  //  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        child: Container(
                                          width: 130.0,
                                          height: 130.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  'https://static.vecteezy.com/system/resources/previews/029/313/739/large_2x/displaying-a-3d-miniature-food-truck-generative-ai-photo.jpg',
                                                  maxHeight: 130,
                                                  maxWidth: 130),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fc.nearbyTrucks[index].name ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                EvaIcons.starOutline,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                '${fc.nearbyTrucks[index].rating}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                ' (${fc.nearbyTrucks[index].numberOfRatings}+)',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              '${fc.nearbyTrucks[index].cuisine}'),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${fc.nearbyTrucks[index].city} • ${fc.nearbyTrucks[index].distance}',
                                            style: TextStyle(
                                                color: AppColors.orangeAccent,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ])
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
