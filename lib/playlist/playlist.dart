import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/others/cover.dart';
import 'package:yandex_music_api_flutter/track/track.dart';
import 'package:yandex_music_api_flutter/track/track_short.dart';

part 'playlist.freezed.dart';

part 'playlist.g.dart';

//https://github.com/MarshalX/yandex-music-api/blob/a30082f492/yandex_music/playlist/playlist.py
@freezed
class Playlist with _$Playlist {
  const Playlist._();

  const factory Playlist({
    ///Обложка
    Cover? cover,

    ///Id владельца плейлиста
    int? uid,

    ///id Плейлиста
    int? kind,

    ///Название плейлиста
    String? title,

    /// Количество треков в плейлисте
    int? trackCount,

    ///Обложка
    String? image,

    // треки
    List<TrackShort>? tracks,
// tracks (:obj:`list` из :obj:`yandex_music.TrackShort`, optional): Список треков.
  }) = _Playlist;

  String? getCoverImage({String size = '200x200', int index = 0}) {
     return cover?.getDownloadUrl(size: size, index: index);
  }

  factory Playlist.fromJson(Map<String, Object?> json) =>
      _$PlaylistFromJson(json);
}
