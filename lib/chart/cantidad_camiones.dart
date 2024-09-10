import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class CantidadCamiones extends StatelessWidget {
  const CantidadCamiones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('CANTIDAD DE CAMIONES'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: StackedBarChartSample(
            labels: ['Ene', 'Feb'],
            values: [
              [21, 78, 413], // Valores para Ene
              [37, 80, 439], // Valores para Feb
            ],
            colors: [
              Colors.yellow, // Color para la primera categoría
              Colors.orange, // Color para la segunda categoría
              Colors.blue, // Color para la tercera categoría
            ],
          ),
        ),
      ),
    );
  }
}
