import 'package:nomnom/utils/networking.dart';

import '../models/common_res.dart';

class DataSource {
  static DataSource instance = DataSource();

  static String loginAPI = "user/login";
  static String nearestTrucksAPI = 'admin/getNearbyTrucks';
  static String menuItemsAPI = 'menu/getMenuByTruck';
  static String cuisineItemsAPI = 'admin/getNearestTruck';

  static String calendarEventAPI = 'https://graph.microsoft.com/v1.0/me/events';
  static String allMeetingsAPI = 'meet/myMeet';
  static String activeMeetingsAPI = 'meet/activemeets';
  static String foodMenuAPI = 'pantry/getitems';
  static String orderHistoryAPI = 'order/getOrderByUser';
  static String createOrderAPI = 'order/addOrder';
  static String addReviewAPI = 'review/addReview';
    static String getReviewsAPI = 'review/getReviewByUser';
  static String bookMeetingAPI = 'meet/book';
    static String searchAPI = 'menu/getFoodByName';

  static String cancelMeetingAPI = 'meet/del';
  static String checkInAPI = 'meet/checkin';
  static String updateMeetingAPI = 'meet/update';
  static String roomToken =
      'EwCIA8l6BAAUAOyDv0l6PcCVu89kmzvqZmkWABkAASvbsUxtdTJGxPg8wu52SC45AWz1jlTPUNy1MP3sgTB1vrnHsNI+DPxJzK1AFBzfvLxDIFf0DQYcdrx/ZfqVM5VHpxRuNLcneaqQbcHwJqh11oy3t3uzjb15M6X9FoFDeDRrbfvqkUIDfRfozPG3wlWAeiQ3NAKsC0e8PKy+UAsBjVb4Cf4f0D9kDTfEnkYty0GxuB2vfGZ5jsUuBhGzhY2pFUyoyNh7hdQAVuX0MlKEKLiVhGeP9Aer4IOINT+arKYm6WYm1DmWBda/LNbCWVJKP6X7jut3l1m43qXHuyPyokZbc0rSKeqvHOOPnHMWIyerVwYqT6AzsV36LwnQEqYDZgAACAA3y89VDTsNWAKZOP1iHyRfRmRJUbYSEwlJ2Gdc6FH00wbNOrGvv0PhGcJ1CSdnBudmcGlm9Cx1CabgnUQ2nB5D+RDuvgpOOgdLUwmgE3eDtflhOZWb+q+uhAjNXbPvOuWm2YVPzcaSgAYzk7Y9BGbbIep98zeZwDnrfkwMVP92zlX0GlwxaUZ+Ddf1DCZSDT3SB3N3c+QZg6AJooEv5ezr/KOk10wbvnSgnuEWkvT3xsgl5iQXI8kw84+7IXhg2EIPZfFW5OYnTeOReqHOYjuKwH/OlfhWF+Zxy5ajN4LGLyFwPj3W/BIzkkqHbJmqaW7mHYUPLH0ofbK/2imjSJ9L14p6CNSz1OFEZ6+19kMfQ7c/UZCDUuxwnDsxvOUYcWPxrX7d3WJT23++9kjHnRwg5p02Nf6IfQfErGcouxvhG7v5quMsHz5RDsxC2MoEWHkS1itXlHmEJ9WtKlMkipKinToOTgr/xgRSxmiusMKLQedPZKuX5rvTl4lKpZOGVK79fsT9bsyCJl/Qet5W2+LIP7a0uPdldIunXCRQw9yjW7EsIVd4JMJ4BOM7jhKLpgPvxuJaNoVBejLc56nL9QroOjFwCnJkNeJZImD4cjVL8MEAvVI4Lhmhi8cNe7ThTBYBuv3a3aWrQkfUsPbk/fgsHN5OUPYCbE1+5PsIkbeyaMljmhcOLBzPXwUS+4SvNIlmt8YSBjF3PdlWkcdKCGvvASoDtqklcF04e7ogi3Enr4s8rBhIjorEX/bXfuZT0mx8PWIO1NC3P7S1h1ohfoQ9qr72QRWTtXewFPBntx00vt6eAg==';
  static String userToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjQ4YWVlYWI2ZTdlNjY4Y2YxODAwNTBjIn0sImlhdCI6MTY4NzQxNDU0NH0.5HcyctgT8Q-5LiW7GLyncJzwfBEc0sy-8FVXnyJv4-A";
  static String filterRoomAPI = 'room/filter';
  static String searchRoomAPI = 'room/search';

  static Future<CommonResponse> login(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(
        loginAPI, body, successCompletion, errCompletion, false, null);
  }

  static Future<CommonResponse> getNearestTrucks(
      double lat, double lng, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(
        nearestTrucksAPI + '?latitude=${lat}&longitude=${lng}',
        token,
        successCompletion,
        errCompletion);
  }

  static Future<CommonResponse> getMenu(String id, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(
        menuItemsAPI + '?id=${id}', token, successCompletion, errCompletion);
  }

  static Future<CommonResponse> getCuisine(
      String lat, String lng, String c, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(
        cuisineItemsAPI + '?latitude=${lat}&longitude=${lng}&cuisine=${c}',
        token,
        successCompletion,
        errCompletion);
  }

  static Future<CommonResponse> getMyOrders(String id, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(orderHistoryAPI + '?userId=${id}', token,
        successCompletion, errCompletion);
  }

  static Future<CommonResponse> getFoodMenu(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(
        foodMenuAPI, body, successCompletion, errCompletion, false, userToken);
  }

    static Future<CommonResponse> addReview(dynamic body, String token , 
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(
        addReviewAPI, body, successCompletion, errCompletion, false, token);
  }

    static Future<CommonResponse> getReviews(String id, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(getReviewsAPI + '?userId=${id}', token,
        successCompletion, errCompletion);
  }

  static Future<CommonResponse> search(String name, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.get(searchAPI + '?name=${name}', token,
        successCompletion, errCompletion);
  }

  static Future<CommonResponse> getFilterRooms(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(filterRoomAPI, body, successCompletion,
        errCompletion, false, userToken);
  }

  static Future<CommonResponse> searchAvailableRooms(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(searchRoomAPI, body, successCompletion,
        errCompletion, false, userToken);
  }

  static Future<CommonResponse> bookMeeting(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(bookMeetingAPI, body, successCompletion,
        errCompletion, false, userToken);
  }

  static Future<CommonResponse> cancelMeeting(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.delete(cancelMeetingAPI, body, successCompletion,
        errCompletion, false, userToken);
  }

  static Future<CommonResponse> createEvent(dynamic body, String msToken,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(calendarEventAPI, body, successCompletion,
        errCompletion, false, msToken);
  }

//to extend a meeting
  static Future<CommonResponse> updateMeeting(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.put(updateMeetingAPI, body, successCompletion,
        errCompletion, false, userToken);
  }

  static Future<CommonResponse> checkInMeeting(dynamic body,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(
        checkInAPI, body, successCompletion, errCompletion, false, userToken);
  }

  static Future<CommonResponse> createOrder(dynamic body, String token,
      {required void Function(CommonResponse) successCompletion,
      required void Function(CommonResponse) errCompletion}) {
    return BaseNetwork.post(
        createOrderAPI, body, successCompletion, errCompletion, false, token);
  }
}
