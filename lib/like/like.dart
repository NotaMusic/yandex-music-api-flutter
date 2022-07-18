import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_music_api_flutter/others/artist.dart';
import 'package:yandex_music_api_flutter/playlist/playlist.dart';

part 'like.freezed.dart';
part 'like.g.dart';

///Класс, представляющий объект с отметкой "мне нравится"
@freezed
abstract class Like with _$Like {
/*
    None:
        В поле `type` содержится одно из трёх значений:
         `artist`, `playlist`, `album`. Обозначает поле, в котором
        содержится информация.
    Attributes:
        type (:obj:`str`): Тип объекта с отметкой.
        id (:obj:`str`, optional): Уникальный идентификатор отметки.
        timestamp (:obj:`str`, optional): Дата и время добавления отметки.
        album (:obj:`yandex_music.Album`, optional): Понравившейся альбом.
        artist (:obj:`yandex_music.Artist`, optional): Понравившейся артист.
        playlist (:obj:`yandex_music.Playlist`, optional): Понравившейся плейлист.
        short_description (:obj:`str`, optional): Короткое описание.
        description (:obj:`str`, optional): Описание.
        is_premiere (:obj:`bool`, optional): Премьера ли.
        is_banner (:obj:`bool`, optional): Является ли баннером.

*/

  factory Like({
    required LikeType type,
    String? id,
    String? timestamp,
    // Album? album,
    Artist? artist,
    Playlist? playlist,
    String? shortDescription,
    String? description,
    bool? isPremiere,
    bool? isBanner,
  }) = _Like;
  
  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);
}

enum LikeType { artist, playlist, album }
