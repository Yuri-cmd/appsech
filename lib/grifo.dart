// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field

import 'dart:convert';
import 'package:appsech/helpers/helper.dart';
import 'package:appsech/screens/registro_form_grifo.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appsech/api/api_service.dart';

class Grifo extends StatefulWidget {
  const Grifo({super.key});

  @override
  _GrifoState createState() => _GrifoState();
}

class _GrifoState extends State<Grifo> {
  Future<List<Map<String, dynamic>>>? _reportDataFuture;
  String? _selectedTipo;
  String? _selectedMaquinaria; // Modelo seleccionado
  List<String> _maquinarias = []; // Lista de opciones de modelos

  @override
  void initState() {
    super.initState();
    _reportDataFuture = Future.value([]);
  }

  Future<List<Map<String, dynamic>>> fetchData(String? maquinaria) async {
    final response = await http.get(Uri.parse(
        'https://magussystems.com/appsheet/public/api/get-grifo/$maquinaria'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _loadMaquinarias(String? tipo) async {
    List<String> maquinariaOptions = await ApiService.fetchTipoVehichulo(tipo);
    setState(() {
      _maquinarias = maquinariaOptions;
    });
  }

  List<Map<String, dynamic>> _filterData(
      List<Map<String, dynamic>> data, String? selectedMaquinaria) {
    if (selectedMaquinaria == null || selectedMaquinaria.isEmpty) {
      return data; // No se aplica filtro si no hay selección
    }
    return data
        .where((item) =>
            item['maquinaria']?.toLowerCase() ==
            selectedMaquinaria.toLowerCase())
        .toList();
  }

  Future<void> _deleteRecord(int id) async {
    bool? confirmar = await DialogHelper.confirmarEliminar(context);

    if (confirmar == true) {
      final success = await ApiService.eliminarGrifo(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro eliminado con éxito')),
        );
        // Refresca la data después de eliminar
        setState(() {
          _reportDataFuture = fetchData(_selectedMaquinaria);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el registro')),
        );
      }
    }
  }

  Future<void> _editarRegistro(int idRegistro) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroForm(registro: idRegistro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Grifo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTipo,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: const [
                DropdownMenuItem(
                    value: 'maquinaria', child: Text('Maquinaria')),
                DropdownMenuItem(value: 'vehiculo', child: Text('Vehículo')),
                DropdownMenuItem(value: 'equipo', child: Text('Equipo')),
                DropdownMenuItem(value: 'Compra', child: Text('Compra')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTipo = value;
                  _selectedMaquinaria = null; // Resetea el modelo
                  _loadMaquinarias(value);
                  _reportDataFuture = Future.value([]);
                });
              },
            ),
            // Dropdown para seleccionar modelo
            DropdownButtonFormField<String>(
              value: _selectedMaquinaria,
              decoration: const InputDecoration(labelText: 'Modelo'),
              items: _maquinarias.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMaquinaria = value;
                  _reportDataFuture = fetchData(value);
                });
              },
            ),
            // Tabla de datos con filtrado
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _reportDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay datos disponibles'));
                }

                // Filtrar los datos según el modelo seleccionado
                final filteredData =
                    _filterData(snapshot.data!, _selectedMaquinaria);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    columns: const [
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Equipo')),
                      DataColumn(label: Text('HC')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Rendimiento')),
                      DataColumn(label: Text('Tipo combustible')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: filteredData.map<DataRow>((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['fecha'] ?? 'N/A')),
                        DataCell(Text(item['maquinaria'] ?? 'N/A')),
                        DataCell(Text(item['horometro']?.toString() ?? 'N/A')),
                        DataCell(
                            Text(item['combustible']?.toString() ?? 'N/A')),
                        DataCell(
                            Text(item['rendimiento']?.toString() ?? 'N/A')),
                        DataCell(Text(item['tipo']?.toString() ?? 'N/A')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editarRegistro(item['id']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                if (item['id'] != null) {
                                  _deleteRecord(item['id']);
                                }
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_button',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistroForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
