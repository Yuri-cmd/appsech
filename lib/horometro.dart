// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io'; // Importa esta librería para trabajar con archivos
import 'package:appsech/chart/budget_activity_chart.dart';
import 'package:appsech/chart/budget_costo_chart.dart';
import 'package:appsech/chart/utilizacion_maquinarias_chart.dart';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:appsech/screens/budget_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/helper.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/modalform.dart';

class Horometro extends StatefulWidget {
  const Horometro({super.key});

  @override
  _HorometroState createState() => _HorometroState();
}

class _HorometroState extends State<Horometro> {
  List<Map<String, dynamic>> registros = [];
  String? _selectedMaquinaria;
  List<dynamic> _filteredRegistros = [];
  List<String> _maquinariaOptions = [];
  @override
  void initState() {
    super.initState();
    obtenerRegistros();
    _fetchMaquinariaOptions();
  }

  Future<void> obtenerRegistros() async {
    try {
      final data = await ApiService.getRegistros();
      setState(() {
        registros = data;
        _filteredRegistros = data;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _fetchMaquinariaOptions() async {
    final options = await FormModalHelper.fetchMaquinariaOptions();
    setState(() {
      _maquinariaOptions = options;
      _filteredRegistros =
          registros; // Inicialmente, muestra todos los registros
    });
  }

  Future<void> _eliminarRegistro(int id) async {
    bool? confirmar = await DialogHelper.confirmarEliminar(context);

    if (confirmar == true) {
      final success = await ApiService.eliminarRegistro(id);
      if (success) {
        setState(() {
          registros.removeWhere((registro) => registro['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro eliminado con éxito')),
        );
        obtenerRegistros();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el registro')),
        );
      }
    }
  }

  // Mueve la función _editarRegistro aquí
  Future<void> _editarRegistro(int idRegistro) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormModal(registro: idRegistro),
      ),
    );
  }

  Future<void> _descargarExcel() async {
    try {
      final response = await ApiService.downloadExcel();

      if (response.statusCode == 200) {
        // Obtén el directorio de descargas principal
        Directory? downloadDir = Directory('/storage/emulated/0/Download');

        if (!(await downloadDir.exists())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('No se pudo encontrar el directorio de descargas')),
          );
          return;
        }

        // Guarda el archivo en la carpeta de descargas principal
        final file = File('${downloadDir.path}/controlDeMaquinarias.xlsx');
        await file.writeAsBytes(response.bodyBytes);

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Archivo Excel descargado con éxito en la carpeta de Descargas'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al descargar el archivo Excel')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el archivo Excel: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Maquinaria - HR'),
      ),
      endDrawer: NavOptionsView(
        options: [
          NavOption(
            title: 'CONSUMO DE BUDYET VS ACTIVIDAD',
            icon: Icons.pie_chart,
            targetView: const BudgetActivityChart(),
          ),
          NavOption(
            title: 'CONSUMO DE BUDYET-ALQ-MAQ',
            icon: Icons.pie_chart,
            targetView: const BudgetVsCostChart(),
          ),
          NavOption(
            title: 'UTILIZACIÓN DE MAQUINARIAS OPERATIVAS',
            icon: Icons.pie_chart,
            targetView: const UtilizacionMaquinariasChart(),
          ),
          NavOption(
            title: 'BUDGET',
            icon: Icons.pie_chart,
            targetView: const BudgetTable(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Permitir scroll vertical en todo el contenido
        child: Column(
          children: [
            // Dropdown para filtro
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Maquinaria'),
                value: _selectedMaquinaria,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedMaquinaria = newValue;
                    });
                    // _filterRegistros();
                  }
                },
                items: _maquinariaOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            // Tabla con registros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Maquinaria')),
                    DataColumn(label: Text('MAQ')),
                    DataColumn(label: Text('Operador')),
                    DataColumn(label: Text('Horometro inicio')),
                    DataColumn(label: Text('Horometro final')),
                    DataColumn(label: Text('Hr Trabajadas')),
                    DataColumn(label: Text('Gasolina')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: _filteredRegistros.map((registro) {
                    return DataRow(cells: [
                      DataCell(Text(registro['fecha'] ?? '')),
                      DataCell(Text(registro['maquinaria'] ?? '')),
                      DataCell(Text(registro['maq'] ?? '')),
                      DataCell(Text(registro['operador'] ?? '')),
                      DataCell(Text(registro['horometroi'] ?? '')),
                      DataCell(Text(registro['horometrof'] ?? '')),
                      DataCell(Text(registro['horas'] ?? '')),
                      DataCell(Text(registro['tipoCombustible'] ?? '-')),
                      DataCell(Text(registro['cargaCombustible'] ?? '')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarRegistro(registro['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarRegistro(registro['id']),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'add_button',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormModal()),
                  );
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'download_button',
                onPressed: _descargarExcel,
                child: const Icon(Icons.download),
              ),
            ],
          )
        ],
      ),
    );
  }
}
