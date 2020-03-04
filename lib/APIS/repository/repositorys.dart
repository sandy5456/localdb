import 'package:localdb/APIS/Product_api.dart';
import 'package:localdb/MODELS/Product_model.dart';

class Repository{
   final propertyprovider = PropertyProvider();
   
     Future<List<FoodResponse>> fetchAllProperty() =>
      propertyprovider.fetchPropertyList();
}