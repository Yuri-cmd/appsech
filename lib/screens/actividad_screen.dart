import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:flutter/material.dart';

class AgregarActividadScreen extends StatefulWidget {
  final Function(Map<String, String?>) onGuardar;
  final String maquinaria;
  final String maq;
  final double horas;
  final double horasTotalesUsadas;
  final Map<String, dynamic>? actividad;

  const AgregarActividadScreen(
      {Key? key,
      required this.maq,
      required this.maquinaria,
      required this.onGuardar,
      required this.horas,
      this.actividad,
      required this.horasTotalesUsadas})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AgregarActividadScreenState createState() => _AgregarActividadScreenState();
}

class _AgregarActividadScreenState extends State<AgregarActividadScreen> {
  // Variables para el modal
  int? _actividadId;
  String? _actividadNombre;
  String? _horasActividad,
      _actividadg,
      _descripcion,
      _ubicacion,
      _destinoId,
      _ubicaciong,
      _ubicacionT,
      _nviajes,
      _destino,
      _destinoE,
      _idZona;
  List<Map<String, dynamic>> _actividadOptions = [];
  List<String> _actividadGenerals = [];
  List<String> _ubicacionesGenerales = [];
  List<String> _destinosEspecificos = [];
  List<Map<String, dynamic>> _zonas = [];

  final TextEditingController _horasController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nviajesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchZonas().then((_) {
      _fetchActividades(widget.maquinaria).then((_) {
        if (widget.actividad != null) {
          _horasActividad = widget.actividad!['horaActividad'];
          _horasController.text = _horasActividad ?? '';
          _descripcion = widget.actividad!['descripcion'];
          _descripcionController.text = _descripcion ?? '';
          if (widget.actividad!['actividadNombre'] != null) {
            _actividadNombre = widget.actividad!['actividadNombre'];
          } else {
            _actividadNombre = widget.actividad!['actividad'];
          }
          _fetchActividadGeneralId(
                  _actividadNombre.toString(), widget.maquinaria)
              .then((_) {
            _nviajes = widget.actividad!['nviajes'];
            _nviajesController.text = _nviajes.toString();
            _destino = widget.actividad!['destino'];
            _destinoId = widget.actividad!['destinoId'];
            _fetchActividadGenerals(_actividadId.toString()).then((_) {
              _actividadg = widget.actividad!['actividadGeneral'];
              if (widget.actividad!['idUbi'] != null) {
                _fetchDetalleZona(widget.actividad!['idUbi']).then((_) {
                  // Check if idUbi exists in _zonas and set _ubicacion accordingly
                  if (_zonas
                      .map((e) => e['id'])
                      .contains(widget.actividad!['idUbi'])) {
                    _ubicacion = widget.actividad!['idUbi'];
                    _ubicacionT = widget.actividad!['ubicacion'];
                    _fetchDetalleDestino(_destinoId).then((_) {
                      _destinoE = widget.actividad!['destinoE'];
                    });
                  } else {
                    _ubicacion = null; // Reset if value doesn't exist
                  }
                  _ubicaciong = widget.actividad!['ubicaciong'];
                  setState(() {}); // Update the state after loading everything
                });
              } else {
                _fetchZonaId(widget.actividad!['ubicacion']).then((_) {
                  _fetchDetalleZona(_idZona).then((_) {
                    if (_zonas.map((e) => e['id']).contains(_idZona!.trim())) {
                      _ubicacion = _idZona!.trim(); // Usamos el valor limpio
                      _ubicacionT = widget.actividad!['ubicacion'];
                      _fetchDetalleDestino(_destinoId).then((_) {
                        _destinoE = widget.actividad!['destinoE'];
                      });
                    } else {
                      _ubicacion = null; // Reset if value doesn't exist
                    }

                    _ubicaciong = widget.actividad!['ubicaciong'];
                  });
                });
              }
            });
          });
        }
      });
    });
  }

  Future<void> _fetchActividades(String maquinaria) async {
    final actividades = await FormModalHelper.fetchActividades(maquinaria);
    setState(() {
      _actividadOptions = actividades;
    });
  }

  Future<void> _fetchActividadGenerals(String actividad) async {
    final actividadGeneralsResponse =
        await FormModalHelper.fetchActividadGenerals(actividad);
    setState(() {
      _actividadGenerals = actividadGeneralsResponse.toSet().toList();
      _actividadg = null;
    });
  }

  Future<void> _fetchActividadGeneralId(
      String nombreActividad, String nombreMaquinaria) async {
    final actividadId = await ApiService.fetchActividadGeneralId(
        nombreActividad, nombreMaquinaria);
    setState(() {
      _actividadId = int.tryParse(actividadId);
    });
  }

  Future<void> _fetchZonaId(String zona) async {
    final zonaId = await ApiService.fetchZonaId(zona);
    setState(() {
      _idZona = zonaId;
    });
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
      _ubicaciong = null;
    });
  }

  Future<void> _fetchDetalleDestino(String? ubicacionId) async {
    if (ubicacionId == null) return;
    final zonasDetalle = await FormModalHelper.fetchDetalleZona(ubicacionId);
    setState(() {
      _destinosEspecificos = zonasDetalle.toSet().toList();
    });
  }

  @override
  void dispose() {
    _horasController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Actividad'),
      ),
      body: SingleChildScrollView(
        // Hace que el contenido sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Detalles Adicionales'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _horasController, // Usa el controlador
                decoration: const InputDecoration(labelText: 'Horas'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _horasActividad = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                decoration:
                    const InputDecoration(labelText: 'Actividad General'),
                value:
                    _actividadId, // Usar _actividadId para almacenar el valor seleccionado
                onChanged: (int? newId) async {
                  if (newId != null) {
                    setState(() {
                      _actividadId = newId;

                      // Encuentra y guarda el nombre de la actividad seleccionada
                      final actividadSeleccionada = _actividadOptions
                          .firstWhere((actividad) => actividad['id'] == newId);
                      _actividadNombre = actividadSeleccionada['nombre'];
                    });

                    // Llama a la función para obtener detalles adicionales de la actividad
                    await _fetchActividadGenerals(newId.toString());
                  }
                },
                items: _actividadOptions.map((actividad) {
                  return DropdownMenuItem<int>(
                    value: actividad['id'], // Usa el id como valor
                    child: Text(actividad['nombre']), // Muestra el nombre
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Seleccione una actividad' : null,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Actividad Especifica'),
                value: _actividadg,
                onChanged: (String? newValue) {
                  setState(() {
                    _actividadg = newValue;
                  });
                },
                items: _actividadGenerals.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  setState(() {
                    _descripcion = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Ubicación General'),
                value: _ubicacion,
                onChanged: (String? newValue) {
                  setState(() {
                    // Asegúrate de que el valor seleccionado esté en las opciones
                    if (_zonas.any((zona) => zona['id'] == newValue)) {
                      _ubicacion = newValue;
                      _ubicacionT = _zonas.firstWhere(
                          (zona) => zona['id'] == newValue)['nombre'];
                    } else {
                      _ubicacion = null; // Si no se encuentra, resetea el valor
                    }
                  });
                  _fetchDetalleZona(newValue);
                },
                items: _zonas.map<DropdownMenuItem<String>>((zona) {
                  return DropdownMenuItem<String>(
                    value: zona['id'], // Asegúrate de que esto sea correcto
                    child: Text(zona['nombre']),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Ubicación Especifica'),
                value: _ubicaciong,
                onChanged: (String? newValue) {
                  setState(() {
                    _ubicaciong = newValue;
                  });
                },
                items: _ubicacionesGenerales.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Mostrar campos adicionales si MAQ es volquete
              if (widget.maq == 'volquete') ...[
                TextFormField(
                  controller: _nviajesController,
                  decoration: const InputDecoration(labelText: 'N° de viajes'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _nviajes = value;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Destino'),
                  value: _destinoId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _destinoId = newValue;
                      _destino = _zonas.firstWhere(
                          (zona) => zona['id'] == newValue)['nombre'];
                    });
                    _fetchDetalleDestino(newValue);
                  },
                  items: _zonas.map<DropdownMenuItem<String>>((zona) {
                    return DropdownMenuItem<String>(
                      value: zona['id'], // Asegúrate de que esto sea correcto
                      child: Text(zona['nombre']),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Destino Especifico'),
                  value: _destinoE,
                  onChanged: (String? newValue) {
                    setState(() {
                      _destinoE = newValue;
                    });
                  },
                  items: _destinosEspecificos.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double horasActividad =
                      double.tryParse(_horasActividad ?? '0') ?? 0.0;
                  if (horasActividad > 0) {
                    if (widget.horasTotalesUsadas + horasActividad <=
                        widget.horas) {
                      setState(() {
                        // Guarda la actividad y actualiza las horas
                        widget.onGuardar({
                          'horaActividad': _horasActividad,
                          'actividadNombre': _actividadNombre,
                          'actividadId': _actividadId.toString(),
                          'actividadGeneral': _actividadg,
                          'descripcion': _descripcion,
                          'ubicacion': _ubicacionT,
                          'ubicaciong': _ubicaciong,
                          'idUbi': _ubicacion,
                          'nviajes': _nviajes,
                          'destino': _destino,
                          'destinoId': _destinoId,
                          'destinoE': _destinoE
                        });

// Actualiza horas usadas en esta pantalla

                        // Limpia los campos después de guardar
                        _actividadId = null;
                        _actividadNombre = null;
                        _actividadg = null;
                        _descripcion = null;
                        _ubicacion = null;
                        _ubicaciong = null;
                        _horasActividad = null;
                        _destino = null;
                        _nviajes = null;
                        _destinoId = null;
                        _destinoE = null;
                      });
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Las horas asignadas superan el total disponible.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text('Agregar Actividad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
