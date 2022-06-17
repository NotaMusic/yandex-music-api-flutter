import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/rotor/id.dart';
import 'package:yandex_music_api_flutter/rotor/sequence.dart';

part 'station_tracks_result.freezed.dart';

part 'station_tracks_result.g.dart';

@freezed
class StationTracksResult with _$StationTracksResult {
  const factory StationTracksResult({
    required List<Sequence> sequence,
    required Id id,
    required String batchId,
    required bool pumpkin,
  }) = _StationTracksResult;

  factory StationTracksResult.fromJson(Map<String, dynamic> json) =>
      _$StationTracksResultFromJson(json);
}
