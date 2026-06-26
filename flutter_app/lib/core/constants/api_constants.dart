import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:8080/api');
  static const String tasks = '/tasks';
  static Duration get timeout =>
      Duration(seconds: int.parse(dotenv.get('TIMEOUT', fallback: '30')));
}
