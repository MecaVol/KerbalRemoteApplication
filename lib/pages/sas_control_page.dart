import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/sas_control/sas_control_bloc.dart';

class SasControlEvent{}

class SasControlPage extends StatelessWidget {
  /// This page gives control of the SAS and provides some useful information
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SAS Control'),
      ),
      body: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          // SAS ON/OFF BUTTON _________________________________________________
          BlocBuilder<SasControlBloc, SasControlState>(
            builder: (context, state) {
              if (state is SasOnState) {
                return SasControlFeatureButton('SAS', true,
                  () => BlocProvider.of<SasControlBloc>(context)
                      .add(SasOffEvent()));
              } else if (state is SasOffState) {
                return SasControlFeatureButton('SAS', false,
                    () => BlocProvider.of<SasControlBloc>(context)
                        .add(SasOnEvent()));
              } else if (state is UnknownSasControlState){
                return SasControlFeatureButton('SAS', true,
                        () => BlocProvider.of<SasControlBloc>(context)
                        .add(SasOffEvent()));
              }
              return SasControlFeatureButton('SAS', false, null);
            },
          ),
        ],
      ),
    );
  }
}

class SasControlFeatureButton extends StatelessWidget {

  final String _title;
  final bool _featureState;
  final VoidCallback _onPressed;

  static Color stateOnColor = Colors.green;
  static Color stateOffColor = Colors.grey;

  SasControlFeatureButton(this._title, this._featureState, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: _featureState ? stateOnColor : stateOffColor,
      onPressed: _onPressed,
      child: Text(_title),
    );
  }

}
