import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed.freezed.dart';

@freezed
class Feed with _$Feed {
  /*
  * can_get_more_events: bool
    pumpkin: bool
    is_wizard_passed: bool
    generated_playlists: List['GeneratedPlaylist']
    headlines: list
    today: str
    days: List['Day']
    next_revision: Optional[str] = None
    client: Optional['Client'] = None
  * */
  @freezed
  const factory Feed({
    ///Хэллоуин
    @Default(false) bool pumpkin,
    // Можно ли получить больше событий.
    @Default(false) bool canGetMoreEvents,

    ///TODO
    @JsonKey(name: 'is_wizard_passed') @Default(false) bool isWizardPassed,
  }) = _Feed;
}
