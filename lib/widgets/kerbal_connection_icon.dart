import 'package:flutter/material.dart';
import '../connection/client.dart';
import 'package:provider/provider.dart';

class KrappConnIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/connection');
      },
      child: StreamBuilder<CONNECTION_STATE>(
        stream: Provider.of<Client>(context).state,
        builder: (_, snapshot) {
          if (snapshot.data == CONNECTION_STATE.CONNECTED) {
            return Icon(Icons.brightness_1, color:  Colors.green,);
          } else {
            return Icon(Icons.brightness_1, color:  Colors.red,);
          }
        },
      ),
    );
  }
}
