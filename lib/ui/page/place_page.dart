import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/service/aviasales_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/images.dart';
import 'package:go_here/ui/strings.dart';
import 'package:go_here/ui/widget/place_card.dart';
import 'package:go_here/utils/log.dart';
import 'package:provider/provider.dart';

const _tag = "place_page";

class PlacePage extends StatefulWidget {
  static const routeName = '/place';
  final Place _place;

  const PlacePage(this._place);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  AviasalesService _aviasalesService;

  @override
  void didChangeDependencies() {
    _aviasalesService ??= Provider.of<AviasalesService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            children: [
              _placeCard(),
              _temperatureAndTravelTime(),
              _description(),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          _buyTicketButton(),
        ],
      ),
    );
  }

  Widget _placeCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.56,
      child: PlaceCard(
        x: 0,
        y: 0,
        categoryName: "anus",
        place: widget._place,
        active: true,
        showBottomCategoryName: false,
        showTopCategoryName: false,
        roundAllBorders: false,
      ),
    );
  }

  Widget _buyTicketButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 60,
          child: RaisedButton(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    Strings.buyATicket,
                    style: TextStyle(
                      fontSize: 19,
                      color: GoColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset(
                    Images.airplane,
                    fit: BoxFit.cover,
                    height: 18,
                    width: 37,
                    color: GoColors.airplane,
                  ),
                ],
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Color(0xFF1B2038),
            onPressed: () => _onBuyPress(),
          ),
        ),
      ),
    );
  }

  Widget _temperatureAndTravelTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _temperature(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
            ),
            _travelTime(),
          ],
        ),
      ),
    );
  }

  Widget _temperature() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget._place.temperature.floor()}°",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: GoColors.black,
            fontSize: 34,
          ),
        ),
        Text(
          Strings.temperature,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: GoColors.black,
            fontSize: 17,
          ),
        )
      ],
    );
  }

  Widget _travelTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: GoColors.black,
          size: 36,
        ),
        Text(
          "In 2 days 1h",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: GoColors.black,
            fontSize: 17,
          ),
        )
      ],
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        widget._place.description,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: GoColors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _onBuyPress() {
    Log.d(_tag, "Buy press ${widget._place}");
    _aviasalesService.openPlaceLink(widget._place);
  }
}
