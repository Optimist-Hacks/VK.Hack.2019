// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Place> _$placeSerializer = new _$PlaceSerializer();

class _$PlaceSerializer implements StructuredSerializer<Place> {
  @override
  final Iterable<Type> types = const [Place, _$Place];
  @override
  final String wireName = 'Place';

  @override
  Iterable<Object> serialize(Serializers serializers, Place object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
      'temperature',
      serializers.serialize(object.temperature,
          specifiedType: const FullType(double)),
      'video',
      serializers.serialize(object.video,
          specifiedType: const FullType(String)),
      'airport',
      serializers.serialize(object.airport,
          specifiedType: const FullType(String)),
      'flightLink',
      serializers.serialize(object.flightLink,
          specifiedType: const FullType(String)),
    ];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Place deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlaceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'temperature':
          result.temperature = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'video':
          result.video = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'airport':
          result.airport = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'flightLink':
          result.flightLink = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Place extends Place {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final double temperature;
  @override
  final String video;
  @override
  final String image;
  @override
  final String airport;
  @override
  final String flightLink;

  factory _$Place([void Function(PlaceBuilder) updates]) =>
      (new PlaceBuilder()..update(updates)).build();

  _$Place._(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.temperature,
      this.video,
      this.image,
      this.airport,
      this.flightLink})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Place', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Place', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Place', 'description');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('Place', 'price');
    }
    if (temperature == null) {
      throw new BuiltValueNullFieldError('Place', 'temperature');
    }
    if (video == null) {
      throw new BuiltValueNullFieldError('Place', 'video');
    }
    if (airport == null) {
      throw new BuiltValueNullFieldError('Place', 'airport');
    }
    if (flightLink == null) {
      throw new BuiltValueNullFieldError('Place', 'flightLink');
    }
  }

  @override
  Place rebuild(void Function(PlaceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaceBuilder toBuilder() => new PlaceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Place &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        temperature == other.temperature &&
        video == other.video &&
        image == other.image &&
        airport == other.airport &&
        flightLink == other.flightLink;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, id.hashCode), name.hashCode),
                                description.hashCode),
                            price.hashCode),
                        temperature.hashCode),
                    video.hashCode),
                image.hashCode),
            airport.hashCode),
        flightLink.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Place')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('temperature', temperature)
          ..add('video', video)
          ..add('image', image)
          ..add('airport', airport)
          ..add('flightLink', flightLink))
        .toString();
  }
}

class PlaceBuilder implements Builder<Place, PlaceBuilder> {
  _$Place _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  double _price;
  double get price => _$this._price;
  set price(double price) => _$this._price = price;

  double _temperature;
  double get temperature => _$this._temperature;
  set temperature(double temperature) => _$this._temperature = temperature;

  String _video;
  String get video => _$this._video;
  set video(String video) => _$this._video = video;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _airport;
  String get airport => _$this._airport;
  set airport(String airport) => _$this._airport = airport;

  String _flightLink;
  String get flightLink => _$this._flightLink;
  set flightLink(String flightLink) => _$this._flightLink = flightLink;

  PlaceBuilder();

  PlaceBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _description = _$v.description;
      _price = _$v.price;
      _temperature = _$v.temperature;
      _video = _$v.video;
      _image = _$v.image;
      _airport = _$v.airport;
      _flightLink = _$v.flightLink;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Place other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Place;
  }

  @override
  void update(void Function(PlaceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Place build() {
    final _$result = _$v ??
        new _$Place._(
            id: id,
            name: name,
            description: description,
            price: price,
            temperature: temperature,
            video: video,
            image: image,
            airport: airport,
            flightLink: flightLink);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
