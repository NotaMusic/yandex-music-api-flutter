import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/album/album.dart';
import 'package:yandex_music_api_flutter/others/artist.dart';
import 'package:yandex_music_api_flutter/playlist/playlist.dart';
import 'package:yandex_music_api_flutter/track/track.dart';

part 'best_search.freezed.dart';
part 'best_search.g.dart';

//https://github.com/MarshalX/yandex-music-api/blob/a30082f4929e56381c870cb03103777ae29bcc6b/yandex_music/search/best.py#L23

// """Класс, представляющий лучший результат поиска.
// Attributes:
//     type (:obj:`str`): Тип лучшего результата.
//     result (:obj:`yandex_music.Track` | :obj:`yandex_music.Artist` | :obj:`yandex_music.Album` \
//         | :obj:`yandex_music.Playlist` | :obj:`yandex_music.Video`): Лучший результат.
//     text (:obj:`str`, optional): TODO.
//     client (:obj:`yandex_music.Client`, optional): Клиент Yandex Music.
// """

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
abstract class BestSearch with _$BestSearch {
  @FreezedUnionValue('track')
  factory BestSearch.track({
    required BestSearchType type,
    required Track result,
    String? text,
  }) = _BestSearchTrack;

  @FreezedUnionValue('artist')
  factory BestSearch.artist({
    required BestSearchType type,
    required Artist result,
    String? text,
  }) = _BestSearchArtist;

  @FreezedUnionValue('album')
  factory BestSearch.album({
    required BestSearchType type,
    required Album result,
    String? text,
  }) = _BestSearchAlbum;

  @FreezedUnionValue('playlist')
  factory BestSearch.playlist({
    required BestSearchType type,
    required Playlist result,
    String? text,
  }) = _BestSearchPlaylist;

  ///TODO: VIDEO DTO
  @FreezedUnionValue('video')
  factory BestSearch.video({
    required BestSearchType type,
    required Object result,
    String? text,
  }) = _BestSearchVideo;

  ///TODO: USER DTO
  @FreezedUnionValue('user')
  factory BestSearch.user({
    required BestSearchType type,
    required Object result,
    String? text,
  }) = _BestSearchUser;

  ///TODO: PODCAST DTO
  @FreezedUnionValue('podcast')
  factory BestSearch.podcast({
    required BestSearchType type,
    required Object result,
    String? text,
  }) = _BestSearchPodcast;

  ///TODO: podcast_episode DTO
  @FreezedUnionValue('podcast_episode')
  factory BestSearch.podcastEpisode({
    required BestSearchType type,
    required Object result,
    String? text,
  }) = _BestSearchPodcastEpisode;

  factory BestSearch.fromJson(Map<String, dynamic> json) => _$BestSearchFromJson(json);
}

enum BestSearchType {
  track,
  artist,
  album,
  playlist,
  video,
  user,
  podcast,
  // ignore: constant_identifier_names
  podcast_episode,
}
