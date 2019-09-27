import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_here/ui/widget/place_card.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PlaceBloc _placeBloc;

  @override
  void didChangeDependencies() {
    _placeBloc ??= Provider.of<PlaceBloc>(context);
    super.didChangeDependencies();
  }

  PageController pageController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final carousel = CarouselSlider(
      onPageChanged: (i) {
        print("AAAA $i");
      },
      aspectRatio: width / height,
      scrollDirection: Axis.vertical,
      viewportFraction: 0.76,
      items: List.generate(10, (indexY) {
        return CarouselSlider(
          viewportFraction: 0.875,
          aspectRatio: width / height,
          scrollDirection: Axis.horizontal,
          onPageChanged: (i) {
            print("AAAA $i");
          },
          items: List.generate(10, (indexX) {
            return PlaceCard(indexX, indexY, true);
          }),
        );
      }),
    );

    pageController = carousel.pageController;

    pageController.addListener(() {
      print("Event: ${pageController.page}");
    });

    return Scaffold(
      body: Center(
        child: carousel,
      ),
    );
  }
}
