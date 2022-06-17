import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/yandex_music_api_flutter.dart';

part 'track_download_info.freezed.dart';

part 'track_download_info.g.dart';

@freezed
class TrackDownloadInfo with _$TrackDownloadInfo {

  const TrackDownloadInfo._();

  const factory TrackDownloadInfo({
    @Default('') String codec,
    @Default(false) bool gain,
    @Default(false) bool preview,
    @Default('') String downloadInfoUrl,
    @Default(false) bool direct,
    @Default(0) int bitrateInKbps,
  }) = _TrackDownloadInfo;

  factory TrackDownloadInfo.fromJson(Map<String, Object?> json) =>
      _$TrackDownloadInfoFromJson(json);

  Future<String?> getTrackDownloadUrl() =>
      Client.instance.getTrackDownloadUrl(this);
}
