import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: CarouselSlider(
          aspectRatio: width / height,
          scrollDirection: Axis.vertical,
          items: List.generate(10, (indexY) {
            return CarouselSlider(
              aspectRatio: width / height,
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
      ),
    );
  }
}
