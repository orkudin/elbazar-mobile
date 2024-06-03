import 'package:elbazar_app/data/network/network_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final baseURLProvider = Provider<String>((ref) => 'https://daurendan.ru/');

final loggerProvider = Provider<Logger>((ref) => Logger());

final networkMapperProvider = Provider<NetworkMapper>((ref) {
  final logger = ref.watch(loggerProvider);
  return NetworkMapper(log: logger);
});