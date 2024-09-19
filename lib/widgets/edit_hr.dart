import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditHr extends StatefulWidget {
  final Map<String, dynamic>? registro; // Hacemos que el registro sea opcional

  const EditHr({Key? key, this.registro}) : super(key: key);

  @override
  _EditHrState createState() => _EditHrState();
}

class _EditHrState extends State<EditHr> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de los campos del formulario
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _semanaController = TextEditingController();
  TextEditingController _mesController = TextEditingController();
  TextEditingController _maquinariaController = TextEditingController();
  TextEditingController _operadorController = TextEditingController();
  TextEditingController _horometroiController = TextEditingController();
  TextEditingController _horometrofController = TextEditingController();
  TextEditingController _hrtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Si estamos editando, llenamos los controladores con los datos existentes
    if (widget.registro != null) {
      _fechaController.text = widget.registro!['fecha'] ?? '';
      _semanaController.text = widget.registro!['semana'] ?? '';
      _mesController.text = widget.registro!['mes'] ?? '';
      _maquinariaController.text = widget.registro!['maquinaria'] ?? '';
      _operadorController.text = widget.registro!['operador'] ?? '';
      _horometroiController.text = widget.registro!['horometroi'] ?? '';
      _horometrofController.text = widget.registro!['horometrof'] ?? '';
      _hrtController.text = widget.registro!['hrt'] ?? '';
    }
  }

  // Guardar o actualizar el registro
  Future<void> _guardarRegistro() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> datos = {
        'fecha': _fechaController.text,
        'semana': _semanaController.text,
        'mes': _mesController.text,
        'maquinaria': _maquinariaController.text,
        'operador': _operadorController.text,
        'horometro_inicio': _horometroiController.text,
        'horometro_final': _horometrofController.text,
        'hr_trabajadas': _hrtController.text,
      };

      // Verificar si es edición o nuevo registro
      final bool esEdicion = widget.registro != null;
      final String url = esEdicion
          ? 'https://magussystems.com/appsheet/public/api/update-hr' // Actualizar
          : 'https://tu-api.com/crear-hr'; // Crear nuevo registro

      final response = await http.post(
        Uri.parse(url),
        body: esEdicion
            ? {
                ...datos,
                'id': widget.registro!['id']
                    .toString(), // Incluir el ID para actualizar
              }
            : datos, // Solo los datos para creación
      );

      if (response.statusCode == 200) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(esEdicion ? 'Registro actualizado' : 'Registro creado')),
        );
        Navigator.pop(context);
      } else {
        // Mostrar error si falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el registro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.registro == null ? 'Nuevo Registro' : 'Editar Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _semanaController,
                decoration: InputDecoration(labelText: 'Semana'),
              ),
              TextFormField(
                controller: _mesController,
                decoration: InputDecoration(labelText: 'Mes'),
              ),
              TextFormField(
                controller: _maquinariaController,
                decoration: InputDecoration(labelText: 'Maquinaria'),
              ),
              TextFormField(
                controller: _operadorController,
                decoration: InputDecoration(labelText: 'Operador'),
              ),
              TextFormField(
                controller: _horometroiController,
                decoration: InputDecoration(labelText: 'Horometro Inicio'),
              ),
              TextFormField(
                controller: _horometrofController,
                decoration: InputDecoration(labelText: 'Horometro Final'),
              ),
              TextFormField(
                controller: _hrtController,
                decoration: InputDecoration(labelText: 'Hr Trabajadas'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarRegistro,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
