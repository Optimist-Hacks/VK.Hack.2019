import 'package:built_collection/built_collection.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/utils/log.dart';
import 'package:rxdart/rxdart.dart';

const _tag = "place_repository";

class PlaceRepository {
  final ApiService _apiService;
  final _categoriesSubject = BehaviorSubject<BuiltList<Category>>();

  Stream<BuiltList<Category>> get categoriesStream => _categoriesSubject;

  PlaceRepository(this._apiService) {
    Log.d(_tag, "init category repository");
    _loadCategories();
  }

  Future<void> _loadCategories() async {
//    Log.d(_tag, "Load categories");

    try {
      final categories = await _apiService.getPlaces();
      if (categories.isEmpty) {
        retryLoadCategories();
      }
      _categoriesSubject.add(BuiltList(categories));
      Log.d(_tag, "${categories.length} categories retrieved");
    } catch (e) {
      _categoriesSubject.addError(e);
      retryLoadCategories();
    }
  }

  void retryLoadCategories() {
    Future.delayed(Duration(seconds: 1), () {
      _loadCategories();
    });
  }
}
