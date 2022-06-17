import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover.freezed.dart';

part 'cover.g.dart';

///Класс, представляющий обложку.

@freezed
class Cover with _$Cover {
  const Cover._();

  const factory Cover({
    ///Тип обложки
    String? type,

    ///Ссылка на изображение
    String? uri,

    ///Список ссылок на изображения
    List<String>? itemsUri,

    ///Директория хранения изображения на сервере
    String? dir,

    ///Version
    String? version,

    ///Является ли обложка пользовательской
    bool? isCustom,

    ///Уникальный идентификатор
    String? prefix,

    ///Название владельца авторским правом
    String? copyrightName,

    ///Владелец прав на музыку (автор текста и т.д.), а не её записи.
    String? copyrightCline,

    ///Сообщение об ошибке
    String? error,
  }) = _Cover;

  String? getDownloadUrl({String size = '200x200', int index = 0}) {
    final url = uri ?? itemsUri?[0];
    return url == null ? null : 'https://${url.replaceAll("%%", size)}';
  }

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);
}
