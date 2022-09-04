import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/others/cover.dart';

part 'artist.freezed.dart';

part 'artist.g.dart';

//https://github.com/MarshalX/yandex-music-api/blob/a30082f492/yandex_music/artist/artist.py
@freezed
class Artist with _$Artist {
  const Artist._();

  const factory Artist({
    required int id,
    String? name,
    String? error,
    Cover? cover,
    @JsonKey(name: 'op_image') String? opImage,
  }) = _Artist;

  String? getCoverImage({String size = '200x200', int index = 0}) {
    return cover != null
        ? cover!.getDownloadUrl()
        : opImage == null
            ? null
            : 'https://${opImage!.replaceAll("%%", size)}';
  }

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
