import 'dart:convert' show utf8;

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:yandex_music_api_flutter/search/search_data.dart';
import 'package:yandex_music_api_flutter/search/search_req_arg.dart';
import 'package:yandex_music_api_flutter/track/track.dart';
import 'package:yandex_music_api_flutter/yandex_music_api_flutter.dart';

typedef CaptchaCallback = Future<String> Function(String);

class Client {
  static const String defaultBaseUrl = 'https://api.music.yandex.net';
  static const String defaultOAuthUrl = 'https://oauth.yandex.ru';
  static const String defaultClientId = '23cabbbdc6cd418abb4b39c32c41195d';
  static const String defaultClientSecret = '53bc75238f0c4d08a118e51fe9203300';

  //https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d
  static const String authSdkParams = 'app_id=ru.yandex.mobile.music&app_version_name=5.18&app_platform=iPad';

  final String baseUrl;
  final String oAuthUrl;
  final String clientId;
  final String clientSecret;

  String? token;
  final String device;
  final void Function(Object)? debugPrint;

  late final Dio _client = Dio();

  static Client? _instanceRef;

  static Client get instance => _instanceRef ?? Client();

  //some refts https://github.com/MarshalX/yandex-music-api/tree/1fc342183ba59e4d1c47b6d8ae5ac6afe46d6a14/yandex_music

  Client({
    this.baseUrl = defaultBaseUrl,
    this.oAuthUrl = defaultOAuthUrl,
    this.clientId = defaultClientId,
    this.clientSecret = defaultClientSecret,
    this.device = 'os=Flutter; os_version=; manufacturer=Marshal; '
        'model=Yandex Music API; clid=; device_id=random; uuid=random',
    this.token,
    this.debugPrint,
  }) {
    if (_instanceRef == null) {
      _client.interceptors.add(LogInterceptor(
        requestHeader: true,
        responseHeader: true,
        requestBody: true,
        responseBody: true,
        logPrint: debugPrint ?? print,
      ));
    }
    _instanceRef = this;
  }

  Future<Status> getAccountStatus() async {
    final resp = await _client.get('$baseUrl/account/status');
    return Status.fromJson(resp.data['result']);
  }

  Future<Status> getAccountRotorStatus() async {
    final resp = await _client.get('$baseUrl/rotor/account/status');
    return Status.fromJson(resp.data['result']);
  }

  void setTokenForClient(String token) {
    this.token = token;
    _client.interceptors.removeWhere((element) => element is DioMusicInterceptor);
    _client.interceptors.add(DioMusicInterceptor(token: token));
  }

  /*
  Отправка ответной реакции на происходящее при прослушивании радио.
        Note:
            Сообщения о начале прослушивания радио, начале и конце трека, его пропуска.
            Известные типы фидбека: `radioStarted`, `trackStarted`, `trackFinished`, `skip`.
            Пример `station`: `user:onyourwave`, `genre:allrock`.
            Пример `from_`: `mobile-radio-user-123456789`.
        Args:
            station (:obj:`str`): Станция.
            type_ (:obj:`str`): Тип отправляемого фидбека.
            timestamp (:obj:`str` | :obj:`float` | :obj:`int`, optional): Текущее время и дата.
            from_ (:obj:`str`, optional): Откуда начато воспроизведение радио.
            batch_id (:obj:`str`, optional): Уникальный идентификатор партии треков. Возвращается при получении треков.
            total_played_seconds (:obj:`int` |:obj:`float`, optional): Сколько было проиграно секунд трека
                перед действием.
            track_id (:obj:`int` | :obj:`str`, optional): Уникальной идентификатор трека.
  */
  Future<bool> rotorStationFeedback({
    required Station station,
    required StationFeedback feedback,
    DateTime? timestamp,
    String? from,
    String? totalPlayerSeconds,
    String? batchId,
    String? trackId,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    var _timestamp = (timestamp ?? DateTime.now()).millisecondsSinceEpoch.toString();
    final data = {
      'timestamp':
          "${_timestamp.substring(0, _timestamp.length - 5)}.${_timestamp.substring(_timestamp.length - 4, _timestamp.length)}",
      if (batchId != null) 'batch-id': batchId,
      if (trackId != null) 'trackId': trackId,
      if (from != null) 'from': from,
      if (totalPlayerSeconds != null) 'totalPlaySeconds': totalPlayerSeconds,
    };

    final resp = await _client.post(
      "$baseUrl/rotor/station/${station.stationStringId}/feedback",
      data: data,
    );
    return resp.statusCode == 200;
  }

  ///получение пользовательско плейлиста[ов]
  Future<List<Playlist>?> getUsersPlaylist({required String userId, String? kind}) async {
    String url;
    if (kind != null) {
      url = '$baseUrl/users/$userId/playlists/$kind';
    } else {
      url = '$baseUrl/users/$userId/playlists';
    }
    final response = (await _client.get(url));
    if (response.data['result'] == null) return null;
    return response is List
        ? response.data['result'].map((e) => Playlist.fromJson(e)).toList()
        : [Playlist.fromJson(response.data['result'])];
  }

  ///Получение информации для скачивания трека по его id
  Future<TrackDownloadInfo?> getTrackDownloadInfo(String trackId) async {
    final resp = await _client.get('$baseUrl/tracks/$trackId/download-info');
    final data = resp.data['result'][0];
    return data == null ? null : TrackDownloadInfo.fromJson(data);
  }

  ///Получение прямой ссылки на трек основываясь на [TrackDownloadInfo]
  Future<String?> getTrackDownloadUrl(TrackDownloadInfo downloadInfo) async {
    final xmlData = await Dio().get(downloadInfo.downloadInfoUrl);
    final doc = XmlDocument.parse(xmlData.data).children[1];

    final host = doc.getElement('host')?.text;
    final path = doc.getElement('path')?.text;
    final ts = doc.getElement('ts')?.text;
    final s = doc.getElement('s')?.text;

    if (host == null || path == null || ts == null || s == null) {
      return null;
    }

    final encPath = utf8.encode('XGRlBW9FXlekgbPrRHuSiA$path$s');
    final sign = await md5.bind(Stream.fromIterable([encPath])).first;
    return 'https://$host/get-mp3/$sign/$ts$path';
  }

  Future<List<StationResult>?> getRotorStationList({String language = 'ru'}) async {
    final resp = await _client.get(
      '$baseUrl/rotor/stations/list',
      queryParameters: {'language': language},
    );
    return (resp.data['result'] as List).map((e) => StationResult.fromJson(e)).toList();
  }

  ///Получение цепочки треков определённой станции.
  //         Note:
  //             Запуск потока по сущности сервиса осуществляется через станцию `<type>:<id>`.
  //             Например, станцией для запуска потока по треку будет `track:1234`.
  //             Для продолжения цепочки треков необходимо:
  //             1. Передавать `ID` трека, что был до этого (первый в цепочки).
  //             2. Отправить фидбек о конче или скипе трека, что был передан в `queue`.
  //             3. Отправить фидбек о начале следующего трека (второй в цепочки).
  //             4. Выполнить запрос получения треков. В ответе придёт новые треки или произойдёт сдвиг цепочки на 1 элемент.
  //             Проход по цепочке до коцна не изучен. Часто встречаются дубликаты.
  //             Все официальные клиенты выполняют запросы с `settings2 = True`.
  /// Args:
  //             station (:obj:`str`): Станция.
  //             settings2 (:obj:`bool`, optional): Использовать ли второй набор настроек.
  //             queue (:obj:`str` | :obj:`int` , optional): Уникальной идентификатор трека, который только что был.
  Future<StationTracksResult?> getRotorStationTracks({
    required String station,
    String? queue,
  }) async {
    final resp = await _client.get('$baseUrl/rotor/station/$station/tracks', queryParameters: {
      'settings2': true,
      if (queue != null) 'queue': queue,
    });

    return StationTracksResult.fromJson(resp.data['result']);
  }

  ///Получение списка плейлистов пользователя.
  Future<List<Playlist>?> usersPlaylistsList(
    String userId, {
    List<String>? kind,
  }) async {
    if (kind == null) {
      final resp = await _client.get('$baseUrl/users/$userId/playlists/list');
      return (resp.data['result'] as List).map((e) => Playlist.fromJson(e)).toList();
    } else {
      final resp = await _client.post(
        '$baseUrl/users/$userId/playlists',
        data: {'kinds': kind},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return (resp.data['result'] as List).map((e) => Playlist.fromJson(e)).toList();
    }
  }

  Future<List<Playlist>?> playlistList(List<String> playlistsId) async {
    final resp = await _client.post(
      "$baseUrl/playlists/list",
      data: {
        'playlistIds': playlistsId,
        'playlist-ids': playlistsId,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return (resp.data['result'] as List).map((e) => Playlist.fromJson(e)).toList();
  }

  Future<List<Track>> tracksList(List<String> tracksId) async {
    final resp = await _client.post(
      "$baseUrl/tracks",
      data: {
        'trackIds': tracksId,
        'track-ids': tracksId,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return (resp.data['result'] as List).map((e) => Track.fromJson(e)).toList();
  }

  Future<List<Like>> getLikes({
    required LikeType type,
    required String userId,
  }) async {
    final resp = await _client.get("$baseUrl/users/$userId/likes/${type.name}s");
    //TODO  if object_type == 'track':
    // return TracksList.de_json(result.get('library'), self)
    return (resp.data['result'] as List).map((e) => Like.fromJson(e)).toList();
  }

  Future<SearchData?> search(SearchReqArg arg) async {
    final resp = await _client.get("$baseUrl/search", queryParameters: arg.toJson());
    if (resp.statusCode == 200) {
      return SearchData.fromJson(resp.data['result']);
    } else {
      return null;
    }
  }
}
