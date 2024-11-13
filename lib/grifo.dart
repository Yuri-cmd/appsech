// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_field

import 'dart:convert';
import 'package:appsech/helpers/form_helpers.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/widgets/prueba.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appsech/api/api_service.dart';
import 'package:appsech/widgets/widgets.dart';

class Grifo extends StatefulWidget {
  const Grifo({super.key});

  @override
  _GrifoState createState() => _GrifoState();
}

class _GrifoState extends State<Grifo> {
  Future<List<Map<String, dynamic>>>? _reportDataFuture;

  @override
  void initState() {
    super.initState();
    _reportDataFuture =
        fetchData(); // Inicializa el Future al cargar la pantalla
  }

  void _refreshData() {
    setState(() {
      _reportDataFuture =
          fetchData(); // Actualiza el Future para recargar los datos
    });
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://magussystems.com/appsheet/public/api/get-grifo'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _editRecord(Map<String, dynamic> item) {
    // Llama al formulario de registro con los datos del registro a editar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Registro'),
          content: RegistroForm(
            onFormSubmitted: _refreshData,
            editData: item,
          ),
        );
      },
    );
  }

  Future<void> _deleteRecord(String id) async {
    String apiUrl =
        'https://magussystems.com/appsheet/public/api/eliminar-grifo/$id';

    final response = await http.delete(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      _refreshData(); // Actualiza la lista después de eliminar
    } else {
      // Manejo de errores
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('No se pudo eliminar el registro.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Grifo'),
      ),
      endDrawer: NavOptionsView(options: [
        NavOption(
          title: 'Rendimiento de combustible',
          icon: Icons.pie_chart,
          targetView: RendimientoChart(),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegistroForm(
                onFormSubmitted: _refreshData,
              ),
              const SizedBox(height: 20),
              ReporteTable(
                future: _reportDataFuture,
                onEdit: _editRecord, // Pasa la función de editar
                onDelete: _deleteRecord, // Pasa la función de eliminar
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistroForm extends StatefulWidget {
  final VoidCallback onFormSubmitted;
  final Map<String, dynamic>? editData; // Agregar este campo

  const RegistroForm({super.key, required this.onFormSubmitted, this.editData});

  @override
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  final _horometroController = TextEditingController();
  final _combustibleController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _marcaController = TextEditingController();
  final _operarioController = TextEditingController();
  final _abastecimientoController = TextEditingController();
  String? _operario;
  List<String> _operarioOptions = [];
  String? _selectedCombustible;
  String? _selectedMaquinaria;
  String? _marca;
  String? _selectedTipo;
  List<String> _maquinarias = [];

  @override
  void initState() {
    super.initState();
    if (widget.editData != null) {
      _horometroController.text =
          widget.editData!['horometro']?.toString() ?? '';
      _cantidadController.text = widget.editData!['cantidad']?.toString() ?? '';
      _marcaController.text = widget.editData!['marca'] ?? '';
      _selectedMaquinaria = widget.editData!['maquinaria'];
      _selectedCombustible = widget.editData!['combustible'];

      // if (_selectedMaquinaria != null) {
      //   _fetchMaquinariaDetails(
      //       _selectedMaquinaria!); // Usa el operador ! para forzar que no sea null
      // }
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
    if (_formKey.currentState!.validate()) {
      String apiUrl = widget.editData == null
          ? 'https://magussystems.com/appsheet/public/api/registro-grifo'
          : 'https://magussystems.com/appsheet/public/api/editar-grifo/${widget.editData!['id']}';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'maquinaria': _selectedMaquinaria,
        'marca': _marcaController.text,
        'horometro': _horometroController.text,
        'combustible': _selectedCombustible,
        'cantidad': _cantidadController.text,
      });

      if (response.statusCode == (widget.editData == null ? 201 : 200)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Éxito'),
              content: const Text('Registro guardado correctamente.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget
                        .onFormSubmitted(); // Llama a la función de actualización
                  },
                ),
              ],
            );
          },
        );

        _horometroController.clear();
        _combustibleController.clear();
        _cantidadController.clear();
        _marcaController.clear();
        setState(() {
          _selectedMaquinaria = null;
          _selectedCombustible = null;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('No se pudo guardar el registro.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Registro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Dropdown para seleccionar el tipo (Maquinaria, Vehículo, Equipo)
          DropdownButtonFormField<String>(
            value: _selectedTipo,
            decoration: const InputDecoration(labelText: 'Tipo'),
            items: const [
              DropdownMenuItem(value: 'maquinaria', child: Text('Maquinaria')),
              DropdownMenuItem(value: 'vehiculo', child: Text('Vehículo')),
              DropdownMenuItem(value: 'equipo', child: Text('Equipo')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedTipo = value;
                _selectedMaquinaria =
                    null; // Resetea la selección de maquinaria

                // Llama a la función adecuada según el tipo seleccionado
                _loadMaquinarias(value);
              });
            },
          ),

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
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Operario'),
            value: _operario,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _operario = newValue;
                });
                _fetchMaquinariaDetails(newValue);
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
            decoration: const InputDecoration(labelText: 'Abastecimiento'),
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

          TextFormField(
            controller: _horometroController,
            decoration: const InputDecoration(labelText: 'Horómetro de carga'),
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
            decoration: const InputDecoration(labelText: 'Tipo de combustible'),
            items: const [
              DropdownMenuItem(value: 'GLP', child: Text('GLP (balón)')),
              DropdownMenuItem(value: 'Diesel', child: Text('Diesel (gal)')),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese la marca';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.editData == null ? 'Registrar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }
}

class ReporteTable extends StatelessWidget {
  final Future<List<Map<String, dynamic>>>? future;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;

  const ReporteTable(
      {super.key,
      required this.future,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('HC')),
              DataColumn(label: Text('Tipo combustible')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Rendimiento')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: data.map<DataRow>((item) {
              return DataRow(cells: [
                DataCell(Text(item['fecha'] ?? 'N/A')),
                DataCell(Text(item['horometro']?.toString() ?? 'N/A')),
                DataCell(Text(item['tipo']?.toString() ?? 'N/A')),
                DataCell(Text(item['combustible']?.toString() ?? 'N/A')),
                DataCell(Text(item['rendimiento']?.toString() ?? 'N/A')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        onEdit(item);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Asegúrate de que el ID existe en el item
                        if (item['id'] != null) {
                          // Muestra un diálogo de confirmación
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: const Text(
                                    '¿Estás seguro de que deseas eliminar este registro?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el diálogo
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Eliminar'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el diálogo
                                      onDelete(item['id']
                                          .toString()); // Llama a la función de eliminación
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {}
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
