import 'package:go_here/data/model/place.dart';
import 'package:go_here/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';

const _tag = "aviasales_service";

class AviasalesService {
  Future<void> openPlaceLink(Place place) async {
    Log.d(_tag, "Open place $place");
    if (await canLaunch(place.flightLink)) {
      Log.e(_tag, "Try to open url ${place.flightLink}");
      await launch(place.flightLink);
    } else {
      Log.e(_tag, "Can't open url ${place.flightLink}");
    }
  }
}
