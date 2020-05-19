import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/widgets/kerbal_connection_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kerbal Remote App'),
      ),
      body: BlocProvider(
        create: (context) => KerbalConnectionBloc(),
        child: KerbalConnectionWidget(),
      ),
    );
  }
}