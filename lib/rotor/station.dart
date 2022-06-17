import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/client.dart';
import 'package:yandex_music_api_flutter/rotor/id.dart';
import 'package:yandex_music_api_flutter/rotor/station_tracks_result.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
class Station with _$Station {
  const Station._();

  const factory Station({
    required Id id,
    required String name,
    required String idForFrom,
    String? fullImageUrl,
    Id? parentId,
  }) = _Station;

  String get stationStringId => "${id.type}:${id.tag}";

  Future<StationTracksResult?> getTracksRes() =>
      Client.instance.getRotorStationTracks(station: stationStringId);

  String? getCoverImage({String size = '200x200', int index = 0}) {
    return fullImageUrl == null ? null : 'https://${fullImageUrl!.replaceAll("%%", size)}';
  }

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
}
