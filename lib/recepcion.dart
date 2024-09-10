// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:appsech/grafica.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/chart/charts.dart';

class Recepcion extends StatefulWidget {
  const Recepcion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecepcionState createState() => _RecepcionState();
}

class _RecepcionState extends State<Recepcion> {
  final TextEditingController _controllerKanavDia =
      TextEditingController(text: '2');
  final TextEditingController _controllerKanavNoche =
      TextEditingController(text: '0');
  final TextEditingController _controllerTercerosDia =
      TextEditingController(text: '16');
  final TextEditingController _controllerTercerosNoche =
      TextEditingController(text: '2');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _controllerSuperanTiempo =
      TextEditingController(text: '10');
  final TextEditingController _controllerCausalOperativas =
      TextEditingController(text: '4');
  final TextEditingController _controllerCausalAdministrativas =
      TextEditingController(text: '5');
  final TextEditingController _controllerCausalCliente =
      TextEditingController(text: '1');

  final List<TextEditingController> _controllersNewTable = List.generate(
    18,
    (index) => TextEditingController(text: '0'),
  );
  final List<DataRow> _dataRows = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = '1/2/2024'; // Valor inicial
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse('2024-02-01'), // Fecha inicial
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Recepción de unidades'),
      ),
      endDrawer: NavOptionsView(
        options: [
          NavOption(
            title: 'Distribución de ingresos de camiones',
            icon: Icons.pie_chart,
            targetView: const DistribucionIngresos(),
          ),
          NavOption(
            title: 'Cantidad de camiones que ingresan al ecocentro',
            icon: Icons.bar_chart,
            targetView: const CantidadCamiones(),
          ),
          NavOption(
            title: 'Camiones-Acum.',
            icon: Icons.pie_chart,
            targetView: const CamionesAcumlados(),
          ),
          NavOption(
            title: 'Toneladas Ingresadas',
            icon: Icons.bar_chart,
            targetView: const ToneladasIngresadas(),
          ),
          NavOption(
            title: 'Ingreso de residuos Acum',
            icon: Icons.pie_chart,
            targetView: const IngresoResiduos(),
          ),
          NavOption(
            title: 'Ecocentro Chilca',
            icon: Icons.area_chart,
            targetView: BarChartSample(),
          ),
          NavOption(
            title: 'Demora en la atención de unidades',
            icon: Icons.pie_chart,
            targetView: BarChartSample(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                columns: [
                  const DataColumn(label: Text('Fecha')),
                  DataColumn(
                    label: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: SizedBox(
                          width: 150, // or any specific width you want
                          child: TextField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                              hintText: 'Selecciona una fecha',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('N° Camiones Kanav día')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerKanavDia,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('N° Camiones Kanav noche')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerKanavNoche,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('N° Camiones terceros día')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerTercerosDia,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('N° Camiones terceros noche')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerTercerosNoche,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text(
                        'N° unidades que superan el tiempo de atención (2h)')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerSuperanTiempo,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Causal operativas')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerCausalOperativas,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Causal administrativas')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerCausalAdministrativas,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Causal derivadas al cliente')),
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _controllerCausalCliente,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar los datos
                  print('Datos guardados:');
                  print('Fecha: ${_dateController.text}');
                  print('N° Camiones Kanav día: ${_controllerKanavDia.text}');
                  print(
                      'N° Camiones Kanav noche: ${_controllerKanavNoche.text}');
                  print(
                      'N° Camiones terceros día: ${_controllerTercerosDia.text}');
                  print(
                      'N° Camiones terceros noche: ${_controllerTercerosNoche.text}');
                  print(
                      'N° unidades que superan el tiempo de atención (2h): ${_controllerSuperanTiempo.text}');
                  print(
                      'Causal operativas: ${_controllerCausalOperativas.text}');
                  print(
                      'Causal administrativas: ${_controllerCausalAdministrativas.text}');
                  print(
                      'Causal derivadas al cliente: ${_controllerCausalCliente.text}');
                  for (var i = 0; i < _controllersNewTable.length; i++) {
                    print('Campo ${i + 1}: ${_controllersNewTable[i].text}');
                  }
                },
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
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
                  rows: [
                    DataRow(cells: [
                      for (int i = 0; i < _controllersNewTable.length; i++)
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _controllersNewTable[i],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.save),
                          color: Colors.blue,
                          onPressed: () {
                            // Guarda los datos de la fila
                            List<String> rowData = [];
                            for (var i = 0;
                                i < _controllersNewTable.length;
                                i++) {
                              rowData.add(_controllersNewTable[i].text);
                            }
                            // Crea una nueva fila con los datos ingresados
                            DataRow newRow = DataRow(cells: [
                              for (int i = 0; i < rowData.length; i++)
                                DataCell(
                                  Text(rowData[i]),
                                ),
                              const DataCell(
                                Icon(Icons.done),
                              ),
                            ]);
                            // Agrega la nueva fila a la lista de filas de la tabla
                            setState(() {
                              _dataRows.add(newRow);
                            });
                          },
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Opciones'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text(
                                  'DISTRIBUCIÓN DE INGRESO DE CAMIONES'),
                              onTap: () {
                                // Acción al seleccionar la opción 1...
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                  'CANTIDAD DE CAMIONES QUE INGRESAN AL ECOCENTRO'),
                              onTap: () {
                                // Acción al seleccionar la opción 2...
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('CAMIONES - ACUM.'),
                              onTap: () {
                                // Acción al seleccionar la opción 2...
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('TONELADAS'),
                              onTap: () {
                                // Acción al seleccionar la opción 2...
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title:
                                  const Text('INGRESO DE RESIDUOS ACUM. (Ton)'),
                              onTap: () {
                                // Acción al seleccionar la opción 2...
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                  'Demora en la atención de unidades'),
                              onTap: () {
                                // Acción al seleccionar la opción 2...
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.list),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
