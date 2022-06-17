import 'package:freezed_annotation/freezed_annotation.dart';

part 'id.freezed.dart';
part 'id.g.dart';

@freezed
abstract class Id with _$Id {
   factory Id({
     required String type,
     required String tag,

   }) = _Id;
   factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
}