import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:go_here/data/model/place.dart';

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {
  static Serializer<Category> get serializer => _$categorySerializer;

  String get name;

  BuiltList<Place> get places;

  Category._();

  factory Category([void Function(CategoryBuilder) updates]) = _$Category;
}
