import 'package:flutter/material.dart';
import 'package:appsech/horometro.dart';
import 'package:appsech/api/api_service.dart';
import 'package:intl/intl.dart';

class FormModal extends StatefulWidget {
  const FormModal({super.key});

  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final List<String> _opcionesPropiaAlquilada = ['Propia', 'Alquilada'];
  DateTime _selectedDate = DateTime.now();
  String? _semana;
  String? _mes;
  String? _maquinaria;
  String? _maq;
  String? _propiedad;
  String? _operador;
  String? _horometroi;
  String? _horometrof;
  String? _costoAlquilerV;
  String? _costoOperador;
  String? _costoAlquilerE;
  String? _costoRetro;
  String? _costoMont;
  String? _costoTotal;
  String? _budget;
  String? _hextras;
  String? _horas;

  // Variables para el modal
  String? _horasActividad;
  String? _actividad;
  String? _actividadg;
  String? _descripcion;
  String? _ubicacion;
  String? _ubicaciong;
  String? _ubicacionT;

  List<String> _maquinariaOptions = [];
  List<String> _actividadOptions = [];
  List<String> _actividadGenerals = [];
  List<Map<String, dynamic>> _zonas = [];
  Map<String, dynamic> _selectedMaquinariaDetails = {};
  List<String> _ubicacionesGenerales = [];
  final TextEditingController _maqController = TextEditingController();
  final List<Map<String, String?>> _actividadesAgregadas = [];

  @override
  void initState() {
    super.initState();
    _fetchMaquinariaOptions();
    _fetchZonas();
    _maqController.addListener(() {
      _maq = _maqController.text;
    });
  }

  @override
  void dispose() {
    _maqController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _fetchMaquinariaOptions() async {
    try {
      final options = await ApiService.fetchMaquinariaOptions();
      setState(() {
        _maquinariaOptions = options;
      });
    } catch (e) {
      print('Error fetching maquinaria options: $e');
    }
  }

  Future<void> _fetchMaquinariaDetails(String maquinaria) async {
    try {
      final details = await ApiService.fetchMaquinariaDetails(maquinaria);
      setState(() {
        _selectedMaquinariaDetails = details;
        _maq = details['tipo'];
        _propiedad = details['propiedad'];
        _maqController.text = _maq ?? ''; // Actualiza el controlador
        _fetchActividades(
            maquinaria); // Fetch actividades when maquinaria changes
      });
    } catch (e) {
      print('Error fetching maquinaria details: $e');
    }
  }

  Future<void> _fetchActividades(String maquinaria) async {
    try {
      final actividades =
          await ApiService.fetchMaquinariaActividades(maquinaria);
      setState(() {
        _actividadOptions = actividades;
      });
    } catch (e) {
      print('Error fetching actividades: $e');
    }
  }

  Future<void> _fetchActividadGenerals(String actividad) async {
    try {
      final actividadGeneralsResponse =
          await ApiService.fetchActividadGeneral(actividad);
      print(
          'Actividad Generals Response: $actividadGeneralsResponse'); // Depuración

      setState(() {
        _actividadGenerals = actividadGeneralsResponse;
      });
    } catch (e) {
      print('Error fetching actividad general: $e');
    }
  }

  Future<void> _fetchZonas() async {
    try {
      final zonasResponse = await ApiService.fetchZonas();
      setState(() {
        _zonas = zonasResponse; // Lista de Map<String, dynamic>
      });
    } catch (e) {
      print('Error fetching zonas: $e');
    }
  }

  Future<void> _fetchDetalleZona(String? ubicacionId) async {
    if (ubicacionId == null) return;
    try {
      final zonasDetalle = await ApiService.fetchZonaDetalle(ubicacionId);
      print('pure $zonasDetalle');
      setState(() {
        _ubicacionesGenerales = zonasDetalle;
      });
    } catch (e) {
      print('Error fetching actividades: $e');
    }
  }

  Future<void> _sendFormData() async {
    final formData = {
      'fecha': DateFormat('dd/MM/yyyy').format(_selectedDate),
      'semana': _semana ?? '',
      'mes': _mes ?? '',
      'maquinaria': _maquinaria ?? '',
      'maq': _maq ?? '',
      'propiedad': _propiedad ?? '',
      'operador': _operador ?? '',
      'horometroi': _horometroi ?? '',
      'horometrof': _horometrof ?? '',
      'costoAlquilerV': _costoAlquilerV ?? '',
      'costoOperador': _costoOperador ?? '',
      'costoAlquilerE': _costoAlquilerE ?? '',
      'costoRetro': _costoRetro ?? '',
      'costoMont': _costoMont ?? '',
      'costoTotal': _costoTotal ?? '',
      'budget': _budget ?? '',
      'hextras': _hextras ?? '',
    };

    try {
      await ApiService.sendFormData(formData);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Los datos se guardaron correctamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Horometro(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving form data: $e');
    }
  }

  void _showDetailsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Asegúrate de que el modal pueda ajustarse al tamaño
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // Ajusta la altura del modal si es necesario
          child: SingleChildScrollView(
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
                    decoration: const InputDecoration(labelText: 'Horas'),
                    onChanged: (value) {
                      setState(() {
                        _horasActividad = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Actividad'),
                    value: _actividad,
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _actividad = newValue;
                        });

                        // Obtener las actividades generales basadas en la actividad seleccionada
                        await _fetchActividadGenerals(newValue);
                      }
                    },
                    items: _actividadOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                    items: _zonas.map<DropdownMenuItem<String>>((zona) {
                      var zonaT = zona['nombre'];
                      return DropdownMenuItem<String>(
                        value: zona['id'],
                        child: Text(zona['nombre']),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _ubicacion = newValue;
                        _ubicacionT = _ubicacionT;
                      });
                      _fetchDetalleZona(
                          newValue); // Asegúrate de actualizar las ubicaciones generales
                    },
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_actividad != null) {
                        setState(() {
                          _actividadesAgregadas.add({
                            'horaActividad': _horasActividad,
                            'actividad': _actividad,
                            'actividadGeneral': _actividadg,
                            'descripcion': _descripcion,
                            'ubicacion': _ubicacionT,
                            'ubicaciong': _ubicaciong,
                          });
                          _actividad = null;
                          _actividadg = null;
                          _descripcion = null;
                          _ubicacion = null;
                          _ubicaciong = null;
                          _horasActividad = null;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Agregar Actividad'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Llena los campos requeridos:'),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Maquinaria'),
                value: _maquinaria,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _maquinaria = newValue;
                    });
                    _fetchMaquinariaDetails(newValue);
                  }
                },
                items: _maquinariaOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _maqController,
                decoration: const InputDecoration(labelText: 'MAQ'),
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Propia/Alquilada'),
                value: _propiedad,
                onChanged: (String? newValue) {
                  setState(() {
                    _propiedad = newValue;
                  });
                },
                items: _opcionesPropiaAlquilada.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Operador'),
                onChanged: (value) {
                  setState(() {
                    _operador = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Horómetro Inicial'),
                onChanged: (value) {
                  setState(() {
                    _horometroi = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Horómetro Final'),
                onChanged: (value) {
                  setState(() {
                    _horometrof = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Horas'),
                onChanged: (value) {
                  setState(() {
                    _horas =
                        value; // Corrige aquí el campo que deseas actualizar
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showDetailsModal,
                child: const Text('Agregar Actividad'),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _actividadesAgregadas.length,
                itemBuilder: (context, index) {
                  final actividad = _actividadesAgregadas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(actividad['actividad'] ?? ''),
                      subtitle: Text(
                        'Horas: ${actividad['horaActividad'] ?? ''}\nDescripción: ${actividad['descripcion'] ?? ''}\nUbicación: ${actividad['ubicacion'] ?? ''}\nUbicación General: ${actividad['ubicaciong'] ?? ''}',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _sendFormData,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
