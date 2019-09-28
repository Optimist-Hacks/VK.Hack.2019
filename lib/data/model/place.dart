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

  @BuiltValueField(wireName: "video")
  String get videoUrl;

  @BuiltValueField(wireName: "image")
  String get imageUrl;

  String get airport;

  String get flightLink;

  String get date;

  Place._();

  factory Place([void Function(PlaceBuilder) updates]) = _$Place;
}
