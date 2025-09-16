import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'core/constants.dart';
import 'services/ads_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar servicios
  await AdsService.initialize();
  
  runApp(const SorteoExpressApp());
}

class SorteoExpressApp extends StatelessWidget {
  const SorteoExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
