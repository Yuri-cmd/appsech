import 'package:flutter/material.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/theme/app_theme.dart';

class CamionesAcumlados extends StatelessWidget {
  const CamionesAcumlados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('CAMIONES - ACUM.'),
      ),
      body: const Center(
        child: PieChartGrafic(
          values: [159, 156, 58, 852],
          colors: [Colors.blue, Colors.orange, Colors.grey, Colors.yellow],
          labels: ['', '', ''],
        ),
      ),
    );
  }
}
