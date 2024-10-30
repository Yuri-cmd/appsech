// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/api/api_service.dart';
import 'package:appsech/tratamiento.dart';
import 'package:flutter/material.dart';

class TratamientoDetalleScreen extends StatefulWidget {
  final String id;

  const TratamientoDetalleScreen({Key? key, required this.id})
      : super(key: key);

  @override
  _TratamientoDetalleScreenState createState() =>
      _TratamientoDetalleScreenState();
}

class _TratamientoDetalleScreenState extends State<TratamientoDetalleScreen> {
  final List<Map<String, dynamic>> registros = [];
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController ingresoDirectoController =
      TextEditingController();
  final TextEditingController ingresoPlataformaController =
      TextEditingController();
  final TextEditingController ingresoLodoController = TextEditingController();
  final TextEditingController ingresoLixiviadosController =
      TextEditingController();
  final TextEditingController cementoUtilizadoController =
      TextEditingController();
  final TextEditingController tierraUtilizadaController =
      TextEditingController();
  final TextEditingController tierraEstabilizadaController =
      TextEditingController();
  final TextEditingController ubicacionDisposicionController =
      TextEditingController();

  final TextEditingController horaMaquinaVolqueteController =
      TextEditingController();
  final TextEditingController tipoDesvioController = TextEditingController();
  final TextEditingController horaMaquinaExcavadoraController =
      TextEditingController();
  final TextEditingController humedadController = TextEditingController();

  int? _editingIndex; // Para saber si estamos editando una fila

  @override
  void initState() {
    super.initState();
    _obtenerRegistros(); // Cargar los registros al iniciar
  }

  // Método para obtener los registros desde la API
  Future<void> _obtenerRegistros() async {
    try {
      // Llama a tu API para obtener los registros
      List<Map<String, dynamic>> registrosApi =
          await ApiService.obtenerTratamientoDetalles(widget.id);

      setState(() {
        registros.clear(); // Limpiar registros existentes
        registros.addAll(registrosApi); // Agregar registros obtenidos
      });
    } catch (e) {
      // Manejar errores al obtener los registros
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar registros: $e')),
      );
    }
  }

  // Función para mostrar el modal para agregar o editar
  void _mostrarModal({bool isEditing = false}) {
    if (!isEditing) {
      // Si no estamos editando, limpiamos los controladores
      fechaController.clear();
      ingresoDirectoController.clear();
      ingresoPlataformaController.clear();
      ingresoLodoController.clear();
      ingresoLixiviadosController.clear();
      cementoUtilizadoController.clear();
      tierraUtilizadaController.clear();
      tierraEstabilizadaController.clear();
      ubicacionDisposicionController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Registro' : 'Agregar Nuevo Registro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        fechaController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                  readOnly: true,
                ),
                TextField(
                  controller: ingresoDirectoController,
                  decoration:
                      const InputDecoration(labelText: 'Ingreso directo (Ton)'),
                ),
                TextField(
                  controller: ingresoPlataformaController,
                  decoration: const InputDecoration(
                      labelText: 'Ingreso de Plataforma (Ton)'),
                ),
                TextField(
                  controller: ingresoLodoController,
                  decoration:
                      const InputDecoration(labelText: 'Ingreso de Lodo'),
                ),
                TextField(
                  controller: ingresoLixiviadosController,
                  decoration:
                      const InputDecoration(labelText: 'Ingreso de Lixiviados'),
                ),
                TextField(
                  controller: cementoUtilizadoController,
                  decoration: const InputDecoration(
                      labelText: 'Cemento utilizado (Ton)'),
                ),
                TextField(
                  controller: tierraUtilizadaController,
                  decoration: const InputDecoration(
                      labelText: 'Tierra Utilizada (Ton)'),
                ),
                TextField(
                  controller: tierraEstabilizadaController,
                  decoration:
                      const InputDecoration(labelText: 'Tierra estabilizada'),
                ),
                TextField(
                  controller: ubicacionDisposicionController,
                  decoration: const InputDecoration(
                      labelText: 'Ubicación de disposición'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (isEditing && _editingIndex != null) {
                  _editarRegistro(_editingIndex!);
                } else {
                  _agregarRegistro();
                }
                Navigator.of(context).pop(); // Cerrar modal
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Función para agregar un nuevo registro
  void _agregarRegistro() async {
    // Crear un nuevo registro en el formato adecuado
    Map<String, dynamic> nuevoRegistro = {
      'tratamiento_id': widget.id,
      'fecha': fechaController.text,
      'ingreso_directo': ingresoDirectoController.text,
      'ingreso_plataforma': ingresoPlataformaController.text,
      'ingreso_lodo': ingresoLodoController.text,
      'ingreso_lixiviados': ingresoLixiviadosController.text,
      'cemento_utilizado': cementoUtilizadoController.text,
      'tierra_utilizada': tierraUtilizadaController.text,
      'tierra_estabilizada': tierraEstabilizadaController.text,
      'ubicacion_disposicion': ubicacionDisposicionController.text,
    };

    try {
      // Guardar en el servidor
      await ApiService.guardarTratamientoDetalle(nuevoRegistro);

      // Agregar a la lista local
      setState(() {
        registros.add(nuevoRegistro);
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro agregado con éxito')),
      );
    } catch (e) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar registro: $e')),
      );
    }
  }

  // Función para editar un registro
  void _editarRegistro(int index) async {
    String idRegistro = registros[index]['id']
        .toString(); // Suponiendo que 'id' es la clave del registro
    Map<String, dynamic> registroActualizado = {
      'tratamiento_id': widget.id,
      'fecha': fechaController.text,
      'ingreso_directo': ingresoDirectoController.text,
      'ingreso_plataforma': ingresoPlataformaController.text,
      'ingreso_lodo': ingresoLodoController.text,
      'ingreso_lixiviados': ingresoLixiviadosController.text,
      'cemento_utilizado': cementoUtilizadoController.text,
      'tierra_utilizada': tierraUtilizadaController.text,
      'tierra_estabilizada': tierraEstabilizadaController.text,
      'ubicacion_disposicion': ubicacionDisposicionController.text,
    };

    try {
      await ApiService.actualizarTratamientoDetalle(
          idRegistro, registroActualizado);

      setState(() {
        registros[index] =
            registroActualizado; // Actualiza el registro en la lista local
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro editado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar registro: $e')),
      );
    }
  }

  // Función para eliminar un registro
  // En el método _eliminarRegistro
  void _eliminarRegistro(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Eliminar el registro del servidor
                  await ApiService.eliminarTratamientoDetalle(
                      registros[index]['id']);

                  // Eliminar el registro de la lista local
                  setState(() {
                    registros.removeAt(index);
                  });

                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Registro eliminado con éxito')),
                  );
                } catch (e) {
                  // Manejar errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar registro: $e')),
                  );
                }
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Función para inicializar los valores en el modal cuando se edita
  void _inicializarEditarModal(int index) {
    _editingIndex = index;
    fechaController.text = registros[index]['fecha'];
    ingresoDirectoController.text = registros[index]['ingreso_directo'];
    ingresoPlataformaController.text = registros[index]['ingreso_plataforma'];
    ingresoLodoController.text = registros[index]['ingreso_lodo'];
    ingresoLixiviadosController.text = registros[index]['ingreso_lixiviados'];
    cementoUtilizadoController.text = registros[index]['cemento_utilizado'];
    tierraUtilizadaController.text = registros[index]['tierra_utilizada'];
    tierraEstabilizadaController.text = registros[index]['tierra_estabilizada'];
    ubicacionDisposicionController.text =
        registros[index]['ubicacion_disposicion'];
  }

  void _guardarTodo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guardar Datos'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: horaMaquinaVolqueteController,
                  decoration:
                      const InputDecoration(labelText: 'Hora Maquina Volquete'),
                ),
                TextField(
                  controller: tipoDesvioController,
                  decoration: const InputDecoration(labelText: 'Tipo Desvio'),
                ),
                TextField(
                  controller: horaMaquinaExcavadoraController,
                  decoration: const InputDecoration(
                      labelText: 'Hora Maquina Excavadora'),
                ),
                TextField(
                  controller: humedadController,
                  decoration: const InputDecoration(labelText: 'Humedad'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Validar que todos los campos estén llenos
                if (horaMaquinaVolqueteController.text.isEmpty ||
                    tipoDesvioController.text.isEmpty ||
                    horaMaquinaExcavadoraController.text.isEmpty ||
                    humedadController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, completa todos los campos.')),
                  );
                } else {
                  // Aquí puedes agregar la lógica para guardar los datos
                  _guardarDatos();
                  Navigator.of(context).pop(); // Cerrar modal
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarDatos() async {
    // Crear un nuevo registro en el formato adecuado
    Map<String, dynamic> datos = {
      'hora_maquina_volquete': horaMaquinaVolqueteController.text,
      'tipo_desvio': tipoDesvioController.text,
      'hora_maquina_excavadora': horaMaquinaExcavadoraController.text,
      'humedad': humedadController.text,
    };

    try {
      // Guardar en el servidor (suponiendo que tienes un método en ApiService para esto)
      await ApiService.cambiarEstadoTratamiento(widget.id, datos);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados con éxito')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Tratamiento(),
        ),
      );
    } catch (e) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Registros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarTodo, // Botón de Guardar
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Ingreso directo (Ton)')),
            DataColumn(label: Text('Ingreso de Plataforma (Ton)')),
            DataColumn(label: Text('Ingreso de Lodo')),
            DataColumn(label: Text('Ingreso de Lixiviados')),
            DataColumn(label: Text('Cemento utilizado (Ton)')),
            DataColumn(label: Text('Tierra Utilizada (Ton)')),
            DataColumn(label: Text('Tierra estabilizada')),
            DataColumn(label: Text('Ubicación de disposición')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: registros.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> registro = entry.value;
            return DataRow(cells: [
              DataCell(Text(registro['fecha'] ?? '')),
              DataCell(Text(registro['ingreso_directo'] ?? '')),
              DataCell(Text(registro['ingreso_plataforma'] ?? '')),
              DataCell(Text(registro['ingreso_lodo'] ?? '')),
              DataCell(Text(registro['ingreso_lixiviados'] ?? '')),
              DataCell(Text(registro['cemento_utilizado'] ?? '')),
              DataCell(Text(registro['tierra_utilizada'] ?? '')),
              DataCell(Text(registro['tierra_estabilizada'] ?? '')),
              DataCell(Text(registro['ubicacion_disposicion'] ?? '')),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _inicializarEditarModal(index);
                      _mostrarModal(isEditing: true);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _eliminarRegistro(index);
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
