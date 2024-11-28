// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously
import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:appsech/widgets/nav_options_view.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/screens/screens.dart';

class Ptari extends StatefulWidget {
  @override
  State<Ptari> createState() => _PtariState();
}

class _PtariState extends State<Ptari> {
  // Método para recolectar los datos de IngresosTable y enviarlos al API
  List<Map<String, dynamic>> _data = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchControles();
  }

  Future<void> _fetchControles() async {
    try {
      List<Map<String, dynamic>> controles = await ApiService.fetchPtariAll();
      setState(() {
        _data = controles;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $error')),
      );
    }
  }

  // Función para capitalizar la primera letra de un String
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Ptari'),
      ),
      endDrawer: NavOptionsView(options: [
        NavOption(
          title: 'Reporte Ptari',
          icon: Icons.report,
          targetView: const ReportePtari(),
        ),
      ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(child: Text('No hay datos disponibles'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _data.first.keys.map((String key) {
                      return DataColumn(
                        label: Text(
                          capitalize(key),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList()
                      ..add(
                        const DataColumn(
                          label: Text(
                            "Acciones",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    rows: _data.map((Map<String, dynamic> item) {
                      return DataRow(
                        cells: item.values.map((dynamic value) {
                          return DataCell(
                            Text(value != null ? value.toString() : ''),
                          );
                        }).toList()
                          ..add(
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Acción de editar
                                  _editarFila(item);
                                },
                              ),
                            ),
                          ),
                      );
                    }).toList(),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_button',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormularioPtari()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Función para manejar la edición
  void _editarFila(Map<String, dynamic> data) {
    var id = data['id'] is int ? data['id'] : int.parse(data['id'].toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar'),
          content: const Text('¿Esta seguro que desea editar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Realizar la acción de guardar
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormularioPtari(
                            registro: id,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
