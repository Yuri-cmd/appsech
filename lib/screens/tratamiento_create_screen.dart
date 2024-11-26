// ignore_for_file: use_build_context_synchronously

import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:appsech/screens/tratamiento_detalle.dart';
import 'package:flutter/material.dart';
import 'package:appsech/theme/app_theme.dart';

class TratamientroCreateScreen extends StatefulWidget {
  const TratamientroCreateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TratamientroCreateScreenState createState() =>
      _TratamientroCreateScreenState();
}

class _TratamientroCreateScreenState extends State<TratamientroCreateScreen> {
  List<Map<String, dynamic>> _zonas = [];
  List<String> _ubicacionesGenerales = [];
  String siguienteNumeroProceso = '001';
  String? _ubicacion, _ubicaciong, _ubicacionT;

  final TextEditingController numeroProcesoController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaFinController = TextEditingController();
  final TextEditingController ubicacionEspecificaController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _fetchZonas();
    obtenerUltimoNumeroProceso();
  }

  Future<void> obtenerUltimoNumeroProceso() async {
    final tratamientos = await ApiService.obtenerTratamientos();
    if (tratamientos.isNotEmpty) {
      final ultimoProceso = tratamientos.last['numero_proceso'];
      setState(() {
        numeroProcesoController.text =
            (int.parse(ultimoProceso) + 1).toString().padLeft(3, '0');
      });
    }
  }

  Future<void> _fetchZonas() async {
    final zonasResponse = await FormModalHelper.fetchZonas();
    setState(() {
      _zonas = zonasResponse.toSet().toList();
    });
  }

  Future<void> _fetchDetalleZona(String? ubicacionId) async {
    if (ubicacionId == null) return;
    final zonasDetalle = await FormModalHelper.fetchDetalleZona(ubicacionId);
    setState(() {
      _ubicacionesGenerales = zonasDetalle.toSet().toList();
    });
  }

  Future<String> _guardarDatos() async {
    final datos = {
      'numero_proceso': numeroProcesoController.text,
      'fecha_inicio': fechaInicioController.text,
      'ubicacion_general': _ubicacionT ?? '',
      'ubicacion_especifica': ubicacionEspecificaController.text,
    };

    try {
      final respuesta = await ApiService.guardarTratamiento(datos);
      if (respuesta ==
          'Ya existe un tratamiento pendiente en esta ubicación.') {
        // Mostrar mensaje de error
        mostrarMensajeError(respuesta);
        return '';
      }
      return respuesta; // Retornar el ID si todo está bien
    } catch (e) {
      // Manejar otros errores
      mostrarMensajeError('Hubo un error al guardar los datos.');
      return '';
    }
  }

  void mostrarMensajeError(String mensaje) {
    // Lógica para mostrar el mensaje de error en la UI, por ejemplo con un Snackbar
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Tratamiento'),
        backgroundColor: AppTheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asociar el formulario con la clave
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número de Proceso
              TextFormField(
                controller: numeroProcesoController,
                decoration: const InputDecoration(
                  labelText: 'N° Proceso',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Fecha de Inicio
              TextFormField(
                controller: fechaInicioController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Inicio',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione la fecha de inicio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Ubicación General
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Ubicación General',
                  border: OutlineInputBorder(),
                ),
                value: _ubicacion,
                onChanged: (String? newValue) {
                  setState(() {
                    _ubicacion = newValue;
                    _ubicacionT = _zonas
                        .firstWhere((zona) => zona['id'] == newValue)['nombre'];
                  });
                  _fetchDetalleZona(newValue);
                },
                validator: (value) => value == null
                    ? 'Por favor seleccione una ubicación general'
                    : null,
                items: _zonas.map((zona) {
                  return DropdownMenuItem<String>(
                    value: zona['id'],
                    child: Text(zona['nombre']),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Ubicación Específica
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Ubicación Específica',
                  border: OutlineInputBorder(),
                ),
                value: _ubicaciong,
                onChanged: (String? newValue) {
                  setState(() {
                    _ubicaciong = newValue;
                  });
                },
                validator: (value) => value == null
                    ? 'Por favor seleccione una ubicación específica'
                    : null,
                items: _ubicacionesGenerales.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String idTratamiento = await _guardarDatos();
                      if (idTratamiento.isNotEmpty) {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TratamientoDetalleScreen(id: idTratamiento),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
