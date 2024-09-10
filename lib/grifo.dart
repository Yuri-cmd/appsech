import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Grifo extends StatelessWidget {
  const Grifo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grifo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RegistroForm(),
              SizedBox(height: 20),
              ReporteTable(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistroForm extends StatefulWidget {
  const RegistroForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistroFormState createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  final _formKey = GlobalKey<FormState>();
  final _maquinariaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _horometroController = TextEditingController();
  final _combustibleController = TextEditingController();
  final _cantidadController = TextEditingController();
  String? _selectedCombustible;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String apiUrl =
          'https://magussystems.com/appsheet/public/api/registro-grifo';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'maquinaria': _maquinariaController.text,
        'modelo': _modeloController.text,
        'horometro': _horometroController.text,
        'combustible': _selectedCombustible,
        'cantidad': _cantidadController.text,
      });

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
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
                  },
                ),
              ],
            );
          },
        );

        _maquinariaController.clear();
        _modeloController.clear();
        _horometroController.clear();
        _combustibleController.clear();
        _cantidadController.clear();
      } else {
        // ignore: use_build_context_synchronously
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
          TextFormField(
            controller: _maquinariaController,
            decoration: const InputDecoration(labelText: 'Maquinaria'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese la maquinaria';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _modeloController,
            decoration: const InputDecoration(labelText: 'Modelo'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el modelo';
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
  const ReporteTable({super.key});

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://magussystems.com/appsheet/public/api/get-grifo'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
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
                DataCell(Text(item['rendimiento']?.toString() ?? 'N/A')),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
