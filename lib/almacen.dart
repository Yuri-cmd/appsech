// ignore_for_file: use_build_context_synchronously, deprecated_member_use, null_check_always_fails

import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/chart/charts.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart'; // Para obtener el directorio en el dispositivo
import 'package:open_file/open_file.dart'; // Para abrir archivos en el dispositivo

class Almacen extends StatefulWidget {
  const Almacen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AlmacenState createState() => _AlmacenState();
}

class _AlmacenState extends State<Almacen> {
  final List<DataRow> _dataRows = [];
  String? _latestMeta;
  final TextEditingController _metaController = TextEditingController();
  List<dynamic> _data = []; // Almacenar la data para exportar

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchLatestMeta();
  }

  Future<void> _fetchLatestMeta() async {
    try {
      final response = await ApiService.fetchLatestMeta();
      if (response['success']) {
        setState(() {
          _latestMeta = response['meta']['meta'].toString();
          _metaController.text = _latestMeta ?? "";
        });
      } else {
        setState(() {
          _latestMeta = "No hay meta disponible";
          _metaController.clear();
        });
      }
    } catch (e) {
      setState(() {
        _latestMeta = "Error al obtener la meta";
        _metaController.clear();
      });
    }
  }

  Future<void> _fetchData() async {
    try {
      final response = await ApiService.fetchData();
      _data = response; // Guardar la data para exportar
      _dataRows.clear();

      for (var item in _data) {
        _dataRows.add(DataRow(cells: [
          DataCell(Text(item['fecha'].toString())),
          DataCell(Text(item['stock_inicial'].toString())),
          DataCell(Text(item['ingreso_directo'].toString())),
          DataCell(Text(item['residuo_almacenado'].toString())),
          DataCell(Text(item['peso_despachado'].toString())),
          DataCell(Text(item['stock_final'].toString())),
        ]));
      }

      setState(() {});
    } catch (e) {
      // Manejo de errores
    }
  }

  Future<void> _saveMeta() async {
    try {
      final response = await ApiService.saveMeta(_metaController.text);
      if (response['success']) {
        _fetchLatestMeta();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meta guardada con éxito!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error al guardar la meta.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al guardar la meta.'),
      ));
    }
  }

  Future<void> _generateExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Almacen'];

    // Agregar encabezados
    sheetObject.appendRow([
      'Fecha',
      'Stock inicial (Ton)',
      'Ingreso directo (Ton)',
      'Residuo almacenado (Ton)',
      'Peso despachado (Ton)',
      'Stock final (Ton)',
    ]);

    // Agregar filas de datos
    for (var item in _data) {
      sheetObject.appendRow([
        item['fecha'].toString(),
        item['stock_inicial'].toString(),
        item['ingreso_directo'].toString(),
        item['residuo_almacenado'].toString(),
        item['peso_despachado'].toString(),
        item['stock_final'].toString(),
      ]);
    }

    // Guardar el archivo en el dispositivo
    Directory? directory = await getExternalStorageDirectory();
    String outputFile = "${directory!.path}/AlmacenData.xlsx";
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Archivo Excel guardado en: $outputFile'),
    ));

    OpenFile.open(outputFile);
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Reporte de Almacén'),
              pw.Table.fromTextArray(
                headers: [
                  'Fecha',
                  'Stock inicial (Ton)',
                  'Ingreso directo (Ton)',
                  'Residuo almacenado (Ton)',
                  'Peso despachado (Ton)',
                  'Stock final (Ton)',
                ],
                data: _data.map((item) {
                  return [
                    item['fecha'].toString(),
                    item['stock_inicial'].toString(),
                    item['ingreso_directo'].toString(),
                    item['residuo_almacenado'].toString(),
                    item['peso_despachado'].toString(),
                    item['stock_final'].toString(),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    Directory? directory = await getExternalStorageDirectory();
    String outputFile = "${directory!.path}/AlmacenData.pdf";
    final file = File(outputFile);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Archivo PDF guardado en: $outputFile'),
    ));

    OpenFile.open(outputFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Almacen Temporal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _generateExcel, // Botón para generar el Excel
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePDF, // Botón para generar el PDF
          ),
        ],
      ),
      endDrawer: NavOptionsView(options: [
        NavOption(
          title: 'OCUPABILIDAD DE PLATAFORMA',
          icon: Icons.pie_chart,
          targetView: const OcupabilidadPlataforma(),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _metaController,
                      decoration: const InputDecoration(
                        labelText: 'Última Meta',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveMeta,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PaginatedDataTable(
                header: const Text('Datos del Almacen'),
                rowsPerPage: 10, // Número de filas por página
                columns: const [
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Stock inicial (Ton)')),
                  DataColumn(label: Text('Ingreso directo de unidades (Ton)')),
                  DataColumn(label: Text('Residuo Almacenado (Ton)')),
                  DataColumn(label: Text('Peso despachado')),
                  DataColumn(label: Text('Stock final (Ton)')),
                ],
                source: _DataTableSource(_dataRows), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clase para la fuente de datos del PaginatedDataTable
class _DataTableSource extends DataTableSource {
  final List<DataRow> _dataRows;

  _DataTableSource(this._dataRows);

  @override
  DataRow getRow(int index) {
    if (index >= _dataRows.length) return null!;
    return _dataRows[index];
  }

  @override
  int get rowCount => _dataRows.length;

  bool get hasMoreRows => false;

  @override
  int get selectedRowCount => 0;

  // Implementing the required getter
  @override
  bool get isRowCountApproximate =>
      false; // Set to false if the row count is exact
}
