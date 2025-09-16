import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o icono principal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shuffle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Título principal
            Text(
              AppConstants.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            
            // Subtítulo
            Text(
              AppConstants.homeSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding * 2),
            
            // Botones principales
            CustomButton(
              text: 'Sorteo de Nombres',
              icon: Icons.person,
              onPressed: () => _navigateToSorteo(context, 'nombres'),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            CustomButton(
              text: 'Sorteo de Números',
              icon: Icons.numbers,
              onPressed: () => _navigateToSorteo(context, 'numeros'),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            CustomButton(
              text: AppConstants.verHistorialButton,
              icon: Icons.history,
              onPressed: () => AppRoutes.navigateToHistory(context),
              isSecondary: true,
            ),
          ],
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
