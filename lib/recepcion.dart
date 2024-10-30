// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/widgets/nav_options_view.dart';
import 'package:appsech/widgets/pie_chart_sample.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appsech/theme/app_theme.dart';

class Recepcion extends StatefulWidget {
  const Recepcion({super.key});

  @override
  _RecepcionState createState() => _RecepcionState();
}

class _RecepcionState extends State<Recepcion> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://magussystems.com/appsheet/public/api/get/recepcion/unidades'));

    if (response.statusCode == 200) {
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(response.body));
        _loading = false;
      });
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  void _updateValue(int rowIndex, String key, String value) {
    setState(() {
      _data[rowIndex][key] = value;

      // Actualizar "N° Camiones terceros día"
      if (key == 'camiones_kanay_dia' || key == 'cantidad_camiones_dia') {
        double camionesDiaTotales =
            _getValueOrDefault(_data[rowIndex]['cantidad_camiones_dia']);
        double camionesKanayDia = double.tryParse(
                _data[rowIndex]['camiones_kanay_dia']?.toString() ?? '0') ??
            0.0;

        double camionesTercerosDia = (camionesDiaTotales - camionesKanayDia)
            .clamp(0.0, double.infinity); // Evitar valores negativos

        _data[rowIndex]['camiones_terceros_dia'] =
            camionesTercerosDia.toStringAsFixed(2);
      }

      // Actualizar "N° Camiones terceros noche"
      if (key == 'camiones_kanay_noche' || key == 'cantidad_camiones_noche') {
        double camionesNocheTotales = _getValueOrDefault(_data[rowIndex][
            'cantidad_camiones_noche']); // Asumiendo que es la misma cantidad total
        double camionesKanayNoche = double.tryParse(
                _data[rowIndex]['camiones_kanay_noche']?.toString() ?? '0') ??
            0.0;

        double camionesTercerosNoche =
            (camionesNocheTotales - camionesKanayNoche)
                .clamp(0.0, double.infinity); // Evitar valores negativos

        _data[rowIndex]['camiones_terceros_noche'] =
            camionesTercerosNoche.toStringAsFixed(2);
      }
    });
  }

  double _getValueOrDefault(dynamic value) {
    return value != null ? double.tryParse(value.toString()) ?? 0.0 : 0.0;
  }

  Future<void> _saveRow(int rowIndex) async {
    final row = _data[rowIndex];
    final response = await http.post(
      Uri.parse('https://yourapi.com/save'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fecha': row['fecha'],
        'camiones_kanay_dia': row['camiones_kanay_dia'],
        'camiones_kanay_noche': row['camiones_kanay_noche'],
        'causal_operativas': row['causal_operativas'],
        'causal_administrativas': row['causal_administrativas'],
        'causal_derivadas': row['causal_derivadas'],
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar datos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Recepción de unidades'),
      ),
      endDrawer: NavOptionsView(options: [
        NavOption(
          title: 'DISTRIBUCIÓN DE INGRESO DE CAMIONES',
          icon: Icons.pie_chart,
          targetView: const PieChartGrafic(
            values: [2, 2, 16],
            colors: [Colors.blue, Colors.orange, Colors.grey],
            labels: ['', '', ''],
          ),
        ),
        // NavOption(
        //   title: 'CANTIDAD DE CAMIONES QUE INGRESAN AL ECOCENTRO',
        //   icon: Icons.pie_chart,
        //   targetView: const OcupabilidadPlataforma(),
        // ),
        NavOption(
          title: 'CAMIONES - ACUM.',
          icon: Icons.pie_chart,
          targetView: const PieChartGrafic(
            values: [150, 156, 58, 852],
            colors: [Colors.blue, Colors.orange, Colors.grey, Colors.yellow],
            labels: [
              'Camiones / Dia',
              'Camiones / Noche',
            ],
          ),
        ),
        // NavOption(
        //   title: 'TONELADAS INGRESADAS',
        //   icon: Icons.pie_chart,
        //   targetView: const OcupabilidadPlataforma(),
        // ),
        NavOption(
          title: 'INGRESO DE RESIDUOS ACUM. (Ton)',
          icon: Icons.pie_chart,
          targetView: const PieChartGrafic(
            values: [3979, 2874, 969, 7408],
            colors: [Colors.blue, Colors.orange, Colors.grey, Colors.yellow],
            labels: [
              'A Deposito',
              'A Plataforma',
              'A Losa',
              'A Balsa',
            ],
          ),
        ),
        // NavOption(
        //   title: 'ECOCENTRO CHILCA/ PROYECCIÓN INGRESO DE RESIDUOS',
        //   icon: Icons.pie_chart,
        //   targetView: const OcupabilidadPlataforma(),
        // ),
        NavOption(
          title: 'Demora en la atención de unidades',
          icon: Icons.pie_chart,
          targetView: const PieChartGrafic(
            values: [50, 40, 10],
            colors: [Colors.blue, Colors.orange, Colors.grey],
            labels: [
              'Casual operativa',
              'Casual administrativas',
              'Casual derivadas al cliente'
            ],
          ),
        ),
      ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('A depósito (Ton)')),
                    DataColumn(label: Text('A Plataforma (Ton)')),
                    DataColumn(label: Text('A Losa-Piscina (Ton)')),
                    DataColumn(label: Text('A Balsa (Ton)')),
                    DataColumn(label: Text('Total ingresado (Ton)')),
                    DataColumn(label: Text('Ingreso de residuos día (Ton)')),
                    DataColumn(label: Text('Ingreso de residuos noche (Ton)')),
                    DataColumn(label: Text('N° camiones día Totales')),
                    DataColumn(label: Text('N° camiones noche Totales')),
                    DataColumn(label: Text('N° Camiones Kanay día')),
                    DataColumn(label: Text('N° Camiones Kanay noche')),
                    DataColumn(label: Text('N° Camiones terceros día')),
                    DataColumn(label: Text('N° Camiones terceros noche')),
                    DataColumn(
                        label:
                            Text('Unidades que superan el tiempo de atención')),
                    DataColumn(label: Text('Causal operativas')),
                    DataColumn(label: Text('Causal administrativas')),
                    DataColumn(label: Text('Causal derivadas al cliente')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: _data
                      .asMap()
                      .map((rowIndex, row) {
                        return MapEntry(
                          rowIndex,
                          DataRow(cells: [
                            DataCell(Text(row['fecha'].toString())),
                            DataCell(Text(_getValueOrDefault(row['deposito'])
                                .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(row['plataforma'])
                                .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(row['piscina'])
                                .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(row['balsa'])
                                .toStringAsFixed(2))),
                            DataCell(Text(
                                _getValueOrDefault(row['total_general'])
                                    .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(row['ingreso_dia'])
                                .toStringAsFixed(2))),
                            DataCell(Text(
                                _getValueOrDefault(row['ingreso_noche'])
                                    .toStringAsFixed(2))),
                            DataCell(Text(
                                _getValueOrDefault(row['cantidad_camiones_dia'])
                                    .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(
                                    row['cantidad_camiones_noche'])
                                .toStringAsFixed(2))),
                            DataCell(
                              TextField(
                                controller: TextEditingController(
                                    text: _getValueOrDefault(
                                            row['camiones_kanay_dia'])
                                        .toString()),
                                onChanged: (value) {
                                  _updateValue(
                                      rowIndex, 'camiones_kanay_dia', value);
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: TextEditingController(
                                    text: _getValueOrDefault(
                                            row['camiones_kanay_noche'])
                                        .toString()),
                                onChanged: (value) {
                                  _updateValue(
                                      rowIndex, 'camiones_kanay_noche', value);
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            DataCell(Text(
                                _getValueOrDefault(row['camiones_terceros_dia'])
                                    .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(
                                    row['camiones_terceros_noche'])
                                .toStringAsFixed(2))),
                            DataCell(Text(_getValueOrDefault(row[
                                    'cantidad_caunidad_supera_tiempomiones_noche'])
                                .toStringAsFixed(
                                    2))), // Este campo se actualizará automáticamente
                            DataCell(
                              TextField(
                                controller: TextEditingController(
                                    text: _getValueOrDefault(
                                            row['causal_operativas'])
                                        .toString()),
                                onSubmitted: (value) => _updateValue(
                                    rowIndex, 'causal_operativas', value),
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: TextEditingController(
                                    text: _getValueOrDefault(
                                            row['causal_administrativas'])
                                        .toString()),
                                onSubmitted: (value) => _updateValue(
                                    rowIndex, 'causal_administrativas', value),
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: TextEditingController(
                                    text: _getValueOrDefault(
                                            row['causal_derivadas'])
                                        .toString()),
                                onSubmitted: (value) => _updateValue(
                                    rowIndex, 'causal_derivadas', value),
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () => _saveRow(rowIndex),
                              ),
                            ),
                          ]),
                        );
                      })
                      .values
                      .toList(),
                ),
              ),
            ),
    );
  }
}
