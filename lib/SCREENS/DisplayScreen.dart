import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localdb/APIS/Product_api.dart';
import 'package:localdb/BOLCS/Property_bloc.dart';
import 'package:localdb/DB/ProductDB.dart';
import 'package:localdb/DB/Product_DatabaseEngine.dart';
import 'package:localdb/MODELS/Product_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ProductsDB _movieDB;
  int _page = 1;
  List<Food> _items = [];
  bool _loading = true;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _initDB();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localdb"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _refresh,
        onLoading: () async {
          _page++;
          _initDB();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(),
          child: _loading
              ? Container(
                  alignment: Alignment.center,
                  height: 250,
                  child: CircularProgressIndicator(),
                )
              : _items.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      height: 250,
                      child: Text("Something happen!"),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _items.map((item) {
                        print(item);
                        return ListTile(
                          title: Text(
                            item.name,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            item.description,
                            maxLines: 3,
                          ),
                          leading: CachedNetworkImage(
                            imageUrl:
                                "https://bostonparkingspaces.com/wp-content/themes/classiera/images/nothumb/nothumb270x180.png", // Env.img780 + item.backdropPath.toString() ?? "",
                            width: 100,
                            errorWidget: (context, url, obj) {
                              return Image.network(
                                "https://bostonparkingspaces.com/wp-content/themes/classiera/images/nothumb/nothumb270x180.png",
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            },
                            placeholder: (context, url) {
                              return Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
        ),
      ),
    );
  }

  Future _getMovieDB() async {
    return await propertyBloc.fetchAllCategory();
  }

  void _refresh() async {
    _refreshController.refreshCompleted();
    setState(() {
      _loading = true;
    });
    _page = 1;
    _items.clear();
    _movieDB.deleteData();
    if ((await _getMovieDB()) != null) {
      _initDB();
      return;
    }
  }

  void _initDB() async {
    if (_movieDB == null)
      _movieDB = ProductsDB(await ProductDatabaseEngin.initDB());
    var raw = await _movieDB.getData();
    if (raw.length == 0) {
      if (await _getMovieDB() != null||_getMovieDB() == null) {
        _initDB();
        return;
      } else {
        //   print("data check");
        // print(_getMovieDB());
        _refresh();
        return;
      }
    } else {
      _items = List.from(_items ?? [])..addAll(raw ?? []);
    }
    setState(() {
      _loading = false;
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }
}
