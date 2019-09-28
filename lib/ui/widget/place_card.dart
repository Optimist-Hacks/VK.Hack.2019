import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/utils/log.dart';
import 'package:video_player/video_player.dart';

const _tag = "place_card";
final rand = Random();

class PlaceCard extends StatefulWidget {
  final _borderRadius = BorderRadius.circular(30);

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

    if (widget.active) {
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
    if (widget.active) {
      _videoController ??= createVideoPlayerController();
    } else {
      _videoController?.dispose();
      _videoController = null;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: widget._borderRadius),
      margin: EdgeInsets.all(8),
      child: Stack(
        children: <Widget>[
          if (widget.active) video(),
          Container(
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
        ? _centerCropVideo()
        : Container(color: Colors.blueGrey);
  }

  Widget _centerCropVideo() {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = constraints.maxWidth;
        double containerHeight = constraints.maxHeight;
        Log.d(_tag, "maxWidth = $containerWidth maxHeight = $containerHeight");
        double size = max(containerWidth, containerHeight);
        return ClipRRect(
          borderRadius: widget._borderRadius,
          child: OverflowBox(
            maxWidth: size,
            maxHeight: size,
            alignment: Alignment.center,
            child: VideoPlayer(_videoController),
          ),
        );
      },
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

  VideoPlayerController createVideoPlayerController() {
    Log.d(_tag, "Creaate video player controllere");
    return VideoPlayerController.network(
        'https://ucf1de27a5d276af478bcc86cc0a.dl.dropboxusercontent.com/cd/0/inline/ApbuFHloj8IPpu4uuDaOWv2V-ymuTqBEpRfowd1PD-7WGH-nVAvozsq5I0IUgCIgBq4TU1QtfEgKd_9CAC59C8O63Xi08Q50STBp1Qcwt4Dsqh-_Twvh2ixkM9D_u_02DtY/file#')
      ..setVolume(0.0)
      ..setLooping(true)
      ..initialize().then((_) {
        Log.d(_tag, "Controller initialized");
        setState(() {});
        _videoController?.play();
      });
  }
}
