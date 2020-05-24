import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_communicator/kerbal_communicator_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/blocs/shared_prefs/shared_prefs_bloc.dart';
import 'package:kerbal_remote_application/widgets/kerbal_connection_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kerbal Remote App'),
      ),
      body: MultiBlocProvider(
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
        child: KerbalConnectionWidget(),
      ),
    );
  }
}