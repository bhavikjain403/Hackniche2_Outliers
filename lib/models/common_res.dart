import 'dart:convert';

class CommonResponse<T> {
  bool? success;
  String? message;
  T? data;
  T? truckData;
  List<T>? listData;
  int? errCode;

  CommonResponse(
      {this.success,
      this.message,
      this.data,
      this.listData,
      this.errCode,
      this.truckData});

  CommonResponse.fromEncString(String encData) {
    Map<String, dynamic> json = jsonDecode(encData);
    if (json['status'] == false) {
      message = json['error_msg'].toString();
      errCode = json['error_code'];
    }

    success = json['status'];
    data = json['data'];
    truckData = json['truckData'];
  }

  CommonResponse.fromJson(Map<String, dynamic> json) {
    success = json['status'];
    message = json['msg'];
    data = json['data'];
    truckData = json['truckData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = success;
    data['message'] = message;
    data['response'] = this.data;
    return data;
  }
}
