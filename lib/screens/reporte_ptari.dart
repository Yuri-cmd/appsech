// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ReportePtari extends StatefulWidget {
  const ReportePtari({super.key});

  @override
  State<ReportePtari> createState() => _ReportePtariState();
}

class _ReportePtariState extends State<ReportePtari> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchControles();
  }

  Future<void> _fetchControles() async {
    try {
      List<Map<String, dynamic>> controles = await ApiService.fetchPtari();
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

  Future<void> _downloadExcel() async {
    try {
      // Verifica el directorio de descargas
      Directory? downloadDir = Directory('/storage/emulated/0/Download');
      if (!(await downloadDir.exists())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pudo encontrar el directorio de descargas')),
        );
        return;
      }

      // Crea el archivo Excel
      var excel = Excel.createExcel();
      Sheet sheet = excel['Reporte'];

      // Escribe los encabezados
      if (_data.isNotEmpty) {
        sheet.appendRow(_data.first.keys.toList());

        // Escribe las filas de datos
        for (var row in _data) {
          sheet.appendRow(row.values.map((e) => e?.toString() ?? '').toList());
        }
      }

      // Guarda el archivo en la carpeta de descargas
      final file = File('${downloadDir.path}/reportePtari.xlsx');
      await file.writeAsBytes(excel.encode()!);

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Archivo Excel descargado con éxito en la carpeta de Descargas')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar el archivo Excel: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Reporte Ptari'),
      ),
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
                          key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    rows: _data.map((Map<String, dynamic> item) {
                      return DataRow(
                        cells: item.values.map((dynamic value) {
                          return DataCell(
                            Text(value != null ? value.toString() : ''),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: _downloadExcel,
        child: const Icon(Icons.download),
      ),
    );
  }
}
