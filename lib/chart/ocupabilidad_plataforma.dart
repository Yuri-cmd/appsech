import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class OcupabilidadPlataforma extends StatelessWidget {
  const OcupabilidadPlataforma({super.key});

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
            labels: ['1/01/2024', '2/01/2024', '3/01/2024'],
            values: [
              [5],
              [5],
              [10],
            ],
            colors: [
              Colors.yellow,
              Colors.orange,
              Colors.blue,
            ],
          ),
        ),
      ),
    );
  }
}
