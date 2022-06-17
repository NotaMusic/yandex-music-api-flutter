import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/track/track.dart';

part 'sequence.freezed.dart';
part 'sequence.g.dart';

@freezed
class Sequence with _$Sequence {
  const factory Sequence({
    required String type,
    Track? track,
    required bool liked
  }) = _Sequence;



  factory Sequence.fromJson(Map<String, dynamic> json) =>
      _$SequenceFromJson(json);
}