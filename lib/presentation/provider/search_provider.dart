import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define state providers for the search parameters
final searchTextProvider = StateProvider<String>((ref) => '');
final categoryIdProvider = StateProvider<int?>((ref) => null);
final salesIdProvider = StateProvider<int?>((ref) => null);
final searchTypeProvider = StateProvider<String?>((ref) => null);
