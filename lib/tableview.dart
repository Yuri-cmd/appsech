import 'package:appsech/modalform.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Importa la biblioteca json
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/widgets.dart';
import 'package:appsech/grafica.dart';

class TableView extends StatefulWidget {
  const TableView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  List<Map<String, dynamic>> registros =
      []; // Lista para almacenar los registros

  @override
  void initState() {
    super.initState();
    // Llama a la función para obtener los registros al inicializar la vista
    obtenerRegistros();
  }

  Future<void> obtenerRegistros() async {
    // URL de tu API de Laravel para obtener los registros
    const url = 'https://magussystems.com/appsheet/public/api/get-hr';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON antes de convertirla en una lista de mapas
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        setState(() {
          registros = data;
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
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
            targetView: BarChartSample(),
          ),
          NavOption(
            title: 'Cerrar Sesión',
            icon: Icons.exit_to_app,
            targetView: BarChartSample(),
          ),
          // Añade más opciones aquí
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
              DataColumn(label: Text('MAQ')),
              DataColumn(label: Text('Propia/Alquilada')),
              DataColumn(label: Text('Operador')),
              DataColumn(label: Text('Horometro inicio')),
              DataColumn(label: Text('Horometro final')),
              DataColumn(label: Text('Hr Trabajadas')),
              DataColumn(label: Text('H')),
              DataColumn(label: Text('Actividad')),
              DataColumn(label: Text('Actividad general')),
              DataColumn(label: Text('Descripción específica')),
              DataColumn(label: Text('Ubicación')),
              DataColumn(label: Text('Ubicación General')),
              DataColumn(label: Text('Horometro carga')),
              DataColumn(label: Text('Tipo Combustible')),
              DataColumn(label: Text('Combustible')),
              DataColumn(label: Text('N° de viajes')),
              DataColumn(label: Text('Destino')),
              DataColumn(label: Text('maq')),
              DataColumn(label: Text('COSTO DE ALQUILER Volq (S/.)')),
              DataColumn(label: Text('COSTO OPERADOR (S/.)')),
              DataColumn(label: Text('COSTO ALQUILER EXCAVADORA.')),
              DataColumn(label: Text('COSTO RETROEXCAVADORA')),
              DataColumn(label: Text('COSTO MONT')),
              DataColumn(label: Text('COSTO TOTAL (S/.)')),
              DataColumn(label: Text('BUDGET')),
              DataColumn(label: Text('HEXTRAS')),
            ],
            rows: registros.map((registro) {
              return DataRow(cells: [
                DataCell(Text(registro['fecha'] ?? '')),
                DataCell(Text(registro['semana'] ?? '')),
                DataCell(Text(registro['mes'] ?? '')),
                DataCell(Text(registro['maquinaria'] ?? '')),
                DataCell(Text(registro['maq'] ?? '')),
                DataCell(Text(registro['propiedad'] ?? '')),
                DataCell(Text(registro['operador'] ?? '')),
                DataCell(Text(registro['horometroi'] ?? '')),
                DataCell(Text(registro['horometrof'] ?? '')),
                DataCell(Text(registro['hrt"'] ?? '')),
                DataCell(Text(registro['h'] ?? '')),
                DataCell(Text(registro['actividad'] ?? '')),
                DataCell(Text(registro['actividadg'] ?? '')),
                DataCell(Text(registro['descripcion'] ?? '')),
                DataCell(Text(registro['ubicacion'] ?? '')),
                DataCell(Text(registro['ubicaciong'] ?? '')),
                DataCell(Text(registro['horometroc'] ?? '')),
                DataCell(Text(registro['tipocombustible'] ?? '')),
                DataCell(Text(registro['combustible'] ?? '')),
                DataCell(Text(registro['nviajes'] ?? '')),
                DataCell(Text(registro['destino'] ?? '')),
                DataCell(Text(registro['maqabrev'] ?? '')),
                DataCell(Text(registro['costoAlquilerV'] ?? '')),
                DataCell(Text(registro['costoOperador'] ?? '')),
                DataCell(Text(registro['costoAlquilerE'] ?? '')),
                DataCell(Text(registro['costoRetro'] ?? '')),
                DataCell(Text(registro['costoMont'] ?? '')),
                DataCell(Text(registro['costoTotal'] ?? '')),
                DataCell(Text(registro['budget'] ?? '')),
                DataCell(Text(registro['hextras'] ?? '')),
              ]);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes abrir el modal del formulario Por ejemplo,
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormModal()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
