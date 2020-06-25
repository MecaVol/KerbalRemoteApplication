/// The Kerbal Remote App is useful for messing around with Kerbal Space
/// Program. It is designed to be easily extensible for whatever need you may
/// have to launch or land or dock or whatever else your vessel.
/// Good luck.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/sas_control/sas_control_bloc.dart';
import 'package:kerbal_remote_application/pages/route_generator.dart';
import 'package:provider/provider.dart';
import 'blocs/shared_prefs/shared_prefs_bloc.dart';
import 'connection/client.dart';
import 'themes/theme_generator.dart';

void main() {
  runApp(KerbalRemoteApp());
}

class KerbalRemoteApp extends StatelessWidget {
  /// Root widget of the App. Initializes:
  ///   - all BLoCs,
  ///   - routes,
  ///   - theme,
  ///   and returns a [MaterialApp].
  @override
  Widget build(BuildContext context) {
    return Provider<Client>(
      create: (_) => Client(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SharedPrefsBloc>(
            create: (_) => SharedPrefsBloc(),
          ),
          BlocProvider<SasControlBloc>(
            create: (_) => SasControlBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeGenerator.getDefaultTheme(),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
