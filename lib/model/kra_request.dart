class KraRequest {
  List<KraProcedureCall> calls;

  KraRequest.singleProcedureCall(KraProcedureCall call) {
    calls.add(call);
  }
}

class KraProcedureCall {
  String service;
  String procedure;
  int serviceId;
  int procedureId;
  List<Argument> arguments;

  KraProcedureCall.simple(String service, String procedure) :
        this.service = service, this.procedure = procedure;
}

class Argument {
  int position;
  dynamic value;
}