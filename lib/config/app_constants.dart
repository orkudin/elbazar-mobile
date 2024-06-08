import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final baseUrl = '${dotenv.env['BASE_URL']}';
}