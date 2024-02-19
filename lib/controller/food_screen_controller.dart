import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nomnom/models/common_res.dart';
import 'package:nomnom/models/food.dart';
import 'package:nomnom/models/foodTruck.dart';
import 'package:nomnom/models/orders.dart';
import 'package:nomnom/screens/food/detailscreen.dart';
import 'package:nomnom/screens/home/home_screen.dart';
import 'package:nomnom/utils/colors.dart';
import 'package:nomnom/utils/data_source.dart';
import 'package:nomnom/utils/enums.dart';
import 'package:nomnom/utils/shared_prefs.dart';
import 'package:nomnom/utils/utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FoodScreenController extends GetxController {
  double lat = 0;
  double lng = 0;
  RxString currLoc = 'DJSCE , Mumbai'.obs;
  late Razorpay razorpay;
  Rx<OzoneState> nearTruckState = OzoneState.loading.obs;
  Rx<OzoneState> menuItemsState = OzoneState.loading.obs;
  Rx<OzoneState> orderState = OzoneState.loading.obs;
  String token = '';
  RxList<FoodTruck> nearbyTrucks = RxList.empty();
  RxList<Food> menuItems = RxList.empty();
  RxList<Order> myOrders = RxList.empty();
  RxInt totalItems = 0.obs;
  RxInt orderAmt = 0.obs;
  String truckId = '';
  String uid = '';
  Map<int, dynamic> customizations = {};
  RxString selectedCuisine = ''.obs;
  SpeechToText speechToText = SpeechToText();

  void _initSpeech() async {
    await speechToText.initialize();
    // setState(() {});
  }

  void clearCart() {
    totalItems.value = 0;
    orderAmt.value = 0;
    menuItems.forEach((f) => f.qty = 0);
    update();
  }

  void setFoodItems(List<Food> f, int index, int qty) {
    menuItems[index].qty = qty;
    menuItems.refresh();
    //foodItems.value = f;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position p = await Geolocator.getCurrentPosition();
    lat = p.latitude;
    lng = p.longitude;
    getNearestTrucks();
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      currLoc.value = '${placemarks[0].subLocality} ${placemarks[0].locality}';
    }
  }

  void getMenuItems(String id) async {
    selectedCuisine.value = '';
    clearCart();
    menuItems.clear();
    menuItemsState.value = OzoneState.loading;
    //update();
    // print(data);
    await DataSource.getMenu(id, token, successCompletion: (CommonResponse c) {
      // debugPrint(c.data.toString());
      if (c.data != null) {
        print(c.data.length);
        for (int i = 0; i < c.data.length; i++) {
          menuItems.add(Food.fromJson(c.data[i]));
        }
      }
      update();
      menuItemsState.value = OzoneState.loaded;
    }, errCompletion: (CommonResponse c) {
      Utils.showBottomSnackBar(
          ic: Icon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.errorColor,
          ),
          title: "",
          message: c.message ?? "");
      menuItemsState.value = OzoneState.loaded;
      debugPrint(c.message);
    });
    update();
  }

  void getCuisineItems(String c) async {
    selectedCuisine.value = c;
    clearCart();
    menuItems.clear();
    menuItemsState.value = OzoneState.loading;
    //update();
    // print(data);
    await DataSource.getCuisine(lat.toString(), lng.toString(), c, token,
        successCompletion: (CommonResponse c) {
      // debugPrint(c.data.toString());
      //print('hi');
      try {
        if (c.data != null) {
          //   print(c.data.length);
          for (int i = 0; i < c.data.length; i++) {
            print(c.data[i]);
            menuItems.add(Food.fromJson(c.data[i]));
          }
        }

        print(c.truckData);
        FoodTruck ft = FoodTruck.fromJson(c.truckData);
        truckId = ft.sId ?? '';
        Get.to(() => FoodTruckDetails(
              ft: ft,
            ));
      } catch (e) {
        print(e.toString());
        Utils.showBottomSnackBar(
            ic: Icon(
              FontAwesomeIcons.triangleExclamation,
              color: AppColors.errorColor,
            ),
            title: "",
            message: c.message ?? "");
        menuItemsState.value = OzoneState.loaded;
        debugPrint(c.message);
      }
      update();
      menuItemsState.value = OzoneState.loaded;
    }, errCompletion: (CommonResponse c) {
      Utils.showBottomSnackBar(
          ic: Icon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.errorColor,
          ),
          title: "",
          message: c.message ?? "");
      menuItemsState.value = OzoneState.loaded;
      debugPrint(c.message);
    });
    update();
  }

  void getNearestTrucks() async {
    nearTruckState.value = OzoneState.loading;
    //update();
    // print(data);
    await DataSource.getNearestTrucks(lat, lng, token,
        successCompletion: (CommonResponse c) {
      // debugPrint(c.data.toString());
      if (c.data != null) {
        for (int i = 0; i < c.data.length; i++) {
          nearbyTrucks.add(FoodTruck.fromJson(c.data[i]));
        }
      }
      update();
      nearTruckState.value = OzoneState.loaded;
    }, errCompletion: (CommonResponse c) {
      Utils.showBottomSnackBar(
          ic: Icon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.errorColor,
          ),
          title: "Failed to login !",
          message: c.message ?? "");
      nearTruckState.value = OzoneState.loaded;
      debugPrint(c.message);
    });
    update();
  }

  void openCheckout() async {
    //  createOrder();
    var options = {
      'key': 'rzp_test_3Sczn3cgezybpy',
      'amount': orderAmt.value * 100,
      'name': 'Ojas',
      'description': 'Payment',
      'prefill': {'contact': '9167403295', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      //print('as');
      //debugPrint(e.toString());
    }
  }

  void fetchOrderHistory() async {
    myOrders.clear();
    orderState.value = OzoneState.loading;
    await DataSource.getMyOrders(uid, token,
        successCompletion: (CommonResponse cp) {
      if (cp.data != null) {
        for (int i = 0; i < cp.data.length; i++) {
          myOrders.add(Order.fromJson(cp.data[i]));
        }
      }
      print(cp.data.length);
      orderState.value = OzoneState.loaded;
    }, errCompletion: (CommonResponse cp) {
      debugPrint(cp.message);
    });
    orderState.value = OzoneState.loaded;
    update();
  }

  void createOrder() async {
    List<dynamic> items = [];

    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i].qty > 0) {
        items.add({
          "itemid": menuItems[i].sId,
          "quantity": menuItems[i].qty,
          "name": menuItems[i].name,
          //  "customization": {}
        });
        menuItems[i].qty = 0;
      }
    }

    final body = {
      "userId": SharedPrefs.getId(),
      "adminId": truckId,
      "paymentMode": "prepaid",
      "items": items,
      "amount": orderAmt.value,
      "accepted": "no",
      "orderStatus": "placed"
    };

    print(body);
    await DataSource.createOrder(body, token,
        successCompletion: (CommonResponse cp) {
      //Get.back();
      clearCart();
      fetchOrderHistory();
      print(cp.data);
      //  fetchOrderHistory();
      Utils.showBottomSnackBar(
          title: "Order Placed !!",
          message: "Your order will be delivered soon",
          ic: const Icon(FontAwesomeIcons.checkDouble,
              color: AppColors.greenAccent));
    }, errCompletion: (CommonResponse cp) {
      print(cp.data.toString());
      Utils.showBottomSnackBar(
          title: "Uh-oh",
          message: cp.message.toString(),
          ic: const Icon(FontAwesomeIcons.info, color: AppColors.errorColor));
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    createOrder();
    Get.offAll(() => HomeScreen());
    Get.snackbar("SUCCESS: " + response.paymentId!, "Payment Done ! ");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("ERROR: " + response.code.toString(), response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("EXTERNAL_WALLET: " + response.walletName!, "");
  }

  @override
  void onInit() {
    uid = SharedPrefs.getId();
    print(uid);
    razorpay = Razorpay();
    token = SharedPrefs.getToken();
    fetchOrderHistory();
    _initSpeech();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _determinePosition();
    super.onInit();
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}
