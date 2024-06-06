import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartSample extends StatelessWidget {
  final List<charts.Series<SalesData, String>> seriesList = [
    charts.Series(
      id: 'Sales',
      data: [
        SalesData('Enero', 100),
        SalesData('Febrero', 75),
        SalesData('Marzo', 200),
        SalesData('Abril', 150),
      ],
      domainFn: (SalesData sales, _) => sales.month,
      measureFn: (SalesData sales, _) => sales.sales,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      labelAccessorFn: (SalesData sales, _) => '${sales.month}: ${sales.sales}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}
