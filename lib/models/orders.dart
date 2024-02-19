class Order {
  String? sId;
  String? userId;
  String? adminId;
  String? paymentMode;
  int? amount;
  String? placedTime;
  String? accepted;
  String? orderStatus;
  List<Items>? items;
  int? iV;

  Order(
      {sId,
      userId,
      adminId,
      paymentMode,
      amount,
      placedTime,
      accepted,
      orderStatus,
      items,
      iV});

  Order.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    adminId = json['adminId'];
    paymentMode = json['paymentMode'];
    amount = json['amount'];
    placedTime = json['placedTime'];
    accepted = json['accepted'];
    orderStatus = json['orderStatus'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['userId'] = userId;
    data['adminId'] = adminId;
    data['paymentMode'] = paymentMode;
    data['amount'] = amount;
    data['placedTime'] = placedTime;
    data['accepted'] = accepted;
    data['orderStatus'] = orderStatus;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    return data;
  }
}

class Items {
  String? name;
  int? quantity;

  Items({name, quantity});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['quantity'] = quantity;
    return data;
  }
}
