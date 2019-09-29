import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:go_here/service/preferences_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/page/place_page.dart';
import 'package:go_here/ui/widget/place_card.dart';
import 'package:go_here/utils/log.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shake/shake.dart';
import 'package:video_player/video_player.dart';

const _tag = "main_page";

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  static const pageOffset = 10000;

  VideoPlayerController _videoController;
  Future<void> _videoControllerInitializeCallback;

  AnimationController currentCategoryAnimationController;

  bool categoriesMoving = false;
  bool placesMoving = false;

  PlaceBloc _placeBloc;
  PageController categoriesController;
  Map<int, PageController> placesControllers = {};

  final currentCategoryIndexSubject = BehaviorSubject<int>.seeded(0);
  final Map<int, BehaviorSubject<int>> currentPlaceIndexSubjects = {};

  final nearestCurrentCategoryIndexSubject = BehaviorSubject<int>.seeded(0);
  final Map<int, BehaviorSubject<int>> nearestCurrentPlaceIndexSubjects = {};

  PreferencesService _preferencesService;
  ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();

    currentCategoryAnimationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentCategoryAnimationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    Log.d(_tag, "didChangeDependencies");
    _placeBloc ??= Provider.of<PlaceBloc>(context);
    _preferencesService ??= Provider.of<PreferencesService>(context);
    _shakeDetector ??= ShakeDetector.autoStart(
      shakeCountResetTime: 1000,
      shakeThresholdGravity: 2.0,
      onPhoneShake: () {
        Log.d(_tag, "Shake deteck");
        _preferencesService.setDarkMode(!_preferencesService.currentDartMode());
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BuiltList<Category>>(
        stream: _placeBloc.categoryStream,
        builder: (context, snapshot) {
          BuiltList<Category> categories;

          bool isRealData;

          if (snapshot.hasError || snapshot.hasData && snapshot.data.isEmpty) {
            isRealData = false;
            categories = getStubData();
          } else if (!snapshot.hasData) {
            return Container();
          } else {
            isRealData = true;
            categories = snapshot.data;
          }

          for (int y = 0; y < categories.length; y++) {
            nearestCurrentPlaceIndexSubjects[y] ??=
                BehaviorSubject<int>.seeded(0);
            currentPlaceIndexSubjects[y] ??= BehaviorSubject<int>.seeded(0);
          }

          if (isRealData) {
            nearestCurrentCategoryIndexSubject.listen((y) async {
              nearestCurrentPlaceIndexSubjects[y].listen((x) async {
                final videoUrl = categories[y].places[x].videoUrl;

                if (_videoController != null &&
                    _videoController.dataSource == videoUrl) {
                  Log.d(_tag, "Same video path, reuse controller");
                } else {
                  Log.d(_tag, "Different video path");

                  if (_videoController != null) {
                    Log.d(_tag, "Dispose previous video controller");
                    _videoController.dispose();
                  }

                  _videoController = createVideoPlayerController(videoUrl);

                  _videoControllerInitializeCallback =
                      _videoController.initialize();
                }
              });
            });
          }

          return Stack(
            children: [
              _verticalCarousel(categories, isRealData),
              _currentCategory(categories),
            ],
          );
        },
      ),
    );
  }

  Widget _verticalCarousel(BuiltList<Category> categories, bool isRealData) {
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
                  isRealData,
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
            (categories.length - (pageOffset - index)) % categories.length;
      }

      int nearestIndex;
      if (realIndex - realIndex.floor() <= 0.5) {
        nearestIndex = realIndex.floor();
      } else {
        nearestIndex = realIndex.ceil();
      }

      nearestIndex %= categories.length;

      if (nearestIndex != nearestCurrentCategoryIndexSubject.value) {
        Log.d(_tag, "Set category nearestIndex to $nearestIndex");
        nearestCurrentCategoryIndexSubject.add(nearestIndex);
      }

      if (realIndex.ceil() == realIndex) {
        currentCategoryIndexSubject.add(realIndex.ceil());
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
    bool isRealData,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final initialPage = currentPlaceIndexSubjects[y].value == -1
        ? 0
        : currentPlaceIndexSubjects[y].value;

    final placesCarousel = CarouselSlider(
      scrollPhysics: y == currentCategoryIndex
          ? PageScrollPhysics()
          : NeverScrollableScrollPhysics(),
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

              final active =
                  currentCategoryIndex == y && currentPlaceIndex == x;

              if (active && _videoController != null) {
                final videoController = _videoController;
                _videoControllerInitializeCallback.then((_) {
                  Log.d(_tag, "Controller initialized");
                  videoController.play();
                });
              }

              if (currentCategoryIndex == -1 || currentPlaceIndex == -1) {
                if (_videoController != null &&
                    _videoControllerInitializeCallback != null) {
                  final videoController = _videoController;

                  _videoControllerInitializeCallback.then((_) {
                    videoController.pause();
                    videoController.seekTo(Duration(seconds: 0));
                  });
                }
              }

              return GestureDetector(
                onTap: () {
                  if (active && isRealData)
                    _onPlaceTap(categories[y].name, categories[y].places[x]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: categories[y].places[x].id,
                    child: PlaceCard(
                      _preferencesService,
                      categoryName: categories[y].name,
                      place: categories[y].places[x],
                      active: active,
                      videoController: active ? _videoController : null,
                      videoControllerInitializeCallback:
                          active ? _videoControllerInitializeCallback : null,
                      showBottomCategoryName:
                          _getTopCategoryIndex(categories.length) == y,
                      showTopCategoryName:
                          _getBottomCategoryIndex(categories.length) == y,
                      roundAllBorders: true,
                      isRealData: isRealData,
                    ),
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
        realIndex = (categories[y].places.length - (pageOffset - index)) %
            categories[y].places.length;
      }

      int nearestIndex;
      if (realIndex - realIndex.floor() <= 0.5) {
        nearestIndex = realIndex.floor();
      } else {
        nearestIndex = realIndex.ceil();
      }

      nearestIndex %= categories[y].places.length;

      if (nearestIndex != nearestCurrentPlaceIndexSubjects[y].value) {
        Log.d(_tag, "Set places nearestIndex to $nearestIndex");
        nearestCurrentPlaceIndexSubjects[y].add(nearestIndex);
      }

      if (realIndex.ceil() == realIndex) {
        currentPlaceIndexSubjects[y].add(realIndex.ceil());
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

          return IgnorePointer(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                double opacity;

                if (animation.value <= 0.5) {
                  opacity = (animation.value * 2) * 0.8;
                } else {
                  opacity = (1 - (animation.value - 0.5) * 2) * 0.8;
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
                  color: Provider.of<GoColors>(context).cardTextColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 72,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _onPlaceTap(String categoryName, Place place) {
    Log.d(_tag, "On place tap $place");
    Navigator.pushNamed(
      context,
      PlacePage.routeName,
      arguments: [
        categoryName,
        place,
        _videoController,
        _videoControllerInitializeCallback
      ],
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

//  Future<VideoPlayerController> createVideoPlayerController(String url) async {
  VideoPlayerController createVideoPlayerController(String url) {
    Log.d(_tag, "Create video player controller");

//    return VideoPlayerController.file(await getVideoFileForPath(path))
    return VideoPlayerController.network(url)
      ..setVolume(0.0)
      ..setLooping(true);
  }

//  Future<File> getVideoFileForPath(String uri) async {
//    final taskId = await FlutterDownloader.enqueue(
//      url: 'your download link',
//      savedDir: 'the path of directory where you want to save downloaded files',
//      showNotification: true,
//      // show download progress in status bar (for Android)
//      openFileFromNotification:
//          true, // click on notification to open downloaded file (for Android)
//    );
//
//    return File(path);
//  }

  BuiltList<Category> getStubData() {
    final rand = Random();
    final categories = List.generate(3, (i) {
      final places = List.generate(3, (j) {
        return Place((b) => b
          ..id = "id $i,$j"
          ..price = 100
          ..temperature = 30
          ..name = ""
          ..description = ""
          ..airport = ""
          ..videoUrl = rand.nextBool() ? "" : ""
          ..imageUrl = ""
          ..flightLink = ""
          ..date = "");
      });

      return Category((b) => b
        ..places = ListBuilder(places)
        ..name = "No connection");
    });

    return BuiltList(categories);
  }
}
