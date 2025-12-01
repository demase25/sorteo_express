import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/floating_logo.dart';
import '../widgets/animated_title.dart';
import '../widgets/animated_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBackground(
        primaryColor: AppTheme.primaryColor,
        secondaryColor: AppTheme.secondaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo flotante animado
                  const FloatingLogo(
                    imagePath: 'assets/images/logo.png',
                    size: 120,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  
                  // Título principal animado con gradiente
                  AnimatedTitle(
                    text: AppConstants.homeTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  
                  // Subtítulo con animación
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        AppConstants.homeSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largePadding * 2),
                  
                  // Botones principales con animaciones y gradientes personalizados
                  AnimatedMenuButton(
                    text: 'Sorteo de Nombres',
                    icon: Icons.person,
                    onPressed: () => _navigateToSorteo(context, 'nombres'),
                    index: 0,
                    gradientStart: AppTheme.primaryColor,
                    gradientEnd: AppTheme.secondaryColor.withOpacity(0.8),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  AnimatedMenuButton(
                    text: 'Sorteo de Números',
                    icon: Icons.numbers,
                    onPressed: () => _navigateToSorteo(context, 'numeros'),
                    index: 1,
                    gradientStart: AppTheme.primaryColor,
                    gradientEnd: const Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  
                  AnimatedMenuButton(
                    text: 'Sorteo de Rifas',
                    icon: Icons.confirmation_number,
                    onPressed: () => _navigateToSorteo(context, 'rifas'),
                    index: 2,
                    gradientStart: AppTheme.secondaryColor,
                    gradientEnd: AppTheme.accentColor,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  
                  AnimatedMenuButton(
                    text: AppConstants.verHistorialButton,
                    icon: Icons.history,
                    onPressed: () => AppRoutes.navigateToHistory(context),
                    isSecondary: true,
                    index: 3,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToSorteo(BuildContext context, String type) {
    Navigator.pushNamed(
      context,
      AppRoutes.sorteo,
      arguments: {'tipo': type},
    );
  }
}
