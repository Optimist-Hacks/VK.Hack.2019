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
import 'package:rxdart/rxdart.dart';

const _tag = "main_page";

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const pageOffset = 10000;

  bool categoriesMoving = false;
  bool placesMoving = false;

  PlaceBloc _placeBloc;
  PageController categoriesController;
  PageController placesController;

  final currentCategoryIndexSubject = BehaviorSubject<int>.seeded(0);
  final currentPlaceIndexSubject = BehaviorSubject<int>.seeded(0);

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

          final categoriesCarousel = CarouselSlider(
            aspectRatio: width / height,
            scrollDirection: Axis.vertical,
            viewportFraction: 0.76,
            items: [
              for (int y = 0; y < categories.length; y++)
                StreamBuilder<int>(
                    stream: currentCategoryIndexSubject,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      final currentCategoryIndex = snapshot.data;

                      final placesCarousel = CarouselSlider(
                        viewportFraction: 0.875,
                        aspectRatio: width / height,
                        scrollDirection: Axis.horizontal,
                        items: [
                          for (int x = 0; x < categories[y].places.length; x++)
                            StreamBuilder<int>(
                              stream: currentPlaceIndexSubject,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }

                                final currentPlaceIndex = snapshot.data;

                                return GestureDetector(
                                  onTap: () => _onPlaceTap(categories[y].places[x]),
                                  child: PlaceCard(
                                    x,
                                    y,
                                    categories[y].name,
                                    categories[y].places[x],
                                    currentCategoryIndex == y &&
                                        currentPlaceIndex == x,
                                  ),
                                );
                              },
                            ),
                        ],
                      );

                      placesController = placesCarousel.pageController;

                      placesController.addListener(() {
                        final index = placesController.page;

                        print("raw places index: $index");

                        double realIndex;

                        if (index >= pageOffset) {
                          realIndex =
                              index % pageOffset % categories[y].places.length;
                        } else {
                          realIndex = categories[y].places.length -
                              (pageOffset - index) %
                                  categories[y].places.length;
                        }

                        if (realIndex.floor() == realIndex) {
                          currentPlaceIndexSubject.add(realIndex.floor());
                          placesMoving = false;
                        } else {
                          if (!placesMoving) {
                            placesMoving = true;
                            currentPlaceIndexSubject.add(-1);
                          }
                        }
                        print("places index: $realIndex");
                      });

                      return placesCarousel;
                    }),
            ],
          );

          categoriesController = categoriesCarousel.pageController;

          categoriesController.addListener(() {
            final index = categoriesController.page;

            print("raw category index: $index");

            double realIndex;

            if (index >= pageOffset) {
              realIndex = index % pageOffset % categories.length;
            } else {
              realIndex =
                  categories.length - (pageOffset - index) % categories.length;
            }

            if (realIndex.floor() == realIndex) {
              currentCategoryIndexSubject.add(realIndex.floor());
              categoriesMoving = false;
            } else {
              if (!categoriesMoving) {
                categoriesMoving = true;
                currentCategoryIndexSubject.add(-1);
              }
            }
            print("category index: $realIndex");
          });

          return categoriesCarousel;
        },
      )),
    );
  }

  _onPlaceTap(Place place) {
    Log.d(_tag, "On place tap $place");
    Navigator.pushReplacementNamed(context, PlacePage.routeName);
  }
}
