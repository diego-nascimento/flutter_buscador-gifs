import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = null;
  int _offset = 0;

  Future<Map>_getGif()async{
    http.Response response;
    if(_search == null){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=3d3Dn9J283gh7qXXiuESzHZaB4nG1ckO&limit=20&rating=R");
    }else{
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=3d3Dn9J283gh7qXXiuESzHZaB4nG1ckO&q=$_search&limit=20&offset=$_offset&rating=R&lang=en");
    }
    return json.decode(response.body);
  }
  @override
  void initState(){
    _getGif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  if(_search == ""){
                    _search = null;
                  }
                  _offset = 0;
                });

              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      )
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else{
                      return _createGiftable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      )
    );
  }

  int getCount(List data){
    if(_search == null){
      return data.length;
    }else{
      return data.length +1;
    }
  }


  Widget _createGiftable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if(_search == null || index <snapshot.data["data"].length){
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=> Gif(snapshot.data["data"][index])
                  )
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
              child:FadeInImage.memoryNetwork(
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
              ),
            );
          }else{
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _offset +=20;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                        color: Colors.white,
                    ),
                    Text("Carregar mais...",
                      style: TextStyle(
                          color: Colors.white,
                      ),
                    )
                  ],
                )
              ),
            );
          }

        }
    );
  }
}


