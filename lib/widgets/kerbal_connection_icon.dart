import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';

class KrappConnIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/connection');
      },
      child: BlocBuilder<KrappConnBloc, KrappConnState>(
        builder: (context, state) {
          if (state is ConnectedKrappConnState) {
            return Icon(Icons.brightness_1, color:  Colors.green,);
          } else {
            return Icon(Icons.brightness_1, color:  Colors.red,);
          }
        },
      ),
    );
  }
}
