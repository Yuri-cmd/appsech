// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/api/api_service.dart';
import 'package:appsech/screens/tratamiento_table.dart';
import 'package:flutter/material.dart';
import 'package:appsech/screens/tratamiento_detalle.dart';

class Tratamiento extends StatefulWidget {
  const Tratamiento({super.key});

  @override
  _TratamientoState createState() => _TratamientoState();
}

class _TratamientoState extends State<Tratamiento> {
  String selectedZona = 'L1.1'; // Zona seleccionada por defecto
  String selectedEstado = 'Todos'; // Estado seleccionado por defecto

  final TextEditingController numeroProcesoController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaFinController = TextEditingController();
  final TextEditingController ubicacionGeneralController =
      TextEditingController();
  final TextEditingController ubicacionEspecificaController =
      TextEditingController();

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
  final List<String> zonas = [
    'Todos',
    'L1.1',
    'L1.2',
    'L2',
    'L3',
    'P1',
    'P2',
    'P3',
    'P4',
    'P5',
    'D1',
    'D2',
    'D3',
    'D4',
    'D5',
    'PTARI',
    'VES',
    'EVAPORACIÓN'
  ];

  // Lista de estados para el filtro
  final List<String> estados = ['Todos', 'Pendiente', 'Finalizado'];

  Future<String> obtenerUltimoNumeroProceso() async {
    final tratamientos = await ApiService.obtenerTratamientos();
    if (tratamientos.isNotEmpty) {
      final ultimoProceso = tratamientos.last['numero_proceso'];
      return (int.parse(ultimoProceso) + 1).toString().padLeft(3, '0');
    }
    return '001'; // Si no hay registros, iniciar desde '001'
  }

  void _mostrarModal(BuildContext context) async {
    String siguienteNumeroProceso = await obtenerUltimoNumeroProceso();
    numeroProcesoController.text = siguienteNumeroProceso;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Tratamiento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numeroProcesoController,
                  decoration: const InputDecoration(labelText: 'N° Proceso'),
                  readOnly: true,
                ),
                TextField(
                  controller: fechaInicioController,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de inicio'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        fechaInicioController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                TextField(
                  controller: fechaFinController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Fecha Fin'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        fechaFinController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                TextField(
                  controller: ubicacionGeneralController,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación General'),
                ),
                TextField(
                  controller: ubicacionEspecificaController,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación Específica'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String idTratamiento = await _guardarDatos();
                Navigator.of(context).pop();
                if (idTratamiento.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TratamientoDetalleScreen(id: idTratamiento),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error al cargar información')));
    }
  }

  Future<String> _guardarDatos() async {
    final datos = {
      'numero_proceso': numeroProcesoController.text,
      'fecha_inicio': fechaInicioController.text,
      'fecha_fin':
          fechaFinController.text.isEmpty ? null : fechaFinController.text,
      'ubicacion_general': ubicacionGeneralController.text,
      'ubicacion_especifica': ubicacionEspecificaController.text,
    };

    try {
      final idTratamiento = await ApiService.guardarTratamiento(datos);
      return idTratamiento; // Retornar el ID
    } catch (e) {
      // print('Error al enviar los datos: $e');
      return ''; // Retornar un valor vacío en caso de error
    }
  }

  TextField _crearTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }

  void _mostrarModalDatos() {
    // Inicializa los controladores con los datos que necesitas
    ratioVolqueteController.text = "0.013";
    costoVolqueteController.text = "82.5";
    ratioExcavadoraController.text = "0.14";
    costoExcavadoraController.text = "198.75";
    rendimientoVolqueteController.text = "2.5";
    rendimientoExcavadoraController.text = "8";
    precioCombustibleController.text = "14";
    costoCementoController.text = "595";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualizar Costos y Ratios'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _crearTextField(ratioVolqueteController, 'Ratio volquete'),
                _crearTextField(costoVolqueteController, 'Costo volquete'),
                _crearTextField(ratioExcavadoraController, 'Ratio excavadora'),
                _crearTextField(costoExcavadoraController, 'Costo Excavadora'),
                _crearTextField(rendimientoVolqueteController,
                    'Rendimiento volquete (gal/hr)'),
                _crearTextField(rendimientoExcavadoraController,
                    'Rendimiento excavadora (gal/hr)'),
                _crearTextField(
                    precioCombustibleController, 'Precio combustible'),
                _crearTextField(costoCementoController, 'Costo cemento'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí guardarías los datos
                _guardarDatosActualizados();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarDatosActualizados() {
    // Aquí implementas la lógica para guardar los datos, tal vez enviándolos a la API
    // Por ejemplo:
    // final datosActualizados = {
    //   'ratio_volquete': ratioVolqueteController.text,
    //   'costo_volquete': costoVolqueteController.text,
    //   'ratio_excavadora': ratioExcavadoraController.text,
    //   'costo_excavadora': costoExcavadoraController.text,
    //   'rendimiento_volquete': rendimientoVolqueteController.text,
    //   'rendimiento_excavadora': rendimientoExcavadoraController.text,
    //   'precio_combustible': precioCombustibleController.text,
    //   'costo_cemento': costoCementoController.text,
    // };

    // Lógica para guardar estos datos, por ejemplo:
    // ApiService.guardarDatosActualizados(datosActualizados).then((result) {
    //   // Maneja el resultado, muestra un mensaje o actualiza el estado
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Datos actualizados correctamente')),
    //   );
    // }).catchError((error) {
    //   // Manejo de errores
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error al actualizar los datos: $error')),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _mostrarModalDatos, // Botón de Guardar
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: ApiService.obtenerTratamientos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay tratamientos disponibles'));
                } else {
                  // Filtrar los tratamientos según el estado seleccionado
                  final tratamientos = snapshot.data!.where((tratamiento) {
                    if (selectedEstado == 'Todos') return true;
                    if (selectedEstado == 'Pendiente') {
                      return tratamiento['estado'] ==
                          1; // Cambia según tu lógica
                    } else if (selectedEstado == 'Finalizado') {
                      return tratamiento['estado'] ==
                          2; // Cambia según tu lógica
                    }
                    return false; // Para otros casos, si hay
                  }).toList();

                  // ListView con los tratamientos filtrados
                  return ListView.builder(
                    itemCount: tratamientos.length,
                    itemBuilder: (context, index) {
                      final tratamiento = tratamientos[index];
                      String idTratamiento = tratamiento['id'].toString();
                      String estado = tratamiento['estado'] == 1
                          ? 'Pendiente'
                          : 'Finalizado';

                      // Imprimir estado y el ID del tratamiento
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
                              Text('Estado: $estado'), // Agregar el estado aquí
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () => _mostrarModal(context),
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
