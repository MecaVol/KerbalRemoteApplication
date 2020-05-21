import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_event.dart';

part 'shared_prefs_state.dart';

class SharedPrefsBloc extends Bloc<SharedPrefsEvent, SharedPrefsState> {
  @override
  SharedPrefsState get initialState => WaitingSharedPrefsState();

  @override
  Stream<SharedPrefsState> mapEventToState(SharedPrefsEvent event) async* {
    yield WaitingSharedPrefsState();
    if (event is GetLastIPs) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> lastIps = prefs.getStringList("last_ips");
        if (lastIps == null) {
          yield NotFoundSharedPrefsState();
        } else {
          yield LastIPs(lastIps);
        }
      } on Exception {
        yield NotFoundSharedPrefsState();
      }
    } else if (event is AddAnIP) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> lastIps = [];
      lastIps.addAll(prefs.getStringList("last_ips"));
      lastIps.add(event.ip);
      prefs.setStringList("last_ips", lastIps);
    }
  }
}
