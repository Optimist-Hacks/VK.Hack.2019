import 'package:preferences/preference_service.dart';
import 'package:rxdart/rxdart.dart';

class PreferencesService {
  static const String _likedPlaces = "LIKED_PLACES";
  static const String _darkMode = "DARK_MODE";

  final BehaviorSubject<bool> darkModeSubject;

  PreferencesService()
      : darkModeSubject = BehaviorSubject<bool>.seeded(
            PrefService.getBool(_darkMode) ?? false);

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

  void setDarkMode(bool darkMode) {
    PrefService.setBool(_darkMode, darkMode);
    darkModeSubject.add(darkMode);
  }

  bool currentDartMode() {
    return darkModeSubject.value;
  }
}
