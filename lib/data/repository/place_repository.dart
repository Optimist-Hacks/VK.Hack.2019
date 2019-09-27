import 'package:go_here/data/model/category.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/utils/log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:built_collection/built_collection.dart';

const _tag = "place_repository";

class PlaceRepository {
  final ApiService _apiService;
  final _categorySubject = BehaviorSubject<BuiltList<Category>>();

  Stream<BuiltList<Category>> get categoryStream => _categorySubject;

  PlaceRepository(this._apiService) {
    Log.d(_tag, "init place repository");
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    Log.d(_tag, "Load places");
    final places = await _apiService.getPlaces();
    Log.d(_tag, "Load ${places.length} categories");
    _categorySubject.add(places);
  }
}
