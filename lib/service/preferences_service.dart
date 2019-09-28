import 'package:preferences/preference_service.dart';

class PreferencesService {
  static const String _likedPlaces = "LIKED_PLACES";

  List<String> getLikedPlaces() {
    return PrefService.getStringList(_likedPlaces) ?? List<String>();
  }

  bool isLiked(String placeId) {
    final list = getLikedPlaces();
    return list.contains(placeId);
  }

  void setLikedPlaces(List<String> placesIds) {
    PrefService.setStringList(_likedPlaces, placesIds);
  }

  void addLikedPlace(String placeId) {
    final list = getLikedPlaces();
    list.add(placeId);
    setLikedPlaces(list);
  }

  void removeLikedPlace(String placeId) {
    final list = getLikedPlaces();
    list.remove(placeId);
    setLikedPlaces(list);
  }
}
