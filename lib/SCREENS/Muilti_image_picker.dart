import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localdb/SCREENS/DisplayScreen.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MuiltiImagePicker extends StatefulWidget {
  @override
  _MuiltiImagePickerState createState() => new _MuiltiImagePickerState();
}

class _MuiltiImagePickerState extends State<MuiltiImagePicker> {
  List<Asset> images = List<Asset>();
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Stack(children: <Widget>[
          AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images.replaceRange(index, index + 1, []);
                });
              },
              child: Icon(
                Icons.remove_circle,
                size: 20,
                color: Colors.red,
              ),
            ),
          )
        ]);
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Muilti image picker'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
         RaisedButton(
              child: Text("next"),
              onPressed: (){
                navigateToPage(context, MainScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
navigateToPage(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}
