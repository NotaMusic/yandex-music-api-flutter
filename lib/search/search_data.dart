import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/search/best_search.dart';
import 'package:yandex_music_api_flutter/search/search_result_data.dart';

part 'search_data.freezed.dart';
// part 'search_data.g.dart';

/// Attributes:
///        search_request_id (:obj:`str`): ID запроса.
///        text (:obj:`str`): Текст запроса.
///        best (:obj:`yandex_music.Best`, optional): Лучший результат.
///        albums (:obj:`yandex_music.SearchResult`, optional): Найденные альбомы.
///        artists (:obj:`yandex_music.SearchResult`, optional): Найденные исполнители.
///        playlists (:obj:`yandex_music.SearchResult`, optional): Найденные плейлисты.
///        tracks (:obj:`yandex_music.SearchResult`, optional): Найденные треки.
///        videos (:obj:`yandex_music.SearchResult`, optional): Найденные видео.
///        users (:obj:`yandex_music.SearchResult`, optional): Найденные пользователи.
///        podcasts (:obj:`yandex_music.SearchResult`, optional): Найденные подкасты.
///        podcast_episodes (:obj:`yandex_music.SearchResult`, optional): Найденные выпуски подкастов.
///        type (:obj:`str`), optional: Тип результата по которому искали (аргумент в Client.search).
///        page (:obj:`int`, optional): Текущая страница.
///        per_page (:obj:`int`, optional): Результатов на странице.
///        misspell_result (:obj:`str`, optional): Запрос с автоматическим исправлением.
///        misspell_original (:obj:`str`, optional): Оригинальный запрос.
///        misspell_corrected (:obj:`bool`, optional): Был ли исправлен запрос.
///        nocorrect (:obj:`bool`, optional): Было ли отключено исправление результата.
///        client (:obj:`yandex_music.Client`, optional): Клиент Yandex Music.
@Freezed(fromJson: false)
class SearchData with _$SearchData {
  const SearchData._();

  const factory SearchData({
    String? id,
    required String text,
    BestSearch? best,
    SearchResultData? albums,
    SearchResultData? artists,
    SearchResultData? playlists,
    SearchResultData? tracks,
    //SearchResultData? videos,
    //SearchResultData? users,
    //SearchResultData? podcasts
    //SearchResultData? podcast_episodes,
    String? type,
    int? page,
    int? perPage,
    String? misspellResult,
    String? misspellOriginal,
    bool? misspellCorrected,
    @Default(false) bool nocorrect,
  }) = _SearchData;

  List<SearchResultData> notNullResults() {
    return [
      if (albums != null) albums!,
      if (artists != null) artists!,
      if (playlists != null) playlists!,
      if (tracks != null) tracks!,
    ];
  }

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      id: json['id'],
      text: json['text'],
      best: BestSearch.fromJson(json['best']),
      albums: SearchResultData.fromJson(json['albums'], type: SearchResultType.album),
      artists: SearchResultData.fromJson(json['artists'], type: SearchResultType.artist),
      playlists: SearchResultData.fromJson(json['playlists'], type: SearchResultType.playlist),
      tracks: SearchResultData.fromJson(json['tracks'], type: SearchResultType.track),
      type: json['type'],
      page: json['page'],
      perPage: json['perPage'],
      misspellResult: json['misspellResult'],
      misspellOriginal: json['misspellOriginal'],
      misspellCorrected: json['misspellCorrected'],
      nocorrect: json['nocorrect'],
    );
  }
}
