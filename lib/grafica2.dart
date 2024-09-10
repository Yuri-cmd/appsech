import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class PieChartSample extends StatelessWidget {
  final List<charts.Series> seriesList = _createSampleData();

  PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
  }

  static List<charts.Series<PieData, String>> _createSampleData() {
    final data = [
      PieData('A', 30),
      PieData('B', 25),
      PieData('C', 20),
      PieData('D', 15),
      PieData('E', 10),
    ];

    return [
      charts.Series<PieData, String>(
        id: 'Sales',
        domainFn: (PieData sales, _) => sales.category,
        measureFn: (PieData sales, _) => sales.value,
        data: data,
        labelAccessorFn: (PieData row, _) => '${row.category}: ${row.value}',
      )
    ];
  }
}

class PieData {
  final String category;
  final int value;

  PieData(this.category, this.value);
}
