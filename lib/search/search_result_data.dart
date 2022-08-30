import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/album/album.dart';
import 'package:yandex_music_api_flutter/others/artist.dart';
import 'package:yandex_music_api_flutter/track/track.dart';
import 'package:yandex_music_api_flutter/yandex_music_api_flutter.dart';

part 'search_result_data.freezed.dart';
part 'search_result_data.g.dart';



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


@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
abstract class SearchResultData with _$SearchResultData {
   
   @FreezedUnionValue('track')
   factory SearchResultData.tracks({
      required SearchResultType type,
      required int total,
      required List<Track> results,
   }) = _SearchResultTracks;


   @FreezedUnionValue('artist')
   factory SearchResultData.artist({
      required SearchResultType type,
      required int total,
      required List<Artist> results,
   }) = _SearchResultArtist;

   @FreezedUnionValue('playlist')
   factory SearchResultData.playlist({
      required SearchResultType type,
      required int total,
      required List<Playlist> results,
   }) = _SearchResultPlaylist;
   
   @FreezedUnionValue('album')
   factory SearchResultData.albums({
      required SearchResultType type,
      required int total,
      required List<Album> results,
   }) = _SearchResultAlbum;
   
   
   @FreezedUnionValue('video')
   factory SearchResultData.videos({
      required SearchResultType type,
      required int total,
      required List<Object> results,
   }) = _SearchResultVideo;
   
   factory SearchResultData.fromJson(Map<String, dynamic> json) => _$SearchResultDataFromJson(json);
}


enum SearchResultType {
  track, artist, playlist, album, video,
}