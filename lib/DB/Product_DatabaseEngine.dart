import 'package:flutter/material.dart';
import 'package:localdb/DB/model.dart';
import 'package:localdb/MODELS/Product_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class ProductDatabaseEngin {
  final Database database;
  final String table;
  ProductDatabaseEngin(this.database, this.table);
  Future<List<Food>> getData() async {
    return database.query(table).then((_) { 
        return _.map((item) => Food.fromDB(item)).toList(); 
    });
  }

  Future<int> insertData(Food data) async {
    return await database.insert(table, data.toDBMap());
  }

  Future<int> deleteData({Food data}) async {
    return await database.delete(table,
        where: data != null ? "id = ?" : null,
        whereArgs: data != null ? data.toJson()["id"] : null);
  }

  static Future<Database> initDB() async {
    Database output = await openDatabase(
        await getDatabasesPath() + "/productDb", onCreate: (db, version) {
      db.execute("""
      CREATE TABLE  products (
        id TEXT PRIMARY KEY,
        categoryName TEXT,
        categoryId TEXT,
        productId TEXT,
        productName TEXT,
        imageurl TEXT,
        price REAL
      );
    """);
    }, version: 2);
    return output;
  }
}
