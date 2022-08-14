import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/track/track.dart';

part 'track_short.freezed.dart';

part 'track_short.g.dart';

@freezed
class TrackShort with _$TrackShort {
  const TrackShort._();

  const factory TrackShort({
    required int id,
    required String timestamp,
    int? albumId,
    Track? track,
  }) = _TrackShort;

  ///Уникальный идентификатор трека состоящий из его номера и номера альбома или просто из номера.
  String getTrackId() {
    if (albumId != null) {
      return '$id:$albumId';
    }
    return id.toString();
  }

  Future<String?>? getDownloadUrl() => track?.getDownloadUrl();

  factory TrackShort.fromJson(Map<String, dynamic> json) =>
      _$TrackShortFromJson(json);
}
