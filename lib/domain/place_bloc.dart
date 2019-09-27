import 'dart:async';

import 'package:go_here/data/model/place.dart';
import 'package:go_here/data/repository/place_repository.dart';
import 'package:built_collection/built_collection.dart';

const _tag = "place_bloc";

class PlaceBloc {
  final PlaceRepository _placeRepository;

  Stream<BuiltList<Place>> get placeStream => _placeRepository.placeStream;

  PlaceBloc(this._placeRepository);
}
