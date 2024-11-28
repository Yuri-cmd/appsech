// ignore_for_file: use_build_context_synchronously

import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appsech/api/api_service.dart'; // Importa tu servicio de API

class BudgetTable extends StatefulWidget {
  const BudgetTable({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetTableState createState() => _BudgetTableState();
}

class _BudgetTableState extends State<BudgetTable> {
  int currentYear = DateTime.now().year; // Año actual
  List<MonthBudget> months =
      []; // Lista para almacenar los meses y presupuestos

  @override
  void initState() {
    super.initState();
    _fetchData(); // Cargar los datos de la API
  }

  // Función para cargar los datos de la API
  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchBudgetForYear(currentYear);

      // Elimina controladores previos para evitar fugas de memoria
      for (var month in months) {
        month.controller.dispose();
      }

      setState(() {
        months = List.generate(12, (index) {
          int contador = index + 1; // Meses del 1 al 12
          var monthData = data.firstWhere(
            (item) {
              return item['mes'] == contador;
            },
            orElse: () => {'id': 0, 'mes': index + 1, 'presupuesto': 0.0},
          );

          // Asegurar que el presupuesto sea un double
          double presupuesto = monthData['presupuesto'] is double
              ? monthData['presupuesto']
              : (monthData['presupuesto'] as int).toDouble();

          // Inicialización del controller con el presupuesto
          return MonthBudget(
            id: monthData['id'],
            mes: monthData['mes'],
            presupuesto: presupuesto,
            controller: TextEditingController(
              text: presupuesto.toStringAsFixed(2),
            ),
          );
        });
      });
    } catch (e) {
      throw Exception('Error al procesar los datos: $e');
    }
  }

  // Función para guardar los cambios
  void _saveAllChanges() async {
    try {
      // Crear un mapa de presupuestos
      final budgets = months.map((month) {
        return {
          'id': month.id,
          'mes': month.mes,
          'presupuesto': month.presupuesto,
        };
      }).toList();

      // Llamar al servicio para guardar todos los presupuestos
      await ApiService.saveAllBudgets(currentYear, budgets);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Todos los presupuestos guardados con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar presupuestos: $e')),
      );
    }
  }

  // Función para cambiar el año
  void _changeYear(int newYear) {
    setState(() {
      currentYear = newYear;
    });
    _fetchData(); // Cargar los datos para el nuevo año
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto por Mes'),
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Selector de año
            Row(
              children: [
                const Text(
                  'Seleccionar Año: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: currentYear,
                  items: List.generate(10, (index) {
                    int year = 2026 - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (newYear) {
                    if (newYear != null) {
                      _changeYear(newYear);
                    }
                  },
                ),
              ],
            ),

            // Tabla de presupuestos
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Mes')),
                    DataColumn(label: Text('Presupuesto')),
                  ],
                  rows: months.map((month) {
                    return DataRow(cells: [
                      DataCell(Text(DateFormat('MMMM')
                          .format(DateTime(currentYear, month.mes)))),

                      // Usamos el TextEditingController directamente
                      DataCell(
                        TextFormField(
                          controller: month.controller,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: (value) {
                            month.presupuesto = double.tryParse(value) ?? 0.0;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0',
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),

      // Botón flotante para guardar cambios
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAllChanges,
        child: const Icon(Icons.save),
      ),
    );
  }
}

// Modelo de datos para cada mes y su presupuesto
class MonthBudget {
  final int id;
  final int mes;
  double presupuesto;
  TextEditingController controller;

  MonthBudget({
    required this.id,
    required this.mes,
    required this.presupuesto,
    required this.controller,
  });
}
