import 'package:flutter/material.dart';
import 'package:buscadorgif/pages/Home.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.red,
      primaryColor: Colors.white
    )
  ));
}


