class KraResponse {
  KraError error;
  List<KraProcedureResult> results;
}

class KraProcedureResult {
  KraError error;
  dynamic value;
}

class KraError {
  String service;
  String name;
  String description;
  String stackTrace;
}