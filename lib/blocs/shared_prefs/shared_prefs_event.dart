part of 'shared_prefs_bloc.dart';

@immutable
abstract class SharedPrefsEvent {}

class GetSharedPrefsEvent extends SharedPrefsEvent {
  final String key;
  GetSharedPrefsEvent(this.key);
}

class SetSharedPrefsEvent extends SharedPrefsEvent {
  final String key;
  final String value;
  SetSharedPrefsEvent(this.key, this.value);
}

class GetLastIPs extends SharedPrefsEvent {}

class AddAnIP extends SharedPrefsEvent {
  final String ip;
  AddAnIP(this.ip);
}
