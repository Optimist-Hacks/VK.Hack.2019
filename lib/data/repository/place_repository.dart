import 'package:go_here/data/model/category.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/utils/log.dart';
import 'package:rxdart/rxdart.dart';
import 'package:built_collection/built_collection.dart';

const _tag = "place_repository";

class CategoryRepository {
  final ApiService _apiService;
  final _categoriesSubject = BehaviorSubject<BuiltList<Category>>();

  Stream<BuiltList<Category>> get categoriesStream => _categoriesSubject;

  CategoryRepository(this._apiService) {
    Log.d(_tag, "init category repository");
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    Log.d(_tag, "Load categories");
    final places = await _apiService.getPlaces();
    Log.d(_tag, "${places.length} categories retrieved");
    _categoriesSubject.add(places);
  }
}
