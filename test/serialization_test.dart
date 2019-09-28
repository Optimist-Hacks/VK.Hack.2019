import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/serializer/serializers.dart';

void main() {
  test("Categories deserialize", () {
    final json = jsonDecode('['
        '    {'
        ' "name":"categoryName",'
        '"places":['
        '{'
        '"id":"id",'
        '"name":"placeName",'
        '"description":"description",'
        '"price":10.0,'
        '"temperature":20.0,'
        '"video":"url",'
        '"airport":"LED"'
        '}'
        ']'
        '}'
        ']');
    final openTiles = deserializeListOf<Category>(json);
    expect(openTiles.length, equals(1));
    expect(openTiles.first.name, "categoryName");
    expect(openTiles.first.places.length, equals(1));
    expect(openTiles.first.places.first.id, equals("id"));
    expect(openTiles.first.places.first.description, equals("description"));
    expect(openTiles.first.places.first.price, equals(10.0));
    expect(openTiles.first.places.first.temperature, equals(20.0));
    expect(openTiles.first.places.first.videoUrl, "url");
    expect(openTiles.first.places.first.airport, "LED");
  });
}
