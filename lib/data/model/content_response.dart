import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'content_response.g.dart';

abstract class ContentResponse
    implements Built<ContentResponse, ContentResponseBuilder> {
  static Serializer<ContentResponse> get serializer =>
      _$contentResponseSerializer;

  String get downloadLink;

  String get uploadLink;

  ContentResponse._();

  factory ContentResponse([void Function(ContentResponseBuilder) updates]) =
      _$ContentResponse;
}
