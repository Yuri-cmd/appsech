// ignore_for_file: unused_field, use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/screens/actividad_screen.dart';
import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:appsech/helpers/form_helpers.dart';

class FormModal extends StatefulWidget {
  final int? registro;
  const FormModal({Key? key, this.registro}) : super(key: key);

  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final List<String> _opcionesPropiaAlquilada = ['Propia', 'Alquilada'];
  DateTime _selectedDate = DateTime.now();
  String? _semana, _mes, _maq, _propiedad, _operador;
  String _maquinaria = '';
  String? _horometroi;
  String _horometrof = '';
  double _horas = 0.0;
  bool? _isCreate;
  String? _nviajes, _destino, _cantidad, _nuevoOperario;
  double _horasTotalesUsadas = 0.0;
  double _horometroCarga = 0.0;
  // Carga de Combustible
  bool _cargaCombustible = false;
  String? _tipoCombustible; // Almacena el tipo de combustible
  final List<String> _opcionesCombustible = [
    'GLP-unid',
    'diesel-gl',
    'gasolina'
  ]; // Opciones de tipo de combustible

  List<String> _maquinariaOptions = [];
  Map<String, dynamic> _selectedMaquinariaDetails = {};
  final TextEditingController _maqController = TextEditingController();
  final List<Map<String, String?>> _actividadesAgregadas = [];

  List<String> _operarios = [];
  bool _otrosSelected = false;
  final TextEditingController _nuevoOperarioController =
      TextEditingController();

  final TextEditingController _horometroiController = TextEditingController();
  final TextEditingController _horometrofController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMaquinariaOptions().then((_) {
      if (widget.registro != null) {
        _loadDataForEdit(widget.registro ?? 0);
      }
    });

    _maqController.addListener(() {
      _maq = _maqController.text;
    });
    _horometroiController.addListener(() {
      // Solo actualiza la variable _horometroi sin establecer el texto del controlador de nuevo
      _horometroi = _horometroiController.text;
    });
  }

  @override
  void dispose() {
    _maqController.dispose();
    _horometroiController.dispose();
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
    final options = await FormModalHelper.fetchMaquinariaOptions();
    setState(() {
      _maquinariaOptions = options;
    });
  }

  Future<void> _fetchMaquinariaDetails(String maquinaria) async {
    final detailsList =
        await FormModalHelper.fetchMaquinariaDetails(maquinaria);
    final horometro = await ApiService.lastHorometro(maquinaria);

    if (detailsList.isNotEmpty) {
      final details = detailsList[0];
      _fetchOperarios(maquinaria);

      setState(() {
        _selectedMaquinariaDetails = details;
        _maq = details['tipo'];
        _propiedad = details['propiedad'];
        _maqController.text = _maq ?? '';

        if (widget.registro == null) {
          // Verifica y asigna el valor de horómetro adecuadamente
          _horometroi = horometro.replaceAll('"', '').trim(); // Limpia el valor
          // Asigna al controlador solo si el valor no es nulo
          _horometroiController.text = _horometroi ?? '0.0';
        }
      });
    }
  }

  Future<void> _fetchOperarios(String maquinaria) async {
    final operarios = await ApiService.fetchOperarioMaquinaria(maquinaria);
    setState(() {
      _operarios = operarios;
      _operarios.add('Otros'); // Agregar la opción "Otros"
    });
  }

  Future<void> _loadDataForEdit(int recordId) async {
    // Llamada a la API para obtener los datos del registro por ID
    final existingData = await ApiService.getHorometroOne(recordId);
    setState(() {
      // _selectedDate = DateTime.parse(existingData['fecha']);
      _semana = existingData['semana'];
      _mes = existingData['mes'];
      _maquinaria = existingData['maquinaria'];
      _maqController.text = existingData['maq'];
      _propiedad = existingData['propiedad'];
      _operador = existingData['operador'];
      _horometroCarga = double.parse(existingData['horometroCarga']);
      _horometroiController.text = existingData['horometroi'].toString();
      _horometrofController.text = existingData['horometrof'].toString();
      // _horas = existingData['horas'];
      _fetchMaquinariaDetails(existingData['maquinaria']);
      setState(() {
        _horas = FormModalHelper.calculateHoras(
            existingData['horometroi'].toString(),
            existingData['horometrof'].toString());
      });
      _nviajes = existingData['nviajes']?.toString() ?? '';
      _destino = existingData['destino'];
      _cargaCombustible = existingData['cargaCombustible'] == 1 ? true : false;
      _tipoCombustible = existingData['tipoCombustible'];
      // _cantidadfController.text = existingData['cantidad'].toString();
      _nuevoOperario = existingData['operador'];

      if (_maquinariaOptions.contains(_maquinaria)) {
        _maquinaria = _maquinaria;
      }

      // Limpiar la lista actual y agregar nuevas actividades si existen
      if (existingData.containsKey('actividades')) {
        _actividadesAgregadas
            .clear(); // Limpia las actividades anteriores, si es necesario
        List<dynamic> actividades =
            existingData['actividades']; // Asegúrate de que sea una lista
        for (var actividad in actividades) {
          if (actividad is Map<String, dynamic>) {
            // Crear un nuevo mapa asegurándote de que todas las claves son String
            final Map<String, String?> newActividad = {};
            actividad.forEach((key, value) {
              newActividad[key.toString()] =
                  value?.toString(); // Asegura que el valor sea String
            });
            _actividadesAgregadas.add(newActividad);
          }
        }
      }
    });
  }

  Future<void> _sendFormData() async {
    final formData = FormModalHelper.formDateHorometro(
        _selectedDate,
        _semana,
        _mes,
        _maquinaria,
        _maq,
        _propiedad,
        _operador,
        _horometroi,
        _horometrof,
        _horas,
        _cargaCombustible,
        _tipoCombustible,
        _cantidad,
        _nuevoOperario,
        _horometroCarga,
        _actividadesAgregadas,
        widget.registro);
    _isCreate = widget.registro == null ? true : false;
    await FormModalHelper.sendFormHormetro(formData, _isCreate, context);
  }

// Método para eliminar una actividad
  void _deleteActivity(int index) {
    setState(() {
      _actividadesAgregadas.removeAt(index);
    });
  }

  void _navegarAGrabarActividad() async {
    final nuevaActividad = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarActividadScreen(
            maq: _maqController.text.toLowerCase(),
            maquinaria: _maquinaria,
            onGuardar: (actividad) {
              setState(() {
                // Agrega la nueva actividad a la lista
                _actividadesAgregadas.add(actividad);

                // Actualiza el contador de horas usadas
                double horasActividad =
                    double.tryParse(actividad['horaActividad'] ?? '0') ?? 0.0;
                _horasTotalesUsadas += horasActividad;
              });
            },
            horas: _horas,
            horasTotalesUsadas: _horasTotalesUsadas),
      ),
    );

    if (nuevaActividad != null) {
      // Aquí puedes manejar el resultado si es necesario
    }
  }

  void _editActivity(int index) async {
    // Obtén la actividad que deseas editar
    final actividad = _actividadesAgregadas[index];
    // Navega a la pantalla de agregar actividad con los datos de la actividad a editar
    final updatedActividad = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarActividadScreen(
            maq: _maqController.text.toLowerCase(),
            maquinaria: _maquinaria,
            onGuardar: (actividad) {
              setState(() {
                // Actualiza la actividad editada en la lista
                _actividadesAgregadas[index] = actividad;
              });
            },
            horas: _horas,
            actividad: actividad, // Pasa la actividad a editar
            horasTotalesUsadas: _horasTotalesUsadas),
      ),
    );

    if (updatedActividad != null) {
      // Aquí puedes manejar el resultado si es necesario
    }
  }

  void _updateHoras() {
    setState(() {
      _horas = FormModalHelper.calculateHoras(_horometroi, _horometrof);
    });
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

              // Fecha
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              // Maquinaria
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Maquinaria'),
                value: _maquinariaOptions.contains(_maquinaria)
                    ? _maquinaria
                    : null,
                onChanged: (_maquinaria.isNotEmpty)
                    ? null // Deshabilitar cambios si ya hay una maquinaria seleccionada
                    : (String? newValue) {
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

              // MAQ
              TextFormField(
                controller: _maqController,
                decoration: const InputDecoration(labelText: 'MAQ'),
                onChanged: (value) {
                  setState(() {
                    _maqController.text = value;
                  });
                },
              ),
              // Propia/Alquilada
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

              // Operador
              // Dropdown de operarios
              DropdownButtonFormField<String>(
                value: _operador,
                onChanged: (String? newValue) {
                  setState(() {
                    _operador = newValue;
                    _otrosSelected =
                        newValue == 'Otros'; // Verificar si seleccionó "Otros"
                  });
                },
                items: _operarios.map((String operario) {
                  return DropdownMenuItem<String>(
                    value: operario,
                    child: Text(operario),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Operador'),
              ),

              // Mostrar el campo para un nuevo operario si se selecciona "Otros"
              if (_otrosSelected)
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Nombre del nuevo Operador'),
                  onChanged: (value) {
                    setState(() {
                      _nuevoOperario = value;
                    });
                  },
                ),

              // Horómetro Inicial
              TextFormField(
                controller: _horometroiController,
                decoration:
                    const InputDecoration(labelText: 'Horómetro Inicial'),
                onChanged: (value) {
                  setState(() {
                    _horometroi = value;
                  });
                },
              ),
              TextFormField(
                controller: _horometrofController,
                decoration: const InputDecoration(labelText: 'Horómetro Final'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _horometrof = value;
                  });
                  _updateHoras();
                },
              ),

              // Horas calculadas
              TextFormField(
                decoration: const InputDecoration(labelText: 'Horas'),
                controller: TextEditingController(
                    text: _horas.toString()), // Mejor cambiar a inicialValue
                readOnly: true,
              ),

              // Radio buttons para combustible
              const SizedBox(height: 16.0),
              const Text('¿Cargo combustible?'),
              RadioListTile<bool>(
                title: const Text('Sí'),
                value: true,
                groupValue: _cargaCombustible,
                onChanged: (bool? value) {
                  setState(() {
                    _cargaCombustible = value!;
                  });
                },
              ),
              RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: _cargaCombustible,
                onChanged: (bool? value) {
                  setState(() {
                    _cargaCombustible = value!;
                  });
                },
              ),

              // Mostrar opciones de combustible si selecciona "Sí"
              if (_cargaCombustible) ...[
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Tipo de Combustible'),
                  value: _tipoCombustible,
                  onChanged: (String? newValue) {
                    setState(() {
                      _tipoCombustible = newValue!;
                    });
                  },
                  items:
                      ['GLP-unid', 'diesel-gl', 'gasolina'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Cantidad de Combustible'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _cantidad = value;
                    });
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Horometro de Carga'),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true), // Permite números decimales
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _horometroCarga =
                            0.0; // Valor por defecto si el campo está vacío
                      });
                    } else {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue != null) {
                        setState(() {
                          _horometroCarga = parsedValue;
                        });
                      }
                    }
                  },
                )
              ],
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _navegarAGrabarActividad,
                icon: const Icon(Icons.add,
                    color: Colors.white), // Icono de agregar
                label: const Text('Agregar Actividad'),
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
                      title: Text(actividad['actividadNombre'] ?? ''),
                      subtitle: Text(
                        'Horas: ${actividad['horaActividad'] ?? ''}\nDescripción: ${actividad['descripcion'] ?? ''}\nUbicación: ${actividad['ubicacion'] ?? ''}\nUbicación General: ${actividad['ubicaciong'] ?? ''}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editActivity(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteActivity(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendFormData, // Acción cuando se presiona el botón
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
