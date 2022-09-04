// ignore_for_file: empty_catches

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/album/album.dart';
import 'package:yandex_music_api_flutter/others/artist.dart';
import 'package:yandex_music_api_flutter/track/track.dart';
import 'package:yandex_music_api_flutter/track/track_short.dart';
import 'package:yandex_music_api_flutter/yandex_music_api_flutter.dart';

part 'search_result_data.freezed.dart';
// part 'search_result_data.g.dart';

//  """Класс, представляющий результаты поиска.
//     Note:
//         Значения поля `type`: `track`, `artist`, `playlist`, `album`, `video`.
//     Attributes:
//         type (:obj:`str`):  Тип результата.
//         total (:obj:`int`): Количество результатов.
//         per_page (:obj:`int`): Максимальное количество результатов на странице.
//         order (:obj:`int`): Позиция блока.
//         results (:obj:`list` из :obj:`yandex_music.Track` | :obj:`yandex_music.Artist` | :obj:`yandex_music.Album` \
//             | :obj:`yandex_music.Playlist` | :obj:`yandex_music.Video`): Результаты поиска.
//         client (:obj:`yandex_music.Client`, optional): Клиент Yandex Music.
//     """

@Freezed(fromJson: false)
class SearchResultData with _$SearchResultData {
  const SearchResultData._();

  factory SearchResultData.tracks({
    required SearchResultType type,
    required int total,
    required List<Track> results,
  }) = _SearchResultTracks;

  factory SearchResultData.artist({
    required SearchResultType type,
    required int total,
    required List<Artist> results,
  }) = _SearchResultArtist;

  factory SearchResultData.playlist({
    required SearchResultType type,
    required int total,
    required List<Playlist> results,
  }) = _SearchResultPlaylist;

  factory SearchResultData.albums({
    required SearchResultType type,
    required int total,
    required List<Album> results,
  }) = _SearchResultAlbum;

  factory SearchResultData.videos({
    required SearchResultType type,
    required int total,
    required List<Object> results,
  }) = _SearchResultVideo;

  factory SearchResultData({
    required SearchResultType? type,
    required int total,
    required List<Object?> results,
  }) = _SearchResultEmpty;

  int getCountFromList() => map(
        (_) => 0,
        tracks: (e) => e.results.length,
        artist: (e) => e.results.length,
        playlist: (e) => e.results.length,
        albums: (e) => e.results.length,
        videos: (e) => e.results.length,
      );

  factory SearchResultData.fromJson(Map<String, dynamic> json, {SearchResultType? type}) {
    final firstItem = (json['results'] as List).first;

    try {
      if (type != null) {
        if (type == SearchResultType.track) {
          return SearchResultData.tracks(
            type: SearchResultType.track,
            total: json['total'],
            results: (json['results'] as List).map((e) => Track.fromJson(e)).toList(),
          );
        }

        if (type == SearchResultType.artist) {
          return SearchResultData.artist(
            type: SearchResultType.artist,
            total: json['total'],
            results: (json['results'] as List).map((e) => Artist.fromJson(e)).toList(),
          );
        }

        if (type == SearchResultType.playlist) {
          return SearchResultData.playlist(
            type: SearchResultType.playlist,
            total: json['total'],
            results: (json['results'] as List).map((e) => Playlist.fromJson(e)).toList(),
          );
        }

        if (type == SearchResultType.album) {
          return SearchResultData.albums(
            type: SearchResultType.album,
            total: json['total'],
            results: (json['results'] as List).map((e) => Album.fromJson(e)).toList(),
          );
        }
      }
    } catch (ex) {
      if(kDebugMode){
        print('error try parse strong ${type.toString()}: ${ex.toString()}');
      }
    }

    try {
      Track.fromJson(firstItem);

      return SearchResultData.tracks(
        type: SearchResultType.track,
        total: json['total'],
        results: (json['results'] as List).map((e) => Track.fromJson(e)).toList(),
      );
    } catch (ex) {}

    try {
      Artist.fromJson(firstItem);

      return SearchResultData.artist(
        type: SearchResultType.artist,
        total: json['total'],
        results: (json['results'] as List).map((e) => Artist.fromJson(e)).toList(),
      );
    } catch (ex) {}

    try {
      Playlist.fromJson(firstItem);

      return SearchResultData.playlist(
        type: SearchResultType.playlist,
        total: json['total'],
        results: (json['results'] as List).map((e) => Playlist.fromJson(e)).toList(),
      );
    } catch (ex) {}

    try {
      Album.fromJson(firstItem);

      return SearchResultData.albums(
        type: SearchResultType.album,
        total: json['total'],
        results: (json['results'] as List).map((e) => Album.fromJson(e)).toList(),
      );
    } catch (ex) {}

    return SearchResultData(
      type: SearchResultType.video,
      total: json['total'],
      results: [],
    );
  }
}

enum SearchResultType {
  track,
  artist,
  playlist,
  album,
  video,
}
