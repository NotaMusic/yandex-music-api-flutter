import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
   factory Account({
    int? uid,
    String? fullName,
    required bool serviceAvailable, 
   }) = _Account;

   factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}