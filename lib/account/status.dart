import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/account/account.dart';

part 'status.freezed.dart';
part 'status.g.dart';

@freezed
abstract class Status with _$Status {
  factory Status({
    Account? account,
    String? defaultEmail, // Основной e-mail адрес аккаунта.
    int? skipsPerHour, //Количество переключение треков на радио в час.
    bool? stationExists, // Наличие личной станции.
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}
