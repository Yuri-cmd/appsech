// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/chart/charts.dart';

class Almacen extends StatefulWidget {
  const Almacen({Key? key}) : super(key: key);

  @override
  _AlmacenState createState() => _AlmacenState();
}

class _AlmacenState extends State<Almacen> {
  final List<TextEditingController> _controllersNewTable = List.generate(
    7, // Se debe ajustar según el número de campos en el formulario
    (index) => TextEditingController(),
  );
  final List<DataRow> _dataRows = [];
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitData() async {
    if (_selectedDate == null) {
      // Mostrar alerta si no se ha seleccionado una fecha
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor seleccione una fecha.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Preparar los datos para enviar
    final rowData = {
      'fecha':
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
      'stock_inicial': _controllersNewTable[0].text,
      'ingreso_directo': _controllersNewTable[1].text,
      'residuo_almacenado': _controllersNewTable[2].text,
      'peso_despachado': _controllersNewTable[3].text,
      'ubicacion_despacho': _controllersNewTable[4].text,
      'stock_final': _controllersNewTable[5].text,
      'meta': _controllersNewTable[6].text,
    };

    // Imprimir los datos para verificar
    // print('Datos enviados: $rowData');

    final response = await http.post(
      Uri.parse(
          'https://magussystems.com/appsheet/public/api/almacen-registro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(rowData),
    );

    if (response.statusCode == 200) {
      // Mostrar alerta de éxito
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Datos guardados correctamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Limpiar el estado y los controladores
                  setState(() {
                    _dataRows.add(
                      DataRow(cells: [
                        DataCell(Text(rowData['fecha']!)),
                        DataCell(Text(rowData['stock_inicial']!)),
                        DataCell(Text(rowData['ingreso_directo']!)),
                        DataCell(Text(rowData['residuo_almacenado']!)),
                        DataCell(Text(rowData['peso_despachado']!)),
                        DataCell(Text(rowData['ubicacion_despacho']!)),
                        DataCell(Text(rowData['stock_final']!)),
                        DataCell(Text(rowData['meta']!)),
                        const DataCell(Icon(Icons.done)),
                      ]),
                    );
                    _controllersNewTable
                        // ignore: avoid_function_literals_in_foreach_calls
                        .forEach((controller) => controller.clear());
                    _selectedDate = null;
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      // Mostrar alerta de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No se pudo guardar los datos.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Registro'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _selectDate(context);
                        },
                        child: Text(
                          _selectedDate == null
                              ? 'Seleccionar Fecha'
                              : 'Fecha Seleccionada: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _controllersNewTable[0],
                    decoration:
                        const InputDecoration(labelText: 'Stock inicial (Ton)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _controllersNewTable[1],
                    decoration: const InputDecoration(
                        labelText: 'Ingreso directo de unidades (Ton)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _controllersNewTable[2],
                    decoration: const InputDecoration(
                        labelText: 'Residuo Almacenado (Ton)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _controllersNewTable[3],
                    decoration:
                        const InputDecoration(labelText: 'Peso despachado'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _controllersNewTable[4],
                    decoration: const InputDecoration(
                        labelText: 'Ubicación de despacho'),
                  ),
                  TextFormField(
                    controller: _controllersNewTable[5],
                    decoration:
                        const InputDecoration(labelText: 'Stock final (Ton)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _controllersNewTable[6],
                    decoration: const InputDecoration(labelText: 'Meta'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitData();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Almacen Temporal'),
      ),
      endDrawer: NavOptionsView(options: [
        NavOption(
          title: 'OCUPABILIDAD DE PLATAFORMA',
          icon: Icons.pie_chart,
          targetView: const OcupabilidadPlataforma(),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showAddRecordDialog,
              child: const Text('Añadir Registro'),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Stock inicial (Ton)')),
                  DataColumn(label: Text('Ingreso directo de unidades (Ton)')),
                  DataColumn(label: Text('Residuo Almacenado (Ton)')),
                  DataColumn(label: Text('Peso despachado')),
                  DataColumn(label: Text('Ubicación de despacho')),
                  DataColumn(label: Text('Stock final (Ton)')),
                  DataColumn(label: Text('Meta')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _dataRows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
