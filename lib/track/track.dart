
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/others/artist.dart';
import 'package:yandex_music_api_flutter/yandex_music_api_flutter.dart';

part 'track.freezed.dart';
part 'track.g.dart';

//https://github.com/MarshalX/yandex-music-api/blob/a30082f492/yandex_music/track/track.py
@freezed
class Track with _$Track {

  const Track._();

  const factory Track({
    required String id,
    required String title,
    String? albumId,
    String? coverUri,
    List<Artist>? artists,
    @Default(false) bool explicit,
    @Default(false) bool best,
    //for podcasts
    String? shortDescription, 
  }) = _Track;

  String? getCoverImage({String size = '200x200', int index = 0}) {
    return coverUri == null ? null : 'https://${coverUri!.replaceAll("%%", size)}';
  }

  Future<String?> getDownloadUrl() async{
    final data = await Client.instance.getTrackDownloadInfo(id);
    if(data == null) return null;
    return Client.instance.getTrackDownloadUrl(data);
  }

  factory Track.fromJson(Map<String, dynamic> json) =>
      _$TrackFromJson(json);
}