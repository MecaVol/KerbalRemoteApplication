import 'package:logger/logger.dart';

var logger = Logger();

void logD(String message) {
  logger.d(message);
}

void logW(String message) {
  logger.w(message);
}

void logE(String message) {
  logger.e(message);
}