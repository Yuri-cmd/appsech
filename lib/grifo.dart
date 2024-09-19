import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    print(response.body);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grifo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegistroForm(
                  onFormSubmitted:
                      _refreshData), // Pasa la función de actualización
              SizedBox(height: 20),
              ReporteTable(
                  future: _reportDataFuture), // Usa el Future actualizado
            ],
          ),
        ),
      ),
    );
  }
}

class RegistroForm extends StatefulWidget {
  final VoidCallback onFormSubmitted;

  const RegistroForm({super.key, required this.onFormSubmitted});

  @override
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  final _horometroController = TextEditingController();
  final _combustibleController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _marcaController = TextEditingController(); // Controlador para la marca
  String? _selectedCombustible;
  String? _selectedMaquinaria;
  List<String> _maquinarias = [];

  @override
  void initState() {
    super.initState();
    _loadMaquinarias();
  }

  Future<void> _loadMaquinarias() async {
    List<String> maquinariaOptions = await fetchMaquinariaOptions();
    setState(() {
      _maquinarias = maquinariaOptions;
    });
  }

  Future<void> _fetchMaquinariaDetails(String maquinaria) async {
    Map<String, dynamic> details = await fetchMaquinariaDetails(maquinaria);
    setState(() {
      _marcaController.text = details['marca']; // Actualiza el campo de marca
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String apiUrl =
          'https://magussystems.com/appsheet/public/api/registro-grifo';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'maquinaria': _selectedMaquinaria,
        'marca': _marcaController.text, // Enviar la marca editable
        'horometro': _horometroController.text,
        'combustible': _selectedCombustible,
        'cantidad': _cantidadController.text,
      });

      if (response.statusCode == 201) {
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
          DropdownButtonFormField<String>(
            value: _selectedMaquinaria,
            decoration: const InputDecoration(labelText: 'Maquinaria'),
            items: _maquinarias.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMaquinaria = newValue!;
              });
              if (newValue != null) {
                _fetchMaquinariaDetails(newValue);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor seleccione una maquinaria';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _marcaController, // Campo editable de marca
            decoration: const InputDecoration(labelText: 'Marca'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese la marca';
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
              DropdownMenuItem(value: 'GLP', child: Text('GLP')),
              DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
              DropdownMenuItem(value: 'Gasolina', child: Text('Gasolina')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCombustible = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor seleccione el tipo de combustible';
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
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}

class ReporteTable extends StatelessWidget {
  final Future<List<Map<String, dynamic>>>? future;

  const ReporteTable({super.key, required this.future});

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
              DataColumn(label: Text('H.i')),
              DataColumn(label: Text('Combustible')),
              DataColumn(label: Text('Rendimiento')),
            ],
            rows: data.map<DataRow>((item) {
              return DataRow(cells: [
                DataCell(Text(item['fecha'] ?? 'N/A')),
                DataCell(Text(item['horometro']?.toString() ?? 'N/A')),
                DataCell(Text(item['combustible']?.toString() ?? 'N/A')),
                DataCell(Text(item['rendimiento'].toString() ?? 'N/A')),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}

// Métodos para obtener la lista de maquinarias y sus detalles
Future<List<String>> fetchMaquinariaOptions() async {
  const String baseUrl = 'https://magussystems.com/appsheet/public/api';
  final url = '$baseUrl/maquinaria';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> maquinariaList = json.decode(response.body);
      return maquinariaList
          .map((maquinaria) => maquinaria['nombre'].toString())
          .toList();
    } else {
      throw Exception('Failed to load maquinaria options');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchMaquinariaDetails(String maquinaria) async {
  const String baseUrl = 'https://magussystems.com/appsheet/public/api';
  final url =
      '$baseUrl/maquinaria/details?nombre=$maquinaria'; // Codificar la maquinaria si tiene espacios o caracteres especiales.
  print('URL: $url'); // Depuración: Verificar la URL

  try {
    final response = await http.get(Uri.parse(url));
    print(
        'Response status: ${response.statusCode}'); // Depuración: Verificar estado de la respuesta
    print(
        'Response body: ${response.body}'); // Depuración: Verificar contenido de la respuesta

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load maquinaria details');
    }
  } catch (e) {
    print('Error: $e'); // Depuración: Imprimir error en consola
    rethrow;
  }
}
