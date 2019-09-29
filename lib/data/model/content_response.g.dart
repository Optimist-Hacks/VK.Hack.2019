// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ContentResponse> _$contentResponseSerializer =
    new _$ContentResponseSerializer();

class _$ContentResponseSerializer
    implements StructuredSerializer<ContentResponse> {
  @override
  final Iterable<Type> types = const [ContentResponse, _$ContentResponse];
  @override
  final String wireName = 'ContentResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, ContentResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'downloadLink',
      serializers.serialize(object.downloadLink,
          specifiedType: const FullType(String)),
      'uploadLink',
      serializers.serialize(object.uploadLink,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ContentResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ContentResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'downloadLink':
          result.downloadLink = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'uploadLink':
          result.uploadLink = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ContentResponse extends ContentResponse {
  @override
  final String downloadLink;
  @override
  final String uploadLink;

  factory _$ContentResponse([void Function(ContentResponseBuilder) updates]) =>
      (new ContentResponseBuilder()..update(updates)).build();

  _$ContentResponse._({this.downloadLink, this.uploadLink}) : super._() {
    if (downloadLink == null) {
      throw new BuiltValueNullFieldError('ContentResponse', 'downloadLink');
    }
    if (uploadLink == null) {
      throw new BuiltValueNullFieldError('ContentResponse', 'uploadLink');
    }
  }

  @override
  ContentResponse rebuild(void Function(ContentResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentResponseBuilder toBuilder() =>
      new ContentResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentResponse &&
        downloadLink == other.downloadLink &&
        uploadLink == other.uploadLink;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, downloadLink.hashCode), uploadLink.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ContentResponse')
          ..add('downloadLink', downloadLink)
          ..add('uploadLink', uploadLink))
        .toString();
  }
}

class ContentResponseBuilder
    implements Builder<ContentResponse, ContentResponseBuilder> {
  _$ContentResponse _$v;

  String _downloadLink;
  String get downloadLink => _$this._downloadLink;
  set downloadLink(String downloadLink) => _$this._downloadLink = downloadLink;

  String _uploadLink;
  String get uploadLink => _$this._uploadLink;
  set uploadLink(String uploadLink) => _$this._uploadLink = uploadLink;

  ContentResponseBuilder();

  ContentResponseBuilder get _$this {
    if (_$v != null) {
      _downloadLink = _$v.downloadLink;
      _uploadLink = _$v.uploadLink;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ContentResponse;
  }

  @override
  void update(void Function(ContentResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ContentResponse build() {
    final _$result = _$v ??
        new _$ContentResponse._(
            downloadLink: downloadLink, uploadLink: uploadLink);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
