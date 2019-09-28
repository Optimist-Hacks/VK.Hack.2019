import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/service/preferences_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/images.dart';
import 'package:go_here/utils/log.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

const _tag = "place_card";
final rand = Random();

class PlaceCard extends StatefulWidget {
  final PreferencesService _preferencesService;
  final _allBorderRadius = BorderRadius.circular(30);
  final _bottomBorderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
  );

  final String categoryName;
  final Place place;

  final bool active;

  final VideoPlayerController videoController;
  final Future<void> videoControllerInitializeCallback;

  final bool showBottomCategoryName;
  final bool showTopCategoryName;
  final bool roundAllBorders;

  PlaceCard(
    this._preferencesService, {
    @required this.categoryName,
    @required this.place,
    @required this.active,
    @required this.videoController,
    @required this.videoControllerInitializeCallback,
    @required this.showBottomCategoryName,
    @required this.showTopCategoryName,
    @required this.roundAllBorders,
    Key key,
  }) : super(key: key);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> with TickerProviderStateMixin {
  AnimationController heartAnimationController;

  bool liked;

  @override
  void initState() {
    super.initState();
    heartAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    liked = widget._preferencesService.isLiked(widget.place.id);

    if (widget.videoControllerInitializeCallback != null) {
      widget.videoControllerInitializeCallback.then((_) {
        setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(PlaceCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoControllerInitializeCallback != null) {
      widget.videoControllerInitializeCallback.then((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          if (widget._preferencesService.isLiked(widget.place.id)) {
            widget._preferencesService.removeLikedPlace(widget.place.id);
          } else {
            heartAnimationController
              ..reset()
              ..forward();
            widget._preferencesService.addLikedPlace(widget.place.id);
          }

          setState(() {
            liked = widget._preferencesService.isLiked(widget.place.id);
          });
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: widget.roundAllBorders
                  ? widget._allBorderRadius
                  : widget._bottomBorderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _image(),
              if (widget.active &&
                  (widget.videoController?.value?.initialized ?? false))
                _video(),
              _gradient(),
              infoOverlay(),
              if (widget.showBottomCategoryName) bottomCategoryName(),
              if (widget.showTopCategoryName) topCategoryName(),
              _heartAnimation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradient() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: 0.7,
        child: ClipRRect(
          borderRadius: widget.roundAllBorders
              ? widget._allBorderRadius
              : widget._bottomBorderRadius,
          child: Container(
            height: 197.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  GoColors.placeGradientStart,
                  GoColors.placeGradientEnd
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: widget.roundAllBorders
          ? widget._allBorderRadius
          : widget._bottomBorderRadius,
      child: CachedNetworkImage(
        imageUrl: "https://www.dropbox.com/s/e41zuwyrnnzxatp/preview.png?raw=1",
        alignment: Alignment.center,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _video() {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = constraints.maxWidth;
        double containerHeight = constraints.maxHeight;
        Log.d(_tag, "maxWidth = $containerWidth maxHeight = $containerHeight");
        double size = max(containerWidth, containerHeight);
        return ClipRRect(
          borderRadius: widget.roundAllBorders
              ? widget._allBorderRadius
              : widget._bottomBorderRadius,
          child: OverflowBox(
            maxWidth: size,
            maxHeight: size,
            alignment: Alignment.center,
            child: VideoPlayer(widget.videoController),
          ),
        );
      },
    );
  }

  Widget _weather() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Text(
          "${widget.place.temperature.floor()}°",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: GoColors.accent,
          ),
        ),
      ),
    );
  }

  Widget _priceAndName() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            price(),
            SizedBox(height: 9.0),
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
        color: GoColors.accent,
      ),
    );
  }

  Widget name() {
    return Text(
      widget.place.name,
      style: TextStyle(
        fontSize: 16,
        color: GoColors.accent,
      ),
    );
  }

  Widget infoOverlay() {
    return AnimatedOpacity(
      opacity: widget.active ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Stack(
        children: <Widget>[
          if (liked) _heart(),
          _weather(),
          _priceAndName(),
          if (!widget.roundAllBorders) _shareButton(),
        ],
      ),
    );
  }

  Widget _heart() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: SvgPicture.asset(
          Images.heart,
          fit: BoxFit.cover,
          height: 16,
          width: 16,
          color: GoColors.accent,
        ),
      ),
    );
  }

  Widget _shareButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(right: 20.0, bottom: 30.0),
        child: SizedBox(
          width: 38.0,
          height: 38.0,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: _onSharePress,
            child: SvgPicture.asset(
              Images.share,
              fit: BoxFit.cover,
              height: 13,
              width: 15,
            ),
            backgroundColor: GoColors.shareBackground,
            elevation: 0,
          ),
        ),
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
      padding: const EdgeInsets.all(20.0),
      child: Opacity(
        opacity: 0.67,
        child: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: GoColors.accent,
          ),
        ),
      ),
    );
  }

  void _onSharePress() {
    Log.d(_tag, "On share press");
    Share.share(
        "Wow!\n\nTickeets to ${widget.place.name} are only ${widget.place.price.floor()}\$\n\nLet's go here!\n\n${widget.place.video}");
  }

  Widget _heartAnimation() {
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double containerWidth = constraints.maxWidth;

          final animation =
              Tween(begin: 0.0, end: 1.0).animate(heartAnimationController);

          return IgnorePointer(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                double opacity;

                if (animation.value <= 0.5) {
                  opacity = animation.value;
                } else {
                  opacity = 0.5 - (animation.value - 0.5);
                }

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: animation.value,
                    child: child,
                  ),
                );
              },
              child: Icon(
                Icons.favorite,
                size: containerWidth,
                color: GoColors.accent,
              ),
            ),
          );
        },
      ),
    );
  }
}
