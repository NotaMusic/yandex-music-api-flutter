import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/rotor/station.dart';

part 'station_result.freezed.dart';

part 'station_result.g.dart';

@freezed
class StationResult with _$StationResult {
  const factory StationResult({Station? station}) = _StationResult;

  factory StationResult.fromJson(Map<String, dynamic> json) =>
      _$StationResultFromJson(json);
}
