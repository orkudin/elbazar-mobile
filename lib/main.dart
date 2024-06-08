import 'package:elbazar_app/config/routes/app_routing.dart';
import 'package:elbazar_app/config/theme/color_theme.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'config/secure_Storage_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<AuthStateNotifier>(
          () => AuthStateNotifier(secureStorageService: getIt()));
}

void main() async {
  await dotenv.load(fileName: ".env");
  final apiBaseUrl = dotenv.env['BASE_URL'];
print(apiBaseUrl);
  setupLocator();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
