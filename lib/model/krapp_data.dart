import 'dart:typed_data';

import 'package:kerbal_remote_application/utils/logger.dart';

/// Class to handle data received from kRPC web sockets.
///
/// It handles stream errors form web sockets and received raw data of the
/// protobuf.
class KrappData {
  final String _error;
  final Uint8List _data;

  bool get onError => _error != null;
  String get error => _error ?? 'None';
  Uint8List get data => _data;

  KrappData(this._data, this._error) {
    logD('KrappData: data=' + _data.toString() + ' error=' + _error);
  }
}