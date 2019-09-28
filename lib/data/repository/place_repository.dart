import 'package:built_collection/built_collection.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/model/place.dart';
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
    final realCategories = await _apiService.getPlaces();
//    Log.d(_tag, "${categories.length} categories retrieved");

    final categories = List.generate(5, (i) {
      final places = List.generate(5, (j) {
        return Place((b) => b
          ..id = "id $i,$j"
          ..price = 100
          ..temperature = 30
          ..name = "Place Name $j"
          ..description =
              "Description, laksjdlkajs al;ksdjalk laskndjlka lkajslkdja laksjdlkajs al;ksdjalk laskndjlka lkajslkdja laksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdja laksjdlkajs al;ksdjalk laskndjlka lkajslkdja laksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdjalaksjdlkajs al;ksdjalk laskndjlka lkajslkdja"
          ..airport = "Airport"
          ..video = "video"
          ..flightLink = "http://google.com"
          ..date = "2019-10-10");
      });

      return Category((b) => b
        ..places = ListBuilder(places)
        ..name = "Category Name $i");
    });

    _categoriesSubject.add(BuiltList(categories));
  }
}
