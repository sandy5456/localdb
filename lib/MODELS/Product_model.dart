import 'package:localdb/DB/model.dart';

class FoodResponse {
  final String catogeryname;
  List<Food> foods;
  final int cId;
  FoodResponse({this.catogeryname, this.foods, this.cId});

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    return FoodResponse(
      foods: (json['products'] as List).map((i) => Food.fromJson(i)).toList(),
      catogeryname: json['categoryName'],
      cId: json['categoryId'],
    );
  }
  Map<String, dynamic> toJson() => {
        "categoryId": cId,
        "categoryName": catogeryname,
        "products": List<dynamic>.from(foods.map((x) => x.toJson())),
      };
}

//FoodResponse Food
class Food extends Model {
  String images;
  int catogeryid;
  int id;
  String name;
  String description;
  var price;
  int rating;
  Shop shop;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int favid;

  Food({
    this.catogeryid,
    this.images,
    this.id,
    this.name,
    this.description,
    this.price,
    this.rating,
    this.shop,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.favid,
  });
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['productId'],
        name: json['productName'],
        images: json['imageurl'],
        price: json['price'],
        catogeryid: json['categoryId'],
        favid: json['id']);
  }

  factory Food.fromDB(Map<String, dynamic> json) {
    return Food(
      id: int.parse(json['productId']),
      name: json['productName'],
      images: json['imageurl'],
      price: json['price'],
      catogeryid: int.parse(json['categoryId']),
      favid: int.parse(json['id']),
    );
  }
  Map<String, dynamic> toJson() => {
        "productId": id,
        "productName": name,
        "price": price,
        "imageurl": images,
        "categoryId": catogeryid,
      };

  Map<String, String> toDBMap() => {
        "productId": id.toString(),
        "productName": name.toString(),
        "price": price.toString(),
        "imageurl": images.toString(),
        "categoryId": catogeryid.toString()
      };
}

class Shop {
  String id;
  String name;
  String email;

  Shop({this.id, this.name, this.email});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );
}
