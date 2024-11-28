import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class UtilizacionMaquinariasChart extends StatefulWidget {
  const UtilizacionMaquinariasChart({super.key});

  @override
  _UtilizacionMaquinariasChartState createState() =>
      _UtilizacionMaquinariasChartState();
}

class _UtilizacionMaquinariasChartState
    extends State<UtilizacionMaquinariasChart> {
  List<_ChartData> histogramData = [];
  List<_ChartData> lineData = [];
  DateTimeRange? selectedRange;
  bool isLoading = false;

  final dateFormat = DateFormat('yyyy-MM-dd');

  // Llamada a la API
  Future<void> _fetchData() async {
    if (selectedRange == null) {
      _showMessage('Por favor selecciona un rango de fechas.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String startDate = dateFormat.format(selectedRange!.start);
    final String endDate = dateFormat.format(selectedRange!.end);

    try {
      final List<Map<String, dynamic>> data =
          await ApiService.fetchUtilizacionMaquinaria(startDate, endDate);

      setState(() {
        histogramData = data
            .map((item) => _ChartData(
                item['maquinaria'], double.parse(item['utilizacion'])))
            .toList();

        lineData = data
            .map((item) => _ChartData(item['maquinaria'],
                double.parse(item['promedio_horas_trabajadas'])))
            .toList();
      });
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Selección de rango de fechas
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (range != null) {
      setState(() {
        selectedRange = range;
      });
    }
  }

  // Mostrar mensajes
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilización de Maquinarias'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectDateRange(context),
                child: Text(
                  selectedRange == null
                      ? 'Seleccionar Rango de Fechas'
                      : '${dateFormat.format(selectedRange!.start)} - ${dateFormat.format(selectedRange!.end)}',
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _fetchData,
                child: const Text('Generar Gráfico'),
              ),
            ],
          ),
          isLoading
              ? const CircularProgressIndicator()
              : histogramData.isEmpty && lineData.isEmpty
                  ? const Text('No hay datos para mostrar.')
                  : Expanded(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(
                            text: 'Utilización de Maquinarias Operativas'),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries>[
                          // Histograma
                          ColumnSeries<_ChartData, String>(
                            dataSource: histogramData,
                            xValueMapper: (_ChartData data, _) => data.category,
                            yValueMapper: (_ChartData data, _) => data.value,
                            name: 'Utilización',
                            color: Colors.blue,
                            width: 0.6,
                          ),
                          // Línea
                          LineSeries<_ChartData, String>(
                            dataSource: lineData,
                            xValueMapper: (_ChartData data, _) => data.category,
                            yValueMapper: (_ChartData data, _) => data.value,
                            name: 'Promedio Horas/Día',
                            color: Colors.orange,
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);
}
