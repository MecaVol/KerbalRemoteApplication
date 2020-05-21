part of 'shared_prefs_bloc.dart';

@immutable
abstract class SharedPrefsState {}

class WaitingSharedPrefsState extends SharedPrefsState {}

class NotFoundSharedPrefsState extends SharedPrefsState {}

class ValueSharedPrefsState extends SharedPrefsState {

  final String value;
  final String key;

  ValueSharedPrefsState(this.key, this.value);
}

class LastIPs extends SharedPrefsState {
  final List<String> ips;
  LastIPs(this.ips);
}