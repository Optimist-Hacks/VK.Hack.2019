import 'package:flutter/material.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/ui/widget/place_card.dart';

class PlacePage extends StatefulWidget {
  static const routeName = '/place';
  final Place _place;

  const PlacePage(this._place);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              pinned: true,
              expandedHeight: 371.0,
              flexibleSpace: FlexibleSpaceBar(
                background: _hero(),
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.zero,
              ),
            ),
          ];
        },
        body: Center(
          child: Container(),
        ),
      ),
    );
  }

  Widget _hero() {
    return Hero(
      tag: widget._place.id,
      child: PlaceCard(
        x: 0,
        y: 0,
        categoryName: "anus",
        place: widget._place,
        active: true,
        showBottomCategoryName: false,
        showTopCategoryName: false,
      ),
    );
  }
}
