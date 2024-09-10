// ignore_for_file: use_key_in_widget_constructors

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
            ConsumoInsumosSection(),
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

class IngresosTable extends StatelessWidget {
  final List<String> _headers = [
    "Balsa",
    "B1 (m3)",
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
    ["Ocupabilidad final", "34%", "85%", "97%", "86%", "13%", "82%"],
  ];

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
                  return DataCell(Text(cell));
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ProduccionSection extends StatelessWidget {
  final TextEditingController _aguaTratadaController =
      TextEditingController(text: "65");
  final TextEditingController _lodosGeneradosController =
      TextEditingController(text: "5");
  final TextEditingController _aguaRiegoController =
      TextEditingController(text: "30");
  final TextEditingController _horasDisponiblesController =
      TextEditingController();
  final TextEditingController _horasMantenimientoController =
      TextEditingController();
  final TextEditingController _paradasOperativasController =
      TextEditingController(text: "1");

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

class ConsumoInsumosSection extends StatelessWidget {
  final List<Map<String, dynamic>> _data = [
    {"descripcion": "Peróxido (L)", "cantidad": "29.1", "costo": "4.07"},
    {"descripcion": "Ácido sulfúrico (L)", "cantidad": "14", "costo": "3.07"},
    // Agrega más filas según sea necesario
  ];

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
            ]),
            for (var item in _data)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: item['descripcion'],
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: item['cantidad'],
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: item['costo'],
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ]),
          ],
        ),
      ],
    );
  }
}

class ControlCalidadSection extends StatelessWidget {
  final List<Map<String, dynamic>> _data = [
    {"parametro": "pH", "valor": "7.2"},
    {"parametro": "DBO (ppm)", "valor": "221"},
    // Agrega más filas según sea necesario
  ];

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
          },
          children: [
            const TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Parámetro'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Valor'),
              ),
            ]),
            for (var item in _data)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: item['parametro'],
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: item['valor'],
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ]),
          ],
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
