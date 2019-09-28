import 'package:built_collection/built_collection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:go_here/ui/colors.dart';
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

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  static const pageOffset = 10000;

  AnimationController currentCategoryAnimationController;

  bool categoriesMoving = false;
  bool placesMoving = false;

  PlaceBloc _placeBloc;
  PageController categoriesController;
  Map<int, PageController> placesControllers = {};

  final currentCategoryIndexSubject = BehaviorSubject<int>.seeded(0);
  final Map<int, BehaviorSubject<int>> currentPlaceIndexSubjects = {};

  @override
  void initState() {
    super.initState();

    currentCategoryAnimationController ??= AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentCategoryAnimationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    _placeBloc ??= Provider.of<PlaceBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BuiltList<Category>>(
        stream: _placeBloc.categoryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final categories = snapshot.data;

          return Stack(
            children: [
              _verticalCarousel(categories),
              _currentCategory(categories),
            ],
          );
        },
      ),
    );
  }

  Widget _currentCategory(BuiltList<Category> categories) {
    final animation =
        Tween(begin: 0.0, end: 1.0).animate(currentCategoryAnimationController);

    return Align(
      alignment: Alignment.center,
      child: StreamBuilder<int>(
        stream: currentCategoryIndexSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final currentCategory = snapshot.data;

          if (currentCategory == -1) {
            return Container();
          }

          final categoryName = categories[snapshot.data].name;

          return AnimatedBuilder(
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
            child: Text(
              categoryName.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GoColors.accent,
                fontWeight: FontWeight.w900,
                fontSize: 72,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _verticalCarousel(BuiltList<Category> categories) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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

                return _horizontalCarousel(
                  y,
                  categories,
                  currentCategoryIndex,
                );
              }),
      ],
    );

    categoriesController = categoriesCarousel.pageController;

    categoriesController.addListener(() {
      final index = categoriesController.page;

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

        currentCategoryAnimationController
          ..reset()
          ..forward();

        print("raw category index: $index, category index: $realIndex");
      } else {
        if (!categoriesMoving) {
          categoriesMoving = true;
          currentCategoryIndexSubject.add(-1);

          print("raw category index: $index, category index: $realIndex");
        }
      }
    });

    return categoriesCarousel;
  }

  Widget _horizontalCarousel(
    int y,
    BuiltList<Category> categories,
    int currentCategoryIndex,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    currentPlaceIndexSubjects[y] ??= BehaviorSubject<int>.seeded(0);

    final initialPage = currentPlaceIndexSubjects[y].value == -1
        ? 0
        : currentPlaceIndexSubjects[y].value;

    final placesCarousel = CarouselSlider(
      viewportFraction: 0.875,
      aspectRatio: width / height,
      scrollDirection: Axis.horizontal,
      initialPage: initialPage,
      items: [
        for (int x = 0; x < categories[y].places.length; x++)
          StreamBuilder<int>(
            stream: currentPlaceIndexSubjects[y],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final currentPlaceIndex = snapshot.data;

              return GestureDetector(
                onTap: () => _onPlaceTap(categories[y].places[x]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlaceCard(
                    x: x,
                    y: y,
                    categoryName: categories[y].name,
                    place: categories[y].places[x],
                    active: currentCategoryIndex == y && currentPlaceIndex == x,
                    showBottomCategoryName:
                        _getTopCategoryIndex(categories.length) == y,
                    showTopCategoryName:
                        _getBottomCategoryIndex(categories.length) == y,
                    roundAllBorders: true,
                  ),
                ),
              );
            },
          ),
      ],
    );

    final placesController = placesCarousel.pageController;

    placesControllers[y] = placesController;

    placesController.addListener(() {
      final index = placesController.page;

      double realIndex;

      if (index >= pageOffset) {
        realIndex = index % pageOffset % categories[y].places.length;
      } else {
        realIndex = categories[y].places.length -
            (pageOffset - index) % categories[y].places.length;
      }

      if (realIndex.floor() == realIndex) {
        currentPlaceIndexSubjects[y].add(realIndex.floor());
        placesMoving = false;

        print("raw places index: $index, places index: $realIndex");
      } else {
        if (!placesMoving) {
          placesMoving = true;
          currentPlaceIndexSubjects[y].add(-1);

          print("raw places index: $index, places index: $realIndex");
        }
      }
    });

    return placesCarousel;
  }

  _onPlaceTap(Place place) {
    Log.d(_tag, "On place tap $place");
    Navigator.pushNamed(
      context,
      PlacePage.routeName,
      arguments: place,
    );
  }

  int _getTopCategoryIndex(int categoriesLength) {
    if (categoriesMoving) {
      return -1;
    }

    final currentIndex = currentCategoryIndexSubject.value;

    int topIndex = currentIndex - 1;

    if (topIndex >= 0) {
      topIndex = topIndex % categoriesLength;
    } else {
      topIndex = categoriesLength - (topIndex.abs()) % categoriesLength;
    }

    return topIndex;
  }

  int _getBottomCategoryIndex(int categoriesLength) {
    if (categoriesMoving) {
      return -1;
    }

    final currentIndex = currentCategoryIndexSubject.value;

    int bottomIndex = currentIndex + 1;

    if (bottomIndex >= 0) {
      bottomIndex = bottomIndex % categoriesLength;
    } else {
      bottomIndex = categoriesLength - (bottomIndex.abs()) % categoriesLength;
    }

    return bottomIndex;
  }
}
