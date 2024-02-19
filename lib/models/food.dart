class Food {
  String? sId;
  String? truckId;
  String? cuisine;
  String? name;
  bool? complete;
  int? price;
  int? veg;
  String? img;
  Customization? customization;
  String? description;
  int? iV;
  int? avail;
  int qty = 0;

  Food(
      {sId,
      truckId,
      cuisine,
      name,
      price,
      veg,
      img,
      customization,
      description,
      iV,
      avail,
      qty = 0});

  Food.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    truckId = json['truckId'];
    cuisine = json['cuisine'];
    name = json['name'];
    price = json['price'];
    veg = json['veg'];
    img = json['img'];
    complete = json['complete'] ?? true;
    customization = json['customization'] != null
        ? Customization.fromJson(json['customization'])
        : null;
    description = json['description'];
    iV = json['__v'];
    avail = json['avail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['truckId'] = truckId;
    data['cuisine'] = cuisine;
    data['name'] = name;
    data['price'] = price;
    data['veg'] = veg;
    data['img'] = img;
    if (customization != null) {
      data['customization'] = customization!.toJson();
    }
    data['description'] = description;
    data['__v'] = iV;
    data['avail'] = avail;
    return data;
  }
}

class Customization {
  int? chillySauce;

  Customization({chillySauce});

  Customization.fromJson(Map<String, dynamic> json) {
    chillySauce = json['chilly sauce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chilly sauce'] = chillySauce;
    return data;
  }
}
