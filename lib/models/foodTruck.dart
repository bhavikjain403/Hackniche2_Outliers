class FoodTruck {
  String? sId;
  String? name;
  String? email;
  int? phone;
  String? password;
  num? latitude;
  num? longitude;
  String? rating;
  num? numberOfRatings;
  String? cuisine;
  String? city;
  int? iV;
  late String distance;
  List<RouteMarker>? routeMarker;

  FoodTruck(
      {sId,
      name,
      email,
      phone,
      password,
      latitude,
      longitude,
      rating,
      numberOfRatings,
      cuisine,
      city,
      iV,
      routeMarker,
      distance = ''});

  FoodTruck.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    // password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    num r = json['rating'];
    rating = r.toStringAsFixed(2);
    numberOfRatings = json['numberOfRatings'];
    cuisine = json['cuisine'].toString();
    city = json['city'];
    num d = json['distance'] ?? 0;
    if (json['routeMarker'] != null) {
      routeMarker = <RouteMarker>[];
      json['routeMarker'].forEach((v) {
        routeMarker!.add(RouteMarker.fromJson(v));
      });
    }
    if (d < 0.5) {
      d = d * 100;
      distance = '${d.toStringAsFixed(2)} m';
    } else {
      distance = '${d.toStringAsFixed(2)} Km';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['rating'] = rating;
    data['numberOfRatings'] = numberOfRatings;
    data['cuisine'] = cuisine;
    data['city'] = city;
    data['__v'] = iV;
    data['distance'] = distance;
    return data;
  }
}


class RouteMarker {
  List<double>? coordinate;
  int? startTime;
  int? endTime;

  RouteMarker({coordinate, startTime, endTime});

  RouteMarker.fromJson(Map<String, dynamic> json) {
    coordinate = json['coordinate'].cast<double>();
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['coordinate'] = coordinate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
