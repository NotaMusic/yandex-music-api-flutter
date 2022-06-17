import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';

part 'artist.g.dart';


//https://github.com/MarshalX/yandex-music-api/blob/a30082f492/yandex_music/artist/artist.py
@freezed
class Artist with _$Artist {
  const factory Artist({
    required int id,
    String? name,
    String? error,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
