import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Gif extends StatelessWidget {

  final Map _gifData;

  Gif(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"],
          style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
            icon: Icon(Icons.share),
            color: Colors.white,
          )
        ],
      ),
      body:Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
          ),
          Center(
            child: Image.network(_gifData["images"]["fixed_height"]["url"]),
          )
        ],
      )
    );
  }
}
