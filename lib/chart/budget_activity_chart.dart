import 'package:appsech/api/api_service.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BudgetActivityChart extends StatefulWidget {
  const BudgetActivityChart({super.key});

  @override
  _BudgetActivityChartState createState() => _BudgetActivityChartState();
}

class _BudgetActivityChartState extends State<BudgetActivityChart> {
  DateTimeRange? selectedRange;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  List<_ChartData> chartData = [];
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x: point.y');
  }

  // Función para seleccionar el rango de fechas
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  // Función para obtener los datos de la API
  Future<List<_ChartData>> fetchChartData(
      String startDate, String endDate) async {
    try {
      final data = await ApiService.fetchConsumoActividad(startDate, endDate);

      return data.map((e) {
        final subtitle = '${e['maquinaria']}\n${e['actividad']}';
        return _ChartData(subtitle, e['costo_total'].toDouble());
      }).toList();
    } catch (e) {
      throw Exception('Error al procesar los datos: $e');
    }
  }

  // Función para manejar la obtención de datos
  Future<void> _fetchData() async {
    if (selectedRange != null) {
      try {
        final data = await fetchChartData(
          dateFormat.format(selectedRange!.start),
          dateFormat.format(selectedRange!.end),
        );
        if (!mounted) return;
        setState(() {
          chartData = data;
        });
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('No se pudieron cargar los datos: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Por favor, seleccione un intervalo de fechas.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Consumo de Maquinaria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 65,
                  labelStyle: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}',
                  majorGridLines: const MajorGridLines(width: 1),
                ),
                tooltipBehavior: tooltipBehavior,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.value,
                    name: 'Costo Total',
                    color: Colors.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);
}

void main() {
  runApp(const MaterialApp(home: BudgetActivityChart()));
}
