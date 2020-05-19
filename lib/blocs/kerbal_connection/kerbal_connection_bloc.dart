import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kerbal_remote_application/proto/krpc.pb.dart'
    show Request, ProcedureCall, Response;
import 'package:kerbal_remote_application/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'kerbal_connection_event.dart';
part 'kerbal_connection_state.dart';

class KerbalConnectionBloc
    extends Bloc<KerbalConnectionEvent, KerbalConnectionState> {

  WebSocketChannel _channel;

  @override
  KerbalConnectionState get initialState => InitialKerbalConnectionState();

  @override
  Stream<KerbalConnectionState> mapEventToState(
      KerbalConnectionEvent event) async* {
    if (event is StartKerbalConnectionEvent) {
      String uri = "ws://" + event._url + ":" + event._port.toString() +
          "/?name=" + event._name;
      logD(uri);
      try {
        _channel = IOWebSocketChannel.connect(uri);
        var request = Request()..calls.add(ProcedureCall()..service = 'KRPC'..procedure = 'GetClientID');
        _channel.sink.add(request.writeToBuffer());
        _channel.stream.listen((rawProtoData) {
          logD(rawProtoData.toString());
        });
        yield GoodKerbalConnectionState('identifier');
      } on Exception {
        yield ErrorKerbalConnectionState('Connection failed. Check IP and port number!');
      }

    } else if (event is StopKerbalConnectionEvent) {
      _channel.sink.close();
      yield InitialKerbalConnectionState();
    }
  }
}
