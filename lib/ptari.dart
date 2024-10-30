// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:appsech/theme/app_theme.dart';

class Ptari extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Ptari'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            IngresosTable(),
            const SizedBox(height: 20),
            ProduccionSection(),
            const SizedBox(height: 20),
            ProduccionPtardSection(),
            const SizedBox(height: 20),
            ConsumoInsumosTable(),
            const SizedBox(height: 20),
            ControlCalidadSection(),
            const SizedBox(height: 20),
            ReporteTable(),
          ],
        ),
      ),
    );
  }
}

class IngresosTable extends StatefulWidget {
  @override
  _IngresosTableState createState() => _IngresosTableState();
}

class _IngresosTableState extends State<IngresosTable> {
  final List<String> _headers = [
    "Balsa",
    "B1 (m3)", // Primera columna con cálculo
    "B2 (m3)",
    "B3 (m3)",
    "B4 (m3)",
    "B5 (m3)",
    "B6 (m3)"
  ];

  final List<List<String>> _data = [
    ["Ocupabilidad inicial", "520", "750", "550", "17", "0", "400"],
    ["Recepción directa (m3)", "25", "100", "0", "0", "0", "0"],
    ["Recepción por Transvase", "100", "10", "100", "10", "10", "30"],
    ["Salida por Transvase", "10", "10", "10", "0", "0", "0"],
    [
      "Ocupabilidad final",
      "0",
      "0%",
      "0%",
      "0%",
      "0%",
      "0%"
    ], // Valores calculados
  ];

  final Set<String> _editableRows = {
    "Recepción directa (m3)",
    "Recepción por Transvase",
    "Salida por Transvase"
  };

  // Función para realizar el cálculo y actualizar la fila "Ocupabilidad final"
  void _calcularOcupabilidadFinal() {
    setState(() {
      for (int i = 1; i < _headers.length; i++) {
        double resultado = 0.0;

        // Obtener los valores de las filas B6, B7, B8 y B9
        double b6 = double.tryParse(_data[1][i]) ?? 0.0;
        double b7 = double.tryParse(_data[2][i]) ?? 0.0;
        double b8 = double.tryParse(_data[3][i]) ?? 0.0;
        double b9 = double.tryParse(_data[4][i]) ?? 0.0;

        // Aplicar el cálculo según la columna
        if (i == 1) {
          resultado = (b6 + b7 + b8 - b9) / 1600;
        } else if (i == 2) {
          resultado = (b6 + b7 + b8 - b9) / 250;
        } else if (i == 3) {
          resultado = (b6 + b7 + b8 - b9) / 580;
        } else if (i == 4) {
          resultado = (b6 + b7 + b8 - b9) / 200;
        } else if (i == 5) {
          resultado = (b6 + b7 + b8 - b9) / 224;
        } else if (i == 6) {
          resultado = (b6 + b7 + b8 - b9) / 485;
        }

        // Actualizar el valor en la fila de "Ocupabilidad final"
        _data[4][i] = "${(resultado * 100).toStringAsFixed(2)}%";
      }
    });
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
                cells: row.map((cell) {
                  if (_editableRows.contains(row[0])) {
                    return DataCell(
                      TextField(
                        controller: TextEditingController(text: cell),
                        onSubmitted: (newValue) {
                          setState(() {
                            int columnIndex = row.indexOf(cell);
                            _data[_data.indexOf(row)][columnIndex] = newValue;
                            // Recalcular la ocupabilidad final después de la edición
                            _calcularOcupabilidadFinal();
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

class ProduccionSection extends StatelessWidget {
  final TextEditingController _aguaTratadaController = TextEditingController();
  final TextEditingController _lodosGeneradosController =
      TextEditingController();
  final TextEditingController _aguaRiegoController = TextEditingController();
  final TextEditingController _horasDisponiblesController =
      TextEditingController();
  final TextEditingController _horasMantenimientoController =
      TextEditingController();
  final TextEditingController _paradasOperativasController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Producción:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _aguaTratadaController,
          decoration: const InputDecoration(labelText: 'Agua Tratada (m3)'),
        ),
        TextFormField(
          controller: _lodosGeneradosController,
          decoration: const InputDecoration(labelText: 'Lodos generados (m3)'),
        ),
        TextFormField(
          controller: _aguaRiegoController,
          decoration:
              const InputDecoration(labelText: 'Agua utilizada para riego'),
        ),
        TextFormField(
          controller: _horasDisponiblesController,
          decoration: const InputDecoration(labelText: 'Horas Disponibles'),
        ),
        TextFormField(
          controller: _horasMantenimientoController,
          decoration: const InputDecoration(labelText: 'Horas Mantenimiento'),
        ),
        TextFormField(
          controller: _paradasOperativasController,
          decoration: const InputDecoration(labelText: 'Paradas Operativas'),
        ),
      ],
    );
  }
}

class ProduccionPtardSection extends StatelessWidget {
  final TextEditingController _contometroInicialController =
      TextEditingController();
  final TextEditingController _contometroFinalController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Producción:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _contometroInicialController,
          decoration:
              const InputDecoration(labelText: 'Contómetro inicial (m3)'),
        ),
        TextFormField(
          controller: _contometroFinalController,
          decoration: const InputDecoration(labelText: 'Contómetro final (m3)'),
        ),
      ],
    );
  }
}

class ConsumoInsumosTable extends StatefulWidget {
  @override
  _ConsumoInsumosTableState createState() => _ConsumoInsumosTableState();
}

class _ConsumoInsumosTableState extends State<ConsumoInsumosTable> {
  final List<Map<String, dynamic>> _data = [
    {"descripcion": "Peróxido (L)", "cantidad": "0", "costo": "4.07"},
    {"descripcion": "Sulfato ferroso (L)", "cantidad": "0", "costo": "3.93"},
    {"descripcion": "Ácido sulfúrico (L)", "cantidad": "0", "costo": "3.35"},
    {"descripcion": "Hidróxido de Sodio (L)", "cantidad": "0", "costo": "4.15"},
    {"descripcion": "Coagulante (L)", "cantidad": "0", "costo": "6.15"},
    {"descripcion": "Floculante (L)", "cantidad": "0", "costo": "20.40"},
    {
      "descripcion": "Hipoclorito de sodio (L)",
      "cantidad": "0",
      "costo": "3.37"
    },
  ];

  void _addRow() {
    setState(() {
      // Añadir una nueva fila vacía
      _data.add({'descripcion': '', 'cantidad': '', 'costo': ''});
    });
  }

  void _guardarValor(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Guardado: ${_data[index]['descripcion']} con valor ${_data[index]['costo']}')),
    );
    // print('Guardando valor: ${_data[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Consumo de insumos:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: IntrinsicColumnWidth(), // Para ajustar el tamaño del ícono
          },
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Descripción'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Cantidad'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Costo (Soles) + IGV'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Acción'),
              ),
            ]),
            for (int i = 0; i < _data.length; i++)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['descripcion'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['descripcion'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['cantidad'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['cantidad'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['costo'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['costo'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.save, color: Colors.blue),
                    onPressed: () => _guardarValor(i),
                    tooltip: 'Guardar',
                  ),
                ),
              ]),
          ],
        ),
        const SizedBox(height: 10), // Espacio entre la tabla y el botón
        ElevatedButton(
          onPressed: _addRow, // Llama al método para agregar una fila
          child: const Text('Agregar Fila'),
        ),
      ],
    );
  }
}

class ControlCalidadSection extends StatefulWidget {
  @override
  _ControlCalidadSectionState createState() => _ControlCalidadSectionState();
}

class _ControlCalidadSectionState extends State<ControlCalidadSection> {
  // Datos iniciales
  final List<Map<String, dynamic>> _data = [
    {"descripcion": "pH", "cantidad": "0", "costo": "6.5-8.5"},
    {"descripcion": "DQO (ppm)", "cantidad": "0", "costo": "200"},
    {"descripcion": "DBO (ppm)", "cantidad": "0", "costo": "100"},
    {"descripcion": "N-NH3 (ppm)", "cantidad": "0", "costo": "40"},
    {"descripcion": "AYG (ppm)", "cantidad": "0", "costo": "20"},
    {"descripcion": "SST (ppm)", "cantidad": "0", "costo": "50"},
    {"descripcion": "Coliformes", "cantidad": "0", "costo": "1000"},
  ];

  void _addRow() {
    setState(() {
      // Añadir una nueva fila vacía
      _data.add({'descripcion': '', 'cantidad': '', 'costo': ''});
    });
  }

  void _guardarValor(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Guardado: ${_data[index]['descripcion']} con valor ${_data[index]['costo']}')),
    );
    // print('Guardando valor: ${_data[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Control de calidad:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: IntrinsicColumnWidth(), // Para ajustar el tamaño del ícono
          },
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Descripción'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Cantidad'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Costo (Soles) + IGV'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Acción'),
              ),
            ]),
            for (int i = 0; i < _data.length; i++)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['descripcion'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['descripcion'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['cantidad'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['cantidad'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _data[i]['costo'],
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (newValue) {
                      setState(() {
                        _data[i]['costo'] =
                            newValue; // Guardar el valor actualizado
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.save, color: Colors.blue),
                    onPressed: () => _guardarValor(i),
                    tooltip: 'Guardar',
                  ),
                ),
              ]),
          ],
        ),
        const SizedBox(height: 10), // Espacio entre la tabla y el botón
        ElevatedButton(
          onPressed: _addRow, // Llama al método para agregar una fila
          child: const Text('Agregar Fila'),
        ),
      ],
    );
  }
}

class ReporteTable extends StatelessWidget {
  final List<Map<String, String>> _data = [
    {
      "Fecha": "3/03/2024",
      "Ingreso": "60",
      "Producción PTARBI (m3)": "5",
      "Producción PTARBD (m3)": "5",
      "Horas de operación": "8",
      "Acumulado (m3)": "10",
      "Agua clarificada (m3)": "75",
      "Lodo (m3)": "5",
      "Costo unitario (PEM/m)": "5250",
      "Operatividad (%)": "90%",
      "% Lodo generado": "6%",
    },
    {
      "Fecha": "4/03/2024",
      "Ingreso": "75",
      "Producción PTARBI (m3)": "5",
      "Producción PTARBD (m3)": "7",
      "Horas de operación": "10",
      "Acumulado (m3)": "55",
      "Agua clarificada (m3)": "60",
      "Lodo (m3)": "6",
      "Costo unitario (PEM/m)": "6000",
      "Operatividad (%)": "80%",
      "% Lodo generado": "7%",
    },
    {
      "Fecha": "5/03/2024",
      "Ingreso": "125",
      "Producción PTARBI (m3)": "5",
      "Producción PTARBD (m3)": "60",
      "Horas de operación": "5",
      "Acumulado (m3)": "60",
      "Agua clarificada (m3)": "60",
      "Lodo (m3)": "5",
      "Costo unitario (PEM/m)": "6451",
      "Operatividad (%)": "75%",
      "% Lodo generado": "8%",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reporte:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _data.first.keys.map((String key) {
                return DataColumn(
                  label: Text(key),
                );
              }).toList(),
              rows: _data.map((Map<String, String> item) {
                return DataRow(
                  cells: item.values.map((String value) {
                    return DataCell(
                      TextFormField(
                        initialValue: value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
