import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'place.g.dart';

abstract class Place implements Built<Place, PlaceBuilder> {
  static Serializer<Place> get serializer => _$placeSerializer;

  String get id;

  String get name;

  String get description;

  double get price;

  double get temperature;

  String get video;

  @nullable
  String get image;

  String get airport;

  Place._();

  factory Place([void Function(PlaceBuilder) updates]) = _$Place;
}
