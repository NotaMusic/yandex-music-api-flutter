import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_req_arg.freezed.dart';
part 'search_req_arg.g.dart';

@freezed
abstract class SearchReqArg with _$SearchReqArg {
  factory SearchReqArg({
    required String text,
    @Default(true) bool nocorrect,
    @Default(SearchReqTarget.all) SearchReqTarget type,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'playlist-in-best') @Default(true) bool playlistInBest,
    @Default(0) int page,
  }) = _SearchReqArg;
  factory SearchReqArg.fromJson(Map<String, dynamic> json) => _$SearchReqArgFromJson(json);
}

enum SearchReqTarget {
  all,
  artist,
  user,
  album,
  playlist,
  track,
  podcast,
  // ignore: constant_identifier_names
  podcast_episode,
}
