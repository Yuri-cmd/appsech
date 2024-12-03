// ignore_for_file: use_build_context_synchronously, unused_field, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:intl/intl.dart';

class RegistroForm extends StatefulWidget {
  final int? registro;
  const RegistroForm({super.key, this.registro});

  @override
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  final _horometroController = TextEditingController();
  final _combustibleController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _marcaController = TextEditingController();
  final _abastecimientoController = TextEditingController();
  String? _operario;
  List<String> _operarioOptions = [];
  String? _selectedCombustible;
  String? _selectedMaquinaria;
  String? _marca;
  String? _selectedTipo;
  List<String> _maquinarias = [];
  bool? _isCreate;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (widget.registro != null) {
      _loadDataForEdit(widget.registro ?? 0);
    }
  }

  Future<void> _loadMaquinarias(String? tipo) async {
    List<String> maquinariaOptions = await ApiService.fetchTipoVehichulo(tipo);
    setState(() {
      _maquinarias = maquinariaOptions;
    });
  }

  Future<void> _fetchMaquinariaDetails(String maquinaria) async {
    final detailsList =
        await FormModalHelper.fetchMaquinariaDetails(maquinaria);
    _fetchAbastecimientoMaquinaria(maquinaria);
    _fetchCombustibleMaquinaria(maquinaria);
    _fetchOperarioMaquinaria(maquinaria);
    if (detailsList.isNotEmpty) {
    } else {}
  }

  Future<void> _fetchOperarioMaquinaria(String maquinaria) async {
    final options = await ApiService.fetchOperarioMaquinaria(maquinaria);
    setState(() {
      _operarioOptions = options;
    });
  }

  Future<void> _fetchAbastecimientoMaquinaria(String maquinaria) async {
    Map<String, dynamic> details =
        await ApiService.fetchAbastecimientoMaquinaria(maquinaria);
    setState(() {
      _abastecimientoController.text = details['abastecimiento'];
    });
  }

  Future<void> _fetchCombustibleMaquinaria(String maquinaria) async {
    Map<String, dynamic> details =
        await ApiService.fetchCombustibleMaquinaria(maquinaria);
    setState(() {
      _combustibleController.text =
          details['combustible']; // Actualiza el campo de marca
    });
  }

  Future<void> _submitForm() async {
    final formData = FormModalHelper.formDataGrifo(
        _selectedTipo,
        _selectedMaquinaria,
        _operario,
        _abastecimientoController.text,
        _horometroController.text,
        _selectedCombustible,
        _cantidadController.text,
        _marcaController.text,
        _selectedDate,
        widget.registro);
    _isCreate = widget.registro == null ? true : false;
    await FormModalHelper.sendFormGrifo(formData, _isCreate, context);
  }

  Future<void> _loadDataForEdit(int recordId) async {
    // Llamada a la API para obtener los datos del registro por ID
    final existingData = await ApiService.getGrifoOne(recordId);
    setState(() {
      _selectedDate = DateTime.parse(existingData['fecha']);

      _selectedTipo = existingData['tipo'];
      _loadMaquinarias(_selectedTipo).then((_) {
        _selectedMaquinaria = existingData['maquinaria'];
        _fetchMaquinariaDetails(existingData['maquinaria']).then((_) {
          _operario = existingData['operario'];
          _abastecimientoController.text = existingData['abastecimiento'];
          _horometroController.text = existingData['horometro'];
          _selectedCombustible = existingData['combustible'];
          _cantidadController.text = existingData['cantidad'];
          _marcaController.text = existingData['observacion'];
        });
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.registro != null)
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
                DropdownButtonFormField<String>(
                  value: _selectedTipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                        value: 'maquinaria', child: Text('Maquinaria')),
                    DropdownMenuItem(
                        value: 'vehiculo', child: Text('Vehículo')),
                    DropdownMenuItem(value: 'equipo', child: Text('Equipo')),
                    DropdownMenuItem(value: 'Compra', child: Text('Compra')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTipo = value;
                      _selectedMaquinaria =
                          null; // Resetea la selección de maquinaria
                      _selectedMaquinaria = value == 'Compra' ? 'Compra' : null;
                      // Llama a la función adecuada según el tipo seleccionado
                      _loadMaquinarias(value);
                    });
                  },
                ),
                if (_selectedTipo != 'Compra')
                  // Dropdown para seleccionar maquinaria
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Modelo'),
                    value: _maquinarias.contains(_selectedMaquinaria)
                        ? _selectedMaquinaria
                        : null,
                    items: _maquinarias.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMaquinaria = newValue;
                      });
                      if (newValue != null) {
                        _fetchMaquinariaDetails(
                            newValue); // Llamar detalles de maquinaria
                      }
                    },
                  ),
                if (_selectedTipo != 'Compra')
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Operario'),
                    value: _operario,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _operario = newValue;
                        });
                      }
                    },
                    items: _operarioOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                DropdownButtonFormField<String>(
                  value: _abastecimientoController.text.isEmpty
                      ? null
                      : _abastecimientoController.text, // Valor asignado
                  decoration:
                      const InputDecoration(labelText: 'Abastecimiento'),
                  onChanged: (value) {
                    setState(() {
                      _abastecimientoController.text = value!;
                    });
                  },
                  items: <String>[
                    'Interno',
                    'Externo',
                  ] // Aquí agregas las opciones que necesitas
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione una opción';
                    }
                    return null;
                  },
                ),
                if (_selectedTipo != 'Compra')
                  TextFormField(
                    controller: _horometroController,
                    decoration:
                        const InputDecoration(labelText: 'Horómetro de carga'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el horómetro de carga';
                      }
                      return null;
                    },
                  ),
                DropdownButtonFormField<String>(
                  value: _selectedCombustible,
                  decoration:
                      const InputDecoration(labelText: 'Tipo de combustible'),
                  items: const [
                    DropdownMenuItem(value: 'GLP', child: Text('GLP (balón)')),
                    DropdownMenuItem(
                        value: 'Diesel', child: Text('Diesel (gal)')),
                    DropdownMenuItem(
                        value: 'Gasolina', child: Text('Gasolina (gal)')),
                    DropdownMenuItem(value: 'GNV', child: Text('GNV (gal)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCombustible = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor seleccione un tipo de combustible';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la cantidad';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _marcaController, // Campo editable de marca
                  decoration: const InputDecoration(labelText: 'Observacion'),
                  onChanged: (value) {
                    setState(() {
                      _marca = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ));
  }
}
