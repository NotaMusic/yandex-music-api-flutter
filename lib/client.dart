import 'dart:convert' show utf8;

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:yandex_music_api_flutter/account/status.dart';
import 'package:yandex_music_api_flutter/dio_music_interceptor.dart';
import 'package:yandex_music_api_flutter/playlist/playlist.dart';
import 'package:yandex_music_api_flutter/rotor/station_feedback.dart';
import 'package:yandex_music_api_flutter/rotor/station_tracks_result.dart';
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
    return Status.fromJson(resp.data);
  }

//  @log
//     def account_status(self, timeout: Union[int, float] = None, *args, **kwargs) -> Optional[Status]:
//         """Получение статуса аккаунта. Нет обязательных параметров.
//         Args:
//             timeout (:obj:`int` | :obj:`float`, optional): Если это значение указано, используется как время ожидания
//                 ответа от сервера вместо указанного при создании пула.
//             **kwargs (:obj:`dict`, optional): Произвольные аргументы (будут переданы в запрос).
//         Returns:
//             :obj:`yandex_music.Status` | :obj:`None`: Информация об аккаунте если он валиден, иначе :obj:`None`.
//         Raises:
//             :class:`yandex_music.exceptions.YandexMusicError`: Базовое исключение библиотеки.
//         """

//         url = f'{self.base_url}/account/status'

//         result = self._request.get(url, timeout=timeout, *args, **kwargs)

//         return Status.de_json(result, self)

/*
  Future<String> fromCredential(
    String login,
    String pass,
    CaptchaCallback captchaCallback, {
    String? trackId,
    String? xCaptchaAnswer,
    String? xCaptchaKey,
  }) async {
    late String nTrackId;
    if (trackId == null) {
      nTrackId = await _startAuth(login);
    } else {
      nTrackId = trackId;
    }

    // ignore: avoid_init_to_null
    String? xToken = null;
    String? captchaAnswer = xCaptchaAnswer;

    while (xToken == null) {
      try {
        xToken = await _sendAuthPassword(pass: pass, trackId: nTrackId, captchaAnswer: captchaAnswer);
      } catch (ex) {
        if (ex is CaptchaRequired) {
          captchaAnswer = await captchaCallback(ex.captchaUrl);
        } else {
          rethrow;
        }
      }
    }
    return _generateYandexMusicTokenByXToken(xToken);

    // x_token = None
    //     while not x_token:
    //         try:
    //             x_token = client._send_authentication_password(
    //                 track_id, password, captcha_answer, timeout, *args, **kwargs
    //             )
    //         except Captcha as e:
    //             if not captcha_callback or not e.captcha_image_url:
    //                 raise e

    //             captcha_answer = captcha_callback(e.captcha_image_url)

    //     token = client._generate_yandex_music_token_by_x_token(x_token, timeout, *args, **kwargs)
    //     return cls(token, *args, **kwargs)
  }

  /// method for start id - returns [track_id] - id of authorization
  Future<String> _startAuth(String login) async {
    final data = {
      'client_id': clientId,
      'client_secret': clientSecret,
      'display_language': 'ru',
      'login': login,
      'x_token_client_id': X_TOKEN_CLIENT_ID,
      'x_token_client_secret': X_TOKEN_CLIENT_SECRET,
    };

    //["display_language.empty","login.empty","x_token_client_id.empty","x_token_client_secret.empty"]}

    final resp = await _client.post(
      '$passportUrl/2/bundle/mobile/start',
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (resp.data != null) {
      return resp.data['track_id'];
    } else {
      throw BaseYamusicException();
    }
  }

  Future<String> _sendAuthPassword({
    required String trackId,
    required String pass,
    String? captchaAnswer,
  }) async {
    final data = {
      'track_id': trackId,
      'password': pass,
    };

    if (captchaAnswer != null) {
      data['captcha_answer'] = captchaAnswer;
    }

    final resp = await _client.post(
      '$passportUrl/1/bundle/mobile/auth/password',
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (resp.statusMessage == 'ok' || resp.statusCode == 200) {
      return resp.data['x_token'];
    } else {
      switch (resp.statusMessage) {
        case 'password.not_matched':
          throw PasswordNotMatch();

        case 'captcha.required':
          throw CaptchaRequired(trackId, resp.data['captcha_image_url']);

        case 'captcha.not_shown':
          throw CaptchaNotShown(trackId);
        default:
          throw BaseYamusicException();
      }
    }
  }

  // Future<String> loginWithLoginAndPass(
  //   String login,
  //   String pass, {
  //   String grantType = 'password',
  //   String? xCaptchaAnswer,
  //   String? xCaptchaKey,
  // }) async {
  //   final data = {
  //     'grant_type': grantType,
  //     'client_id': clientId,
  //     'client_secret': clientSecret,
  //     'username': login,
  //     'password': pass,
  //     if (xCaptchaAnswer != null) 'x_captcha_answer': xCaptchaAnswer,
  //     if (xCaptchaKey != null) 'x_captcha_key': xCaptchaKey,
  //   };

  //   final resp = await _client.post(
  //     '$oAuthUrl/token',
  //     data: data,
  //     options: Options(contentType: Headers.formUrlEncodedContentType),
  //   );
  //   return resp.data['access_token'];
  // }

  Future<String> _generateYandexMusicTokenByXToken(String xToken) async {
    final data = {
      'access_token': xToken,
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': 'x-token',
    };

    final resp = await _client.post(
      '$passportUrl/1/token/?{self._auth_sdk_params',
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    return resp.data['access_token'];
  }
  */

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
  Future<void> rotorStationFeedback({
    required Station station,
    required StationFeedback feedback,
    DateTime? timestamp,
    String? from,
    String? totalPlayerSeconds,
    String? batchId,
    String? trackId,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    // var _timestamp = (timestamp ?? DateTime.now()).millisecondsSinceEpoch.toString();
    // final data = {
    // 'timestamp': _timestamp,
    // };

    /*

      if timestamp is None:
            timestamp = datetime.now().timestamp()

        url = f'{self.base_url}/rotor/station/{station}/feedback'

        params = {}
        data = {'type': type_, 'timestamp': timestamp}

        if batch_id:
            params = {'batch-id': batch_id}

        if track_id:
            data.update({'trackId': track_id})

        if from_:
            data.update({'from': from_})

        if total_played_seconds:
            data.update({'totalPlayedSeconds': total_played_seconds})

        result = self._request.post(url, params=params, json=data, timeout=timeout, *args, **kwargs)

        return result == 'ok'

    */
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
    int? queue,
  }) async {
    final resp = await _client.get('$baseUrl/rotor/station/$station/tracks', queryParameters: {
      'settings2': true,
      if (queue != null) 'queue': queue,
    });

    return StationTracksResult.fromJson(resp.data['result']);
  }
}
