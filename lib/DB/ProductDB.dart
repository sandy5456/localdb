import 'package:flutter/material.dart';
import 'package:localdb/DB/Product_DatabaseEngine.dart';
import 'package:localdb/MODELS/Product_model.dart';
import 'package:sqflite/sqlite_api.dart';


class ProductsDB extends ProductDatabaseEngin{
  ProductsDB(Database database) : super(database, "products");
  
}