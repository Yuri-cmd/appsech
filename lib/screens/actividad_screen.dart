import 'package:appsech/helpers/form_helpers.dart';
import 'package:flutter/material.dart';

class AgregarActividadScreen extends StatefulWidget {
  final Function(Map<String, String?>) onGuardar;
  final String maquinaria;
  final String maq;
  final double horas;
  final Map<String, dynamic>? actividad;

  const AgregarActividadScreen(
      {Key? key,
      required this.maq,
      required this.maquinaria,
      required this.onGuardar,
      required this.horas,
      this.actividad})
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
      _ubicaciong,
      _ubicacionT,
      _nviajes,
      _destino;
  double _horasUsadas = 0.0;

  List<Map<String, dynamic>> _actividadOptions = [];
  List<String> _actividadGenerals = [];
  List<String> _ubicacionesGenerales = [];
  List<Map<String, dynamic>> _zonas = [];

  final TextEditingController _horasController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

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
          _actividadId = int.tryParse(widget.actividad!['actividadId'] ?? '');
          _actividadNombre = widget.actividad!['actividadNombre'];
          _nviajes = widget.actividad!['nviajes'];
          _destino = widget.actividad!['destino'];

          _fetchActividadGenerals(_actividadId.toString()).then((_) {
            _actividadg = widget.actividad!['actividadGeneral'];
            _fetchDetalleZona(widget.actividad!['idUbi']).then((_) {
              // Check if idUbi exists in _zonas and set _ubicacion accordingly
              if (_zonas
                  .map((e) => e['id'])
                  .contains(widget.actividad!['idUbi'])) {
                _ubicacion = widget.actividad!['idUbi'];
                _ubicacionT = widget.actividad!['ubicacion'];
              } else {
                _ubicacion = null; // Reset if value doesn't exist
              }
              _ubicaciong = widget.actividad!['ubicaciong'];
              setState(() {}); // Update the state after loading everything
            });
          });
        }
      });
    });
  }

  Future<void> _fetchActividades(String maquinaria) async {
    final actividades = await FormModalHelper.fetchActividades(maquinaria);
    print(actividades);
    setState(() {
      _actividadOptions = actividades;
    });
  }

  Future<void> _fetchActividadGenerals(String actividad) async {
    final actividadGeneralsResponse =
        await FormModalHelper.fetchActividadGenerals(actividad);
    setState(() {
      _actividadGenerals = actividadGeneralsResponse.toSet().toList();
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
                decoration: const InputDecoration(labelText: 'Actividad'),
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
                    const InputDecoration(labelText: 'Actividad General'),
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
                decoration: const InputDecoration(labelText: 'Ubicación'),
                value: _ubicacion,
                onChanged: (String? newValue) {
                  setState(() {
                    _ubicacion = newValue;
                    _ubicacionT = _zonas
                        .firstWhere((zona) => zona['id'] == newValue)['nombre'];
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
                    const InputDecoration(labelText: 'Ubicación General'),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'N° de viajes'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _nviajes = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Destino'),
                  onChanged: (value) {
                    setState(() {
                      _destino = value;
                    });
                  },
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  double horasActividad =
                      double.tryParse(_horasActividad ?? '0') ?? 0.0;
                  if (horasActividad > 0) {
                    if (_horasUsadas + horasActividad <= widget.horas) {
                      setState(() {
                        // Actualiza o agrega la actividad según sea necesario
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
                        });
                        _horasUsadas += horasActividad;
                        _actividadId = null;
                        _actividadNombre = null;
                        _actividadg = null;
                        _descripcion = null;
                        _ubicacion = null;
                        _ubicaciong = null;
                        _horasActividad = null;
                        _destino = null;
                        _nviajes = null;
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
