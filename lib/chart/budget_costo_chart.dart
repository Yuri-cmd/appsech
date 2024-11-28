import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BudgetVsCostChart extends StatefulWidget {
  const BudgetVsCostChart({super.key});

  @override
  _BudgetVsCostChartState createState() => _BudgetVsCostChartState();
}

class _BudgetVsCostChartState extends State<BudgetVsCostChart> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTimeRange? selectedRange;
  List<_ChartData> chartData = [];

  // Función para hacer la solicitud HTTP y obtener los datos del gráfico
  Future<void> _fetchData() async {
    if (selectedRange == null) return;

    final String startDate = dateFormat.format(selectedRange!.start);
    final String endDate = dateFormat.format(selectedRange!.end);

    try {
      final List<Map<String, dynamic>> data =
          await ApiService.fetchConsumoAlquiler(startDate, endDate);

      // Procesar los datos obtenidos
      setState(() {
        chartData = [
          _ChartData('Costo Total', data[0]['costo'].toDouble(), 0),
          _ChartData('Presupuesto', 0, data[1]['costo'].toDouble()),
        ];
      });
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Función para seleccionar el rango de fechas
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedRange) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de Budget vs Costo Total'),
        backgroundColor: Colors.blue,
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
            if (chartData.isNotEmpty)
              Expanded(
                child: SfCartesianChart(
                  title: ChartTitle(text: 'CONSUMO DE BUDYET-ALQ-MAQ.'),
                  primaryXAxis: CategoryAxis(
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'PEN'),
                    minimum: 0,
                    maximum: 120000,
                    interval: 20000,
                    labelFormat: '{value}',
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.category,
                      yValueMapper: (_ChartData data, _) => data.costTotal,
                      name: 'Suma de COSTO TOTAL (S/.)',
                      color: Colors.orange,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                    ),
                    ColumnSeries<_ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.category,
                      yValueMapper: (_ChartData data, _) => data.budget,
                      name: 'Suma de BUDGET',
                      color: Colors.blue,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
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

// Modelo para datos del gráfico
class _ChartData {
  final String category;
  final double costTotal;
  final double budget;

  _ChartData(this.category, this.costTotal, this.budget);
}

void main() {
  runApp(const MaterialApp(home: BudgetVsCostChart()));
}
