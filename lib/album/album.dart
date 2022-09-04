import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';
part 'album.g.dart';

//https://github.com/MarshalX/yandex-music-api/blob/eb48280e38879e235e1389c3e6d862966c10d6d2/yandex_music/album/album.py

// """Класс, представляющий альбом.
// Note:
//     Известные типы альбома: `single` - сингл, `compilation` - сборник.
//     Известные предупреждения о содержимом: `explicit` - ненормативная лексика.
//     Известные ошибки: `not-found` - альбом с таким ID не существует.
//     Известные значения поля `meta_type`: `music`.
// Attributes:
//     id_(:obj:`int`, optional): Идентификатор альбома.
//     error (:obj:`str`, optional): Ошибка получения альбома.
//     title (:obj:`str`, optional): Название альбома.
//     track_count (:obj:`int`, optional): Количество треков.
//     artists (:obj:`list` из :obj:`yandex_music.Artist`, optional): Артисты.
//     labels (:obj:`list` из :obj:`yandex_music.Label` или :obj:`str`, optional): Лейблы.
//     available (:obj:`bool`, optional): Доступен ли альбом.
//     available_for_premium_users (:obj:`bool`, optional): Доступен ли альбом для пользователей с подпиской.
//     version (:obj:`str`, optional): Дополнительная информация об альбоме.
//     cover_uri (:obj:`str`, optional): Ссылка на обложку.
//     content_warning (:obj:`str`, optional): Предупреждение о содержимом альбома.
//     original_release_year: TODO.
//     genre (:obj:`str`, optional): Жанр музыки.
//     text_color (:obj:`str`, optional): Цвет текста описания.
//     short_description (:obj:`str`, optional): Короткое описание.
//     description (:obj:`str`, optional): Описание.
//     is_premiere (:obj:`bool`, optional): Премьера ли.
//     is_banner (:obj:`bool`, optional): Является ли баннером.
//     meta_type (:obj:`str`, optional): Мета тип TODO.
//     storage_dir (:obj:`str`, optional): В какой папке на сервере хранится файл TODO.
//     og_image (:obj:`str`, optional): Ссылка на превью Open Graph.
//     recent (:obj:`bool`, optional): Является ли альбом новым.
//     very_important (:obj:`bool`, optional): Популярен ли альбом у слушателей.
//     available_for_mobile (:obj:`bool`, optional): Доступен ли альбом из приложения для телефона.
//     available_partially (:obj:`bool`, optional): Доступен ли альбом частично для пользователей без подписки.
//     bests (:obj:`list` из :obj:`int`, optional): ID лучших треков альбома.
//     duplicates (:obj:`list` из :obj:`yandex_music.Album`, optional): Альбомы-дубликаты.
//     prerolls (:obj:`list`, optional): Прероллы TODO.
//     volumes (:obj:`list` из :obj:`list` из :obj:`Track`, optional): Треки альбома, разделённые по дискам.
//     year (:obj:`int`, optional): Год релиза.
//     release_date (:obj:`str`, optional): Дата релиза в формате ISO 8601.
//     type (:obj:`str`, optional): Тип альбома.
//     track_position (:obj:`yandex_music.TrackPosition`, optional): Позиция трека в альбоме. Возвращается при
//         получении альбома в составе трека.
//     regions (:obj:`list` из :obj:`str`, optional): Список регионов в которых доступен альбом.
//     available_as_rbt (:obj:`bool`, optional): TODO.
//     lyrics_available (:obj:`bool`, optional): Доступны ли слова TODO.
//     remember_position (:obj:`bool`, optional): Запоминание позиции TODO.
//     albums (:obj:`list` из :obj:`yandex_music.Album`, optional): Альбомы TODO.
//     duration_ms (:obj:`int`, optional): Длительность в миллисекундах.
//     explicit (:obj:`bool`, optional): Есть ли в треке ненормативная лексика.
//     start_date (:obj:`str`, optional): Дата начала в формате ISO 8601 TODO.
//     likes_count (:obj:`int`, optional): Количество лайков TODO.
//     deprecation (:obj:`yandex_music.Deprecation`, optional): TODO.
//     available_regions (:obj:`list` из :obj:`str`, optional): Регионы, где доступн альбом.
//     client (:obj:`yandex_music.Client`, optional): Клиент Yandex Music.
// """

@freezed
abstract class Album with _$Album {
  const Album._();
  factory Album({
    int? id,
    String? error,
    String? title,
    int? trackCount,
    String? coverUri,
  }) = _Album;

  String? getCoverImage({String size = '200x200', int index = 0}) {
    return coverUri == null ? null : 'https://${coverUri!.replaceAll("%%", size)}';
  }

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
