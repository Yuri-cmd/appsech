import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class ToneladasIngresadas extends StatelessWidget {
  const ToneladasIngresadas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('TONELADAS INGRESADAS'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: StackedBarChartSample(
            labels: ['Ene', 'Feb'],
            values: [
              [1114, 1757, 409, 3964], // Valores para Ene
              [3444, 560, 1117, 2865], // Valores para Feb
            ],
            colors: [
              Colors.yellow,
              Colors.orange,
              Colors.blue,
              Colors.grey,
            ],
          ),
        ),
      ),
    );
  }
}
