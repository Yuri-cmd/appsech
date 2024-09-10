import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class IngresoResiduos extends StatelessWidget {
  const IngresoResiduos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('INGRESO DE RESIDUOS ACUM. (Ton)'),
      ),
      body: const Center(
        child: PieChartGrafic(
          values: [969, 2874, 3979, 7408],
          colors: [Colors.blue, Colors.orange, Colors.yellow, Colors.grey],
          labels: ['', '', ''],
        ),
      ),
    );
  }
}
