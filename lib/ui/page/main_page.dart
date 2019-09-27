import 'package:built_collection/built_collection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:go_here/ui/page/place_page.dart';
import 'package:go_here/ui/widget/place_card.dart';
import 'package:go_here/utils/log.dart';
import 'package:provider/provider.dart';

const _tag = "main_page";

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const pageOffset = 10000;

  PlaceBloc _placeBloc;
  PageController categoriesController;

  int currentCategoryIndex;

  @override
  void didChangeDependencies() {
    _placeBloc ??= Provider.of<PlaceBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: StreamBuilder<BuiltList<Category>>(
        stream: _placeBloc.categoryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final categories = snapshot.data;

          final carousel = CarouselSlider(
            aspectRatio: width / height,
            scrollDirection: Axis.vertical,
            viewportFraction: 0.76,
            items: [
              for (int y = 0; y < categories.length; y++)
                CarouselSlider(
                  viewportFraction: 0.875,
                  aspectRatio: width / height,
                  scrollDirection: Axis.horizontal,
                  items: [
                    for (int x = 0; x < categories[y].places.length; x++)
                      PlaceCard(x, y, categories[y].name,
                          categories[y].places[x], true)
                  ],
                ),
            ],
          );

          categoriesController = carousel.pageController;

          categoriesController.addListener(() {
            print("Event: ${categoriesController.page}");
          });

          return carousel;
        },
      )),
    );
  }

  _onPlaceTap(Place place) {
    Log.d(_tag, "On place tap $place");
    Navigator.pushReplacementNamed(context, PlacePage.routeName);
  }
}
