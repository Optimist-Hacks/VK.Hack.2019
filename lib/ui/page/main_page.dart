import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        scrollDirection: Axis.vertical,
        items: List.generate(10, (indexY) {
          return CarouselSlider(
            scrollDirection: Axis.horizontal,
            items: List.generate(10, (indexX) {
              return Container(
                margin: EdgeInsets.all(8),
                color: Colors.deepOrange,
                child: Center(
                  child: Text("$indexX,$indexY"),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
