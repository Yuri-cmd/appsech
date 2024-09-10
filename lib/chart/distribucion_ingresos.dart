import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class DistribucionIngresos extends StatelessWidget {
  const DistribucionIngresos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Distribución de Ingresos'),
      ),
      body: const Center(
        child: PieChartGrafic(
          values: [2, 2, 16],
          colors: [Colors.blue, Colors.orange, Colors.grey],
          labels: ['', '', ''],
        ),
      ),
    );
  }
}
