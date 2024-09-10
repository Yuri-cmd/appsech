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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size =
            constraints.biggest.shortestSide; // Use the smallest dimension
        return SizedBox(
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
                        radius: size / 2.2, // Ajusta el radio del gráfico aquí
                        title: '$value',
                        titleStyle: const TextStyle(
                          fontSize: 16,
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
                  0.0, // Establece el radio del espacio central a 0 para un pastel sólido
            ),
          ),
        );
      },
    );
  }
}
