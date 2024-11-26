// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:appsech/screens/tratamiento_create_screen.dart';
import 'package:appsech/screens/tratamiento_table.dart';
import 'package:flutter/material.dart';
import 'package:appsech/screens/tratamiento_detalle.dart';

class Tratamiento extends StatefulWidget {
  const Tratamiento({super.key});

  @override
  _TratamientoState createState() => _TratamientoState();
}

class _TratamientoState extends State<Tratamiento> {
  String selectedZona = 'Todos'; // Zona seleccionada por defecto
  String selectedEstado = 'Todos'; // Estado seleccionado por defecto

  final TextEditingController numeroProcesoController = TextEditingController();

  final TextEditingController ratioVolqueteController = TextEditingController();
  final TextEditingController costoVolqueteController = TextEditingController();
  final TextEditingController ratioExcavadoraController =
      TextEditingController();
  final TextEditingController costoExcavadoraController =
      TextEditingController();
  final TextEditingController rendimientoVolqueteController =
      TextEditingController();
  final TextEditingController rendimientoExcavadoraController =
      TextEditingController();
  final TextEditingController precioCombustibleController =
      TextEditingController();
  final TextEditingController costoCementoController = TextEditingController();

  // Lista de zonas para el filtro
  List<String> zonas = [];
  @override
  void initState() {
    super.initState();
    _fetchZonasEspecificas();
  }

  Future<void> _fetchZonasEspecificas() async {
    final zonasDetalle = await FormModalHelper.fetchZonasEspecificas();
    setState(() {
      zonas = zonasDetalle.toSet().toList();
      zonas.insert(0, 'Todos');
    });
  }

  // Lista de estados para el filtro
  final List<String> estados = ['Todos', 'Pendiente', 'Finalizado'];

  void _mostrarInformacion(BuildContext context, int id) async {
    ApiService apiService = ApiService();
    final detalleList = await apiService.getDetalle(id);

    if (detalleList != null && detalleList.isNotEmpty) {
      final detalle = detalleList[0]; // Extrae el primer elemento de la lista
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Información Detallada'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('N° Proceso: $id'), // Ajusta según tu lógica
                  Text(
                      'Total líquido Tratado (Ton): ${detalle['total_liquido']}'),
                  Text('Total Lodos (Ton): ${detalle['total_lodos']}'),
                  Text(
                      'Total Lixiviados (Ton): ${detalle['total_lixiviados']}'),
                  Text('Cemento utilizado: ${detalle['cemento_utilizado']}'),
                  Text('Tierra Utilizada: ${detalle['tierra_utilizada']}'),
                  Text(
                      'Residuo reutilizado: ${detalle['tierra_estabilizada']}'), // Ajusta según tu lógica
                  Text('Ratio Tierra: ${detalle['ratio_tierra']}'),
                  Text('Ratio Cemento: ${detalle['ratio_cemento']}'),
                  Text('% Humedad: ${detalle['humedad']}'),
                  Text('Lugar de disposición: ${detalle['lugar_disposicion']}'),
                  Text(
                      'Hora máquina volquete: ${detalle['hora_maquina_volquete']}'),
                  Text(
                      'Hora máquina excavadora: ${detalle['hora_maquina_excavadora']}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      // Manejo de error si la solicitud falla
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar información')));
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTratamientos() async {
    return await ApiService
        .obtenerTratamientos(); // Esta es la función que ya tienes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Lógica del modal o ajustes
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedZona,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedZona = newValue!;
                    });
                  },
                  items: zonas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text("Selecciona una zona"),
                ),
                DropdownButton<String>(
                  value: selectedEstado,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEstado = newValue!;
                    });
                  },
                  items: estados.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text("Selecciona un estado"),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(
                    () {}); // Actualiza la pantalla cuando el usuario deslice hacia abajo
              },
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchTratamientos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error al cargar los datos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No hay tratamientos disponibles'));
                  } else {
                    // Filtrar los tratamientos según el estado y zona seleccionados
                    final tratamientos = snapshot.data!.where((tratamiento) {
                      bool filtroEstado = true;
                      if (selectedEstado != 'Todos') {
                        if (selectedEstado == 'Pendiente') {
                          filtroEstado = tratamiento['estado'] == 1;
                        } else if (selectedEstado == 'Finalizado') {
                          filtroEstado = tratamiento['estado'] == 2;
                        }
                      }

                      bool filtroZona = true;
                      if (selectedZona != 'Todos') {
                        filtroZona =
                            tratamiento['ubicacion_general'] == selectedZona;
                      }

                      return filtroEstado && filtroZona;
                    }).toList();

                    return ListView.builder(
                      itemCount: tratamientos.length,
                      itemBuilder: (context, index) {
                        final tratamiento = tratamientos[index];
                        String idTratamiento = tratamiento['id'].toString();
                        String estado = tratamiento['estado'] == 1
                            ? 'Pendiente'
                            : 'Finalizado';

                        return Card(
                          child: ListTile(
                            title: Text(tratamiento['numero_proceso']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Fecha de inicio: ${tratamiento['fecha_inicio']}'),
                                Text(
                                    'Ubicación: ${tratamiento['ubicacion_general']}'),
                                Text('Estado: $estado'),
                              ],
                            ),
                            trailing: tratamiento['estado'] == 1
                                ? IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TratamientoDetalleScreen(
                                                  id: idTratamiento),
                                        ),
                                      );
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () {
                                      _mostrarInformacion(
                                          context, tratamiento['id']);
                                    },
                                  ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => (const TratamientroCreateScreen()),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () async {
                  // Mostrar el modal con el selector de rango de fechas
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    // Navegar a la nueva pantalla y pasar el rango de fechas seleccionado
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TablaTratamientosScreen(
                          startDate: picked.start,
                          endDate: picked.end,
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(
                    Icons.table_chart), // Cambia el ícono si lo deseas
              ),
            ],
          ),
        ],
      ),
    );
  }
}
