import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/pages/route_generator.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'blocs/kerbal_communicator/kerbal_communicator_bloc.dart';
import 'blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'blocs/shared_prefs/shared_prefs_bloc.dart';
import 'pages/connection_page.dart';
import 'themes/theme_generator.dart';

void main() {
  runApp(KerbalRemoteApp());
}

class KerbalRemoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KrappConnBloc>(
          create: (_) => KrappConnBloc(),
        ),
        BlocProvider<KerbalComBloc>(
          create: (_) => KerbalComBloc(),
        ),
        BlocProvider<SharedPrefsBloc>(
          create: (_) => SharedPrefsBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeGenerator.getDefaultTheme(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
