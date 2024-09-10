// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StackedBarChartSample extends StatelessWidget {
  final List<String> labels;
  final List<List<double>> values;
  final List<Color> colors;

  const StackedBarChartSample({
    Key? key,
    required this.labels,
    required this.values,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(values),
          barGroups: _createBarGroups(),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              margin: 8,
              getTitles: (value) {
                // Solo mostrar etiquetas en incrementos de 20
                if (value % 20 == 0) {
                  return value.toString();
                } else {
                  return '';
                }
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              getTitles: (double value) {
                int index = value.toInt();
                return labels[index];
              },
              margin: 8,
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey[700],
              tooltipPadding: const EdgeInsets.all(4),
              tooltipMargin: 4,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.y.toStringAsFixed(0)}',
                  const TextStyle(
                      color: Colors.white,
                      fontSize: 10), // Reducir tamaño de texto en tooltips
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(List<List<double>> values) {
    double maxData = values
        .expand((element) => element)
        .reduce((value, element) => value > element ? value : element);
    return maxData * 1.3; // Añadir un 30% extra para el espacio superior
  }

  List<BarChartGroupData> _createBarGroups() {
    return values
        .asMap()
        .map<int, BarChartGroupData>((index, values) {
          return MapEntry(
            index,
            BarChartGroupData(
              x: index,
              barRods: values
                  .asMap()
                  .map<int, BarChartRodData>((subIndex, value) {
                    return MapEntry(
                      subIndex,
                      BarChartRodData(
                        y: value,
                        colors: [colors[subIndex]],
                        width: 24, // Incrementar el ancho de las barras
                        borderRadius: BorderRadius.zero,
                      ),
                    );
                  })
                  .values
                  .toList(),
              showingTooltipIndicators: [0, 1, 2],
            ),
          );
        })
        .values
        .toList();
  }
}
