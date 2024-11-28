// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/ocupabilidad_helper.dart';
import 'package:flutter/material.dart';

class IngresosTable extends StatefulWidget {
  // Agregar una GlobalKey para poder acceder a su estado desde otro widget
  static GlobalKey<_IngresosTableState> ingresosTableKey =
      GlobalKey<_IngresosTableState>();
  final int? registro;
  const IngresosTable({super.key, this.registro});

  @override
  _IngresosTableState createState() => _IngresosTableState();
}

class _IngresosTableState extends State<IngresosTable> {
  final List<String> _headers = [
    "Balsa",
    "B1 (m3)",
    "B2 (m3)",
    "B3 (m3)",
    "B4 (m3)",
    "B5 (m3)",
    "B6 (m3)"
  ];

  List<List<String>> _data = [];

  final Set<String> _editableRows = {
    "Ocupabilidad inicial",
    "Recepción directa (m3)",
    "Recepción por Transvase",
    "Salida por Transvase"
  };

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para celdas editables
    for (var row in _data) {
      if (_editableRows.contains(row[0])) {
        for (int i = 1; i < row.length; i++) {
          String key = '${_data.indexOf(row)}_$i';
          if (_controllers[key] == null) {
            _controllers[key] = TextEditingController(text: row[i]);
          }
        }
      }
    }
    _loadDataForEdit(widget.registro ?? 0);
  }

  @override
  void dispose() {
    // Liberar los controladores cuando el widget sea destruido
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Método para calcular ocupabilidad final
  void _calcularOcupabilidadFinal() {
    setState(() {
      for (int i = 1; i < _headers.length; i++) {
        // Llamar al helper para calcular la ocupabilidad
        OcupabilidadHelper.calcularOcupabilidad(i, _controllers, _data);
      }
    });
  }

  Future<void> _loadDataForEdit(int recordId) async {
    try {
      final existingData = await ApiService.fetchTablePtari(recordId);
      setState(() {
        _data = existingData;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $error')),
      );
    }
  }

  // Método para recolectar los datos de la tabla y enviarlos al API
  Map<String, dynamic> getDatosTabla() {
    Map<String, dynamic> datos = {};
    final List<String> headers = ["balsa", "b1", "b2", "b3", "b4", "b5", "b6"];

    for (int i = 1; i < headers.length; i++) {
      var capacidadData = _data[0][i];
      var ocupabilidadInicialData = _data[1][i];
      var recepcionDirecta = _data[2][i];
      var recepcionTransvase = _data[3][i];
      var salidaTransvase = _data[4][i];
      var ocupabilidadFinal = _data[5][i];
      var ocupabilidadFinalPor = _data[6][i];

      datos[headers[i]] = {
        'capacidad': capacidadData,
        'ocupabilidad_inicial': ocupabilidadInicialData,
        'recepcion_directa': recepcionDirecta,
        'recepcion_transvase': recepcionTransvase,
        'salida_transvase': salidaTransvase,
        'ocupabilidad_final': ocupabilidadFinal,
        'ocupabilidad_final_por': ocupabilidadFinalPor,
      };
    }
    return datos;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingresos:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columns: _headers.map((header) {
              return DataColumn(label: Text(header));
            }).toList(),
            rows: _data.map((row) {
              return DataRow(
                cells: row.asMap().entries.map((entry) {
                  int index = entry.key;
                  String cell = entry.value;

                  if (_editableRows.contains(row[0]) && index > 0) {
                    String key = '${_data.indexOf(row)}_$index';
                    TextEditingController controller = _controllers[key] ??
                        TextEditingController(text: row[index]);

                    return DataCell(
                      TextField(
                        controller: controller,
                        onSubmitted: (newValue) {
                          setState(() {
                            // Actualizar el valor en _data y recalcular
                            _data[_data.indexOf(row)][index] = newValue;
                            _controllers[key]?.text = newValue;
                          });
                        },
                      ),
                    );
                  } else {
                    return DataCell(Text(cell));
                  }
                }).toList(),
              );
            }).toList(),
          ),
        ),
        ElevatedButton(
          onPressed: _calcularOcupabilidadFinal,
          child: const Text("Calcular Ocupabilidad Final"),
        ),
      ],
    );
  }
}
