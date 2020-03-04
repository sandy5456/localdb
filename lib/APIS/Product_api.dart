import 'dart:convert';

import 'package:http/http.dart';
import 'package:localdb/DB/ProductDB.dart';
import 'package:localdb/DB/Product_DatabaseEngine.dart';

import 'package:localdb/MODELS/Product_model.dart';

class PropertyProvider {
 List<FoodResponse> list;

  Client client = Client();
  String propertyUrl = "http://142.93.219.45:8080/KyanCafe/kyancafe/showsMenu";
  Future<List<FoodResponse>> fetchPropertyList() async {
    // try {
    ProductsDB productsDB = ProductsDB(await ProductDatabaseEngin.initDB());
    final response = await client.get(propertyUrl);
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rest = data as List;
      print("we r getting data..");
      print(rest);
      list = rest.map((json) {
       FoodResponse.fromJson(json).foods.forEach((item){
            productsDB.insertData(item);
        });
        return FoodResponse.fromJson(json);
      }).toList();
      // .map<FoodResponse>((json) => FoodResponse.fromJson(json))
      // .toList();

      return list;
    } else {
      throw Exception("Failed to load Deals");
    }
    //} catch (e) {}
  }
} //http://142.93.219.45:8080/KyanCafe/kyancafe/showsMenu
