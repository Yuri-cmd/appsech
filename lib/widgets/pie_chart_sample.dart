import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartGrafic extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels;

  const PieChartGrafic({
    Key? key,
    required this.values,
    required this.colors,
    required this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart'),
        backgroundColor: AppTheme.primary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size =
              constraints.biggest.shortestSide; // Usa la menor dimensión
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // El gráfico circular
              Container(
                color: Colors.white, // Fondo blanco
                child: SizedBox(
                  width: size,
                  height: size,
                  child: PieChart(
                    PieChartData(
                      sections: values
                          .asMap()
                          .map<int, PieChartSectionData>((index, value) {
                            final color = colors[index % colors.length];
                            return MapEntry(
                              index,
                              PieChartSectionData(
                                color: color,
                                value: value,
                                radius: size /
                                    2.2, // Ajusta el radio del gráfico aquí
                                title:
                                    '${value.toStringAsFixed(1)}%', // Mostrar el valor en el gráfico
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          })
                          .values
                          .toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius:
                          0.0, // Radio del espacio central a 0 para un pastel sólido
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Espacio entre el gráfico y la leyenda

              // Leyenda
              Wrap(
                spacing: 10, // Espacio horizontal entre los items
                runSpacing: 10, // Espacio vertical entre los items
                children: labels
                    .asMap()
                    .map<int, Widget>((index, label) {
                      final color = colors[index % colors.length];
                      return MapEntry(
                        index,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Cuadro de color de la leyenda
                            Container(
                              width: 16,
                              height: 16,
                              color: color,
                            ),
                            const SizedBox(
                                width: 5), // Espacio entre color y texto
                            Text(label, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
