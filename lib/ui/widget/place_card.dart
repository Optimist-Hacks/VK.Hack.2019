import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final rand = Random();

class PlaceCard extends StatefulWidget {
  final int x;
  final int y;

  final bool active;

  PlaceCard(this.x, this.y, this.active, {Key key}) : super(key: key);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
      color: Color(rand.nextInt(0xFFFFFFFF)),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text("${widget.x},${widget.y}"),
          ),
          infoOverlay(),
        ],
      ),
    );
  }

  Widget weather() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Text(
          "24°",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget priceAndName() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            price(),
            name(),
          ],
        ),
      ),
    );
  }

  Widget price() {
    return Text(
      "\$184",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 34,
        color: Colors.white,
      ),
    );
  }

  Widget name() {
    return Text(
      "Los Angeles",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget infoOverlay() {
    return AnimatedOpacity(
      opacity: widget.active ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Stack(
        children: <Widget>[
          weather(),
          priceAndName(),
        ],
      ),
    );
  }
}
