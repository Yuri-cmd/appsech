import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RendimientoChart extends StatelessWidget {
  final List<FlSpot> lciData = [
    FlSpot(0, 0.65),
    FlSpot(1, 0.65),
    FlSpot(2, 0.60),
    FlSpot(3, 0.75),
    FlSpot(4, 0.70),
  ];

  final List<FlSpot> lcData = [
    FlSpot(0, 0.6),
    FlSpot(1, 0.6),
    FlSpot(2, 0.55),
    FlSpot(3, 0.65),
    FlSpot(4, 0.62),
  ];

  final List<FlSpot> promData = [
    FlSpot(0, 0.55),
    FlSpot(1, 0.55),
    FlSpot(2, 0.50),
    FlSpot(3, 0.55),
    FlSpot(4, 0.57),
  ];

  final List<FlSpot> seguimientoData = [
    FlSpot(0, 0.5),
    FlSpot(1, 0.5),
    FlSpot(2, 0.48),
    FlSpot(3, 0.52),
    FlSpot(4, 0.55),
  ];

  final List<FlSpot> datoData = [
    FlSpot(0, 0.45),
    FlSpot(1, 0.46),
    FlSpot(2, 0.50),
    FlSpot(3, 0.55),
    FlSpot(4, 0.60),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rendimiento de combustible')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white,
            minY: 0,
            maxY: 1.4,
            minX: 0, // Ajustar el mínimo del eje X
            maxX: 4, // Puedes intentar maxX=5 si aún se ve comprimido
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                margin: 10,
                getTitles: (value) {
                  DateTime date = DateTime(
                      2024,
                      10,
                      value.toInt() +
                          1); // Ajusta el día en función del valor del eje X
                  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
                },
                getTextStyles: (context, value) => TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                margin: 8,
                getTitles: (value) => value.toStringAsFixed(2),
                getTextStyles: (context, value) => TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: lciData,
                isCurved: false,
                colors: [Colors.red],
                barWidth: 2,
              ),
              LineChartBarData(
                spots: lcData,
                isCurved: false,
                colors: [Colors.orange],
                barWidth: 2,
              ),
              LineChartBarData(
                spots: promData,
                isCurved: false,
                colors: [Colors.yellow],
                barWidth: 2,
                dashArray: [5, 5],
              ),
              LineChartBarData(
                spots: seguimientoData,
                isCurved: false,
                colors: [Colors.blue],
                barWidth: 2,
                dashArray: [5, 5],
              ),
              LineChartBarData(
                spots: datoData,
                isCurved: false,
                colors: [Colors.cyan],
                barWidth: 2,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blue,
                    strokeWidth: 0,
                    strokeColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
