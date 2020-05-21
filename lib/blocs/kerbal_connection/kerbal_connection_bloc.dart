import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kerbal_remote_application/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'kerbal_connection_event.dart';
part 'kerbal_connection_state.dart';

/// [KerbalConnectionBloc] is responsible of sending and receiving data from KSP.
///
/// Through the web_socket_channel plugin, it establishes a websocket
/// connection to kRPC and provide rpc and stream communication interfaces.
/// See KerbalCommunicator classes for communication interfaces.
class KerbalConnectionBloc
    extends Bloc<KerbalConnectionEvent, KerbalConnectionState> {

  WebSocketChannel _channel;

  @override
  KerbalConnectionState get initialState => InitialKerbalConnectionState();

  @override
  Stream<KerbalConnectionState> mapEventToState(
      KerbalConnectionEvent event) async* {
    yield WaitingKerbalConnectionState();
    if (event is StartKerbalConnectionEvent) {
      String uriPath = "ws://" + event._url + ":" + event._port.toString() +
          "/?name=" + event._name;
      logD('Web Socket connection to: ' + uriPath);
      _channel = IOWebSocketChannel.connect(uriPath);
      // todo: use the communicator!
      yield GoodKerbalConnectionState("identifier");
    } else if (event is StopKerbalConnectionEvent) {
      if (_channel != null) _channel.sink.close();
      yield InitialKerbalConnectionState();
    }
  }
}
