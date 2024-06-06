import 'package:flutter/material.dart';
import 'package:appsech/theme/app_theme.dart';

class Almacen extends StatefulWidget {
  const Almacen({Key? key}) : super(key: key);

  @override
  _AlmacenState createState() => _AlmacenState();
}

class _AlmacenState extends State<Almacen> {
  final List<TextEditingController> _controllersNewTable = List.generate(
    8,
    (index) => TextEditingController(text: '0'),
  );
  final List<DataRow> _dataRows = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Almacen Temporal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Stock inicial (Ton)')),
                    DataColumn(
                        label: Text('Ingreso directo de unidades (Ton)')),
                    DataColumn(label: Text('Residuo Almacenado (Ton)')),
                    DataColumn(label: Text('Peso despachado')),
                    DataColumn(label: Text('Ubicación de despacho')),
                    DataColumn(label: Text('Stock final (Ton)')),
                    DataColumn(label: Text('Meta')),
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
                        title: const Text('Graficas'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('OCUPABILIDAD DE PLATAFORMA'),
                              onTap: () {
                                // Navegar a la siguiente vista cuando se hace clic en la opción
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
