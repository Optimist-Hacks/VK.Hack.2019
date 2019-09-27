import 'package:go_here/data/model/place.dart';
import 'package:go_here/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';

const _tag = "aviasales_service";

class AviasalesService {
  Future<void> openPlaceLink(Place place) async {
    Log.d(_tag, "Open place $place");
    final url = "https://www.aviasales.ru/search/LED2809${place.airport}1";
    if (await canLaunch(url)) {
      Log.e(_tag, "Try to open url $url");
      await launch(url);
    } else {
      Log.e(_tag, "Can't open url $url");
    }
  }
}
