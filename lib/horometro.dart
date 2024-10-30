// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io'; // Importa esta librería para trabajar con archivos
import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/helper.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/modalform.dart';
import 'package:path_provider/path_provider.dart';

class Horometro extends StatefulWidget {
  const Horometro({super.key});

  @override
  _HorometroState createState() => _HorometroState();
}

class _HorometroState extends State<Horometro> {
  List<Map<String, dynamic>> registros = [];

  @override
  void initState() {
    super.initState();
    obtenerRegistros();
  }

  Future<void> obtenerRegistros() async {
    try {
      final data = await ApiService.getRegistros();
      setState(() {
        registros = data;
      });
    } catch (e) {
      // print('Error: $e');
    }
  }

  Future<void> _eliminarRegistro(int id) async {
    bool? confirmar = await DialogHelper.confirmarEliminar(context);

    if (confirmar == true) {
      final success = await ApiService.eliminarRegistro(id);
      if (success) {
        setState(() {
          registros.removeWhere((registro) => registro['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro eliminado con éxito')),
        );
        obtenerRegistros();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el registro')),
        );
      }
    }
  }

  Future<void> _editarRegistro(int idRegistro) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FormModalEdit(registro: idRegistro),
    //   ),
    // );
  }

  Future<void> _descargarExcel() async {
    try {
      final response = await ApiService.downloadExcel();

      if (response.statusCode == 200) {
        // Obtén el directorio
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo obtener el directorio')),
          );
          return;
        }

        // Guarda el archivo
        final file = File('${directory.path}/registros.xlsx');
        await file.writeAsBytes(response.bodyBytes);

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo Excel descargado con éxito')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al descargar el archivo Excel')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al descargar el archivo Excel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('HR'),
      ),
      endDrawer: NavOptionsView(
        options: [
          NavOption(
            title: 'Cambiar Contraseña',
            icon: Icons.change_circle_outlined,
            targetView: const Placeholder(),
          ),
          NavOption(
            title: 'Cerrar Sesión',
            icon: Icons.exit_to_app,
            targetView: const Placeholder(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Maquinaria')),
              DataColumn(label: Text('MAQ')),
              DataColumn(label: Text('Operador')),
              DataColumn(label: Text('Horometro inicio')),
              DataColumn(label: Text('Horometro final')),
              DataColumn(label: Text('Hr Trabajadas')),
              DataColumn(label: Text('Gasolina')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: registros.map((registro) {
              return DataRow(cells: [
                DataCell(Text(registro['fecha'] ?? '')),
                DataCell(Text(registro['maquinaria'] ?? '')),
                DataCell(Text(registro['maq'] ?? '')),
                DataCell(Text(registro['operador'] ?? '')),
                DataCell(Text(registro['horometroi'] ?? '')),
                DataCell(Text(registro['horometrof'] ?? '')),
                DataCell(Text(registro['horas'] ?? '')),
                DataCell(Text(registro['tipoCombustible'] ?? '-')),
                DataCell(Text(registro['cargaCombustible'] ?? '')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editarRegistro(registro['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _eliminarRegistro(registro['id']),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_button',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormModal()),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'download_button',
            onPressed: _descargarExcel,
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
