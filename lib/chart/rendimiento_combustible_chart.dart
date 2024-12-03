import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RendimientoCombustible extends StatelessWidget {
  final List<RendData> data = [
    RendData('13/10/23', 0.6, 1.0, 0.4, 0.7),
    RendData('16/10/23', 0.55, 1.0, 0.4, 0.65),
    RendData('20/10/23', 0.65, 1.0, 0.4, 0.6),
    RendData('25/10/23', 0.7, 1.0, 0.4, 0.55),
    // Puedes agregar más puntos aquí
  ];

  RendimientoCombustible({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rendimiento de Combustible'),
          backgroundColor: AppTheme.primary,
        ),
        body: Container(
          color: Colors.white, // Fondo blanco
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'REND (HR/GAL) - Placa VOLQUETE AKH-794',
              alignment: ChartAlignment.center,
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: 'Fecha'),
              labelStyle: const TextStyle(fontSize: 10),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'HR/GAL'),
              minimum: 0.0,
              maximum: 1.4,
              interval: 0.2,
              labelStyle: const TextStyle(fontSize: 10),
            ),
            series: <ChartSeries>[
              // Línea superior (Lc)
              LineSeries<RendData, String>(
                name: 'Lc',
                dataSource: data,
                xValueMapper: (RendData rend, _) => rend.fecha,
                yValueMapper: (RendData rend, _) => rend.lc,
                color: Colors.grey,
                width: 2,
              ),
              // Línea inferior (Lci)
              LineSeries<RendData, String>(
                name: 'Lci',
                dataSource: data,
                xValueMapper: (RendData rend, _) => rend.fecha,
                yValueMapper: (RendData rend, _) => rend.lci,
                color: Colors.orange,
                width: 2,
              ),
              // Línea de promedio (PROM)
              LineSeries<RendData, String>(
                name: 'PROM',
                dataSource: data,
                xValueMapper: (RendData rend, _) => rend.fecha,
                yValueMapper: (RendData rend, _) => rend.promedio,
                color: Colors.yellow,
                width: 2,
              ),
              // Seguimiento (Segui)
              LineSeries<RendData, String>(
                name: 'Segui',
                dataSource: data,
                xValueMapper: (RendData rend, _) => rend.fecha,
                yValueMapper: (RendData rend, _) => rend.segui,
                color: Colors.blue,
                dashArray: [5, 5],
                width: 2,
              ),
              // Puntos de datos (DATO)
              ScatterSeries<RendData, String>(
                name: 'DATO',
                dataSource: data,
                xValueMapper: (RendData rend, _) => rend.fecha,
                yValueMapper: (RendData rend, _) => rend.promedio,
                color: Colors.blue,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 8,
                  height: 8,
                ),
              ),
            ],
          ),
        ));
  }
}

class RendData {
  RendData(this.fecha, this.promedio, this.lc, this.lci, this.segui);

  final String fecha;
  final double promedio;
  final double lc;
  final double lci;
  final double segui;
}
