// ignore_for_file: prefer_const_declarations, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DfPage extends StatefulWidget {
  const DfPage({super.key});

  @override
  _DfPageState createState() => _DfPageState();
}

class _DfPageState extends State<DfPage> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Map<String, String>? residuosData;
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  List<dynamic> dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchResiduosData();
    fetchData();
  }

  Future<void> _fetchResiduosData() async {
    final response = await http.get(Uri.parse(
        'https://magussystems.com/appsheet/public/api/get/zonas/deposito'));

    if (response.statusCode == 200) {
      setState(() {
        residuosData = Map<String, String>.from(json.decode(response.body)[0]);
      });
    } else {
      throw Exception('Failed to load residuos data');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://magussystems.com/appsheet/public/api/get/zonas/deposito/total'));

    if (response.statusCode == 200) {
      setState(() {
        dataList = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _showSuccessMessage() {
    final snackBar = const SnackBar(
      content: Text('Guardado exitoso'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DF')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Datos de Residuo',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            DataTable(
              columns: const [
                DataColumn(label: Text('Lugar')),
                DataColumn(label: Text('R.Directos')),
                DataColumn(label: Text('I.Plataforma')),
              ],
              rows: List.generate(
                6,
                (index) {
                  String key = 'd${(index + 1).toString().padLeft(2, '0')}';
                  return DataRow(cells: [
                    DataCell(Text('D ${index + 1}')),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Text(
                          residuosData != null && residuosData!.containsKey(key)
                              ? residuosData![key] ?? "N/A"
                              : "N/A",
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            labelText: 'Ingreso ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Bombeo de lixiviados',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Buzón de lixiviados',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('m3',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Fecha',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "Seleccionar fecha"),
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Hora inicia',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(GestureDetector(
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            startTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(startTime != null
                            ? "${startTime!.hour}:${startTime!.minute}"
                            : "Seleccionar hora"),
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Hora fin',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(GestureDetector(
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            endTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(endTime != null
                            ? "${endTime!.hour}:${endTime!.minute}"
                            : "Seleccionar hora"),
                      ),
                    )),
                  ]),
                  const DataRow(cells: [
                    DataCell(Text('Buzón 1',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(
                      TextField(
                        keyboardType: TextInputType
                            .number, // Solo permite entradas numéricas
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]),
                  const DataRow(cells: [
                    DataCell(Text('Buzón 2',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(
                      TextField(
                        keyboardType: TextInputType
                            .number, // Solo permite entradas numéricas
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]),
                  const DataRow(cells: [
                    DataCell(Text('Buzón 3',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(
                      TextField(
                        keyboardType: TextInputType
                            .number, // Solo permite entradas numéricas
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const Text('Ubicación D1',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Fecha',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Directo a depósito (Ton)',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ingreso desde Plataforma',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ingreso de Tierra Estabilizada (Ton)',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('H.H',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  ...dataList.map<DataRow>((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['fecha'] ?? '')),
                      DataCell(
                          Text(item['directo_deposito']?.toString() ?? '0')),
                      DataCell(
                          Text(item['ingreso_plataforma']?.toString() ?? '0')),
                      DataCell(Text(item['ingreso_tierra']?.toString() ?? '')),
                      DataCell(Text(item['hh']?.toString() ?? '')),
                    ]);
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes agregar la lógica para guardar los datos
          _showSuccessMessage(); // Muestra el mensaje de guardado exitoso
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
