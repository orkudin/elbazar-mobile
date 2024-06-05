import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final baseURLProvider = Provider<String>((ref) => 'https://daurendan.ru/');

final loggerProvider = Provider<Logger>((ref) => Logger());

