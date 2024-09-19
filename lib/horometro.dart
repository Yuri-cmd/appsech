import 'dart:io'; // Importa esta librería para trabajar con archivos
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/helper.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/modalform.dart';
import 'package:permission_handler/permission_handler.dart';

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
      print('Error: $e');
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

  Future<void> _editarRegistro(Map<String, dynamic> registro) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHr(registro: registro),
      ),
    );
  }

  Future<void> _descargarExcel() async {
    try {
      // Solicitar permisos
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de almacenamiento denegado')),
        );
        return;
      }

      // Obtener todos los registros
      final allRegistros = await ApiService.getAllRegistros();

      // Crear un archivo Excel
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Agregar encabezados
      sheet.appendRow([
        'Fecha',
        'SEMANA',
        'Mes',
        'Maquinaria',
        'Operador',
        'Horometro inicio',
        'Horometro final',
        'Hr Trabajadas',
      ]);

      // Agregar datos
      for (var registro in allRegistros) {
        sheet.appendRow([
          registro['fecha'],
          registro['semana'],
          registro['mes'],
          registro['maquinaria'],
          registro['operador'],
          registro['horometroi'],
          registro['horometrof'],
          registro['hrt'],
        ]);
      }

      // Obtener directorio
      final directory = await getExternalFilesDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener el directorio')),
        );
        return;
      }

      // Guardar el archivo
      final file = File('${directory.path}/registros.xlsx');
      final bytes = excel.save();
      if (bytes != null) {
        await file.writeAsBytes(bytes);
      }

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Archivo Excel descargado con éxito')),
      );
    } catch (e) {
      print('Error al descargar el archivo Excel: $e');
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
              DataColumn(label: Text('SEMANA')),
              DataColumn(label: Text('Mes')),
              DataColumn(label: Text('Maquinaria')),
              DataColumn(label: Text('Operador')),
              DataColumn(label: Text('Horometro inicio')),
              DataColumn(label: Text('Horometro final')),
              DataColumn(label: Text('Hr Trabajadas')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: registros.map((registro) {
              return DataRow(cells: [
                DataCell(Text(registro['fecha'] ?? '')),
                DataCell(Text(registro['semana'] ?? '')),
                DataCell(Text(registro['mes'] ?? '')),
                DataCell(Text(registro['maquinaria'] ?? '')),
                DataCell(Text(registro['operador'] ?? '')),
                DataCell(Text(registro['horometroi'] ?? '')),
                DataCell(Text(registro['horometrof'] ?? '')),
                DataCell(Text(registro['hrt'] ?? '')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editarRegistro(registro),
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
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'download_button',
            onPressed: _descargarExcel,
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  getExternalFilesDirectory() {}
}
