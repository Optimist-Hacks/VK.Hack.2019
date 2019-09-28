import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/data/model/place.dart';
import 'package:video_player/video_player.dart';

final rand = Random();

class PlaceCard extends StatefulWidget {
  final int x;
  final int y;

  final String categoryName;
  final Place place;

  final bool active;
  final bool showBottomCategoryName;
  final bool showTopCategoryName;

  PlaceCard({
    @required this.x,
    @required this.y,
    @required this.categoryName,
    @required this.place,
    @required this.active,
    @required this.showBottomCategoryName,
    @required this.showTopCategoryName,
    Key key,
  }) : super(key: key);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    if(widget.active) {
      _videoController = createVideoPlayerController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
  if(widget.active) {
    _videoController ??= createVideoPlayerController();
  } else {
    _videoController?.dispose();
    _videoController = null;
  }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsets.all(8),
//      color: Color(rand.nextInt(0xFFFFFFFF)),
      child: Stack(
        children: <Widget>[
          if (widget.active) video(),
          Container(
//            color: widget.active ? Colors.green : Colors.grey,
            child: Center(
              child: Text("${widget.x},${widget.y}"),
            ),
          ),
          infoOverlay(),
          if (widget.showBottomCategoryName) bottomCategoryName(),
          if (widget.showTopCategoryName) topCategoryName(),
        ],
      ),
    );
  }

  Widget video() {
    return _videoController.value.initialized
        ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        : Container(
            color: Colors.blueGrey,
          );
  }

  Widget weather() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Text(
          "${widget.place.temperature.floor()}°",
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
      "\$${widget.place.price.floor()}",
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 34,
        color: Colors.white,
      ),
    );
  }

  Widget name() {
    return Text(
      widget.place.name,
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

  Widget bottomCategoryName() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: categoryName(),
    );
  }

  Widget topCategoryName() {
    return Align(
      alignment: Alignment.topCenter,
      child: categoryName(),
    );
  }

  Widget categoryName() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Opacity(
        opacity: 0.67,
        child: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  VideoPlayerController createVideoPlayerController(){
    return VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _videoController?.play();
      });
  }
}
