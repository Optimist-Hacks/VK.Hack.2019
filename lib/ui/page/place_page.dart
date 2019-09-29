import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/service/aviasales_service.dart';
import 'package:go_here/service/preferences_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/images.dart';
import 'package:go_here/ui/strings.dart';
import 'package:go_here/ui/widget/place_card.dart';
import 'package:go_here/utils/dates.dart';
import 'package:go_here/utils/log.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

const _tag = "place_page";

class PlacePage extends StatefulWidget {
  static const routeName = '/place';

  final String _categoryName;
  final Place _place;
  final VideoPlayerController _videoController;
  final Future<void> _videoControllerInitializeCallback;

  const PlacePage(this._categoryName, this._place, this._videoController,
      this._videoControllerInitializeCallback);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  AviasalesService _aviasalesService;

  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    _aviasalesService ??= Provider.of<AviasalesService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            children: [
              _placeCardAndCloseArrow(),
              _temperatureAndTravelTime(),
              _description(),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          _gradient(),
          _buyTicketButton(),
        ],
      ),
    );
  }

  Widget _gradient() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 132.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Provider.of<GoColors>(context).buyGradientStart,
              Provider.of<GoColors>(context).buyGradientEnd
            ],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _placeCardAndCloseArrow() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.56,
      child: Stack(
        children: <Widget>[
          _placeCard(),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (_scrollController.offset == 0) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                color: Colors.transparent,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(
                        Images.downArrow,
                        fit: BoxFit.contain,
                        height: 9,
                        width: 26,
                        color: Provider.of<GoColors>(context).cardTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeCard() {
    return Hero(
      tag: widget._place.id,
      child: PlaceCard(
        Provider.of<PreferencesService>(context),
        categoryName: widget._categoryName,
        place: widget._place,
        active: true,
        videoController: widget._videoController,
        videoControllerInitializeCallback:
            widget._videoControllerInitializeCallback,
        showBottomCategoryName: false,
        showTopCategoryName: false,
        roundAllBorders: false,
        isRealData: true,
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
                      color: Provider.of<GoColors>(context).buyTextColor,
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
                    color: Provider.of<GoColors>(context).airplane,
                  ),
                ],
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Provider.of<GoColors>(context).buyTicketBackgroundColor,
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
            color: Provider.of<GoColors>(context).placeInfoTextColor,
            fontSize: 34,
          ),
        ),
        Text(
          Strings.temperature,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Provider.of<GoColors>(context).placeInfoTextColor,
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
        SvgPicture.asset(
          Images.clock,
          fit: BoxFit.cover,
          height: 27,
          width: 27,
        ),
        Text(
          Dates.getTimeBefore(widget._place.date),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Provider.of<GoColors>(context).placeInfoTextColor,
            fontSize: 17,
          ),
        )
      ],
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Text(
        widget._place.description,
        textAlign: TextAlign.left,
        style: TextStyle(
          height: 1.72,
          fontWeight: FontWeight.normal,
          color: Provider.of<GoColors>(context).placeInfoTextColor,
          fontSize: 17.0,
        ),
      ),
    );
  }

  void _onBuyPress() {
    Log.d(_tag, "Buy press ${widget._place}");
    _aviasalesService.openPlaceLink(widget._place);
  }
}
