import 'package:appsech/tableview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormModal extends StatefulWidget {
  const FormModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final List<String> _opcionesPropiaAlquilada = ['Propia', 'Alquilada'];

  DateTime? _selectedDate;
  String? _semana;
  String? _mes;
  String? _maquinaria;
  String? _maq;
  String? _propiedad;
  String? _operador;
  String? _horometroi;
  String? _horometrof;
  String? _hrt;
  String? _h;
  String? _actividad;
  String? _actividadg;
  String? _descripcion;
  String? _ubicacion;
  String? _ubicaciong;
  String? _horometroc;
  String? _tipocombustible;
  String? _combustible;
  String? _nviajes;
  String? _destino;
  String? _maqabrev;
  String? _costoAlquilerV;
  String? _costoOperador;
  String? _costoAlquilerE;
  String? _costoRetro;
  String? _costoMont;
  String? _costoTotal;
  String? _budget;
  String? _hextras;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _sendFormData() async {
    // URL de tu API de Laravel
    const url = 'https://magussystems.com/appsheet/public/api/save-hr';

    // Datos del formulario a enviar
    final formData = {
      'fecha': _selectedDate.toString(), // Ajusta según la estructura de tu API
      'semana': _semana ?? '',
      'mes': _mes ?? '',
      'maquinaria': _maquinaria ?? '',
      'maq': _maq ?? '',
      'propiedad': _propiedad ?? '',
      'operador': _operador ?? '',
      'horometroi': _horometroi ?? '',
      'horometrof': _horometrof ?? '',
      'hrt': _hrt ?? '',
      'h': _h ?? '',
      'actividad': _actividad ?? '',
      'actividadg': _actividadg ?? '',
      'descripcion': _descripcion ?? '',
      'ubicacion': _ubicacion ?? '',
      'ubicaciong': _ubicaciong ?? '',
      'horometroc': _horometroc ?? '',
      'tipocombustible': _tipocombustible ?? '',
      'combustible': _combustible ?? '',
      'nviajes': _nviajes ?? '',
      'destino': _destino ?? '',
      'maqabrev': _maqabrev ?? '',
      'costoAlquilerV': _costoAlquilerV ?? '',
      'costoOperador': _costoOperador ?? '',
      'costoAlquilerE': _costoAlquilerE ?? '',
      'costoRetro': _costoRetro ?? '',
      'costoMont': _costoMont ?? '',
      'costoTotal': _costoTotal ?? '',
      'budget': _budget ?? '',
      'hextras': _hextras ?? '',
    };

    // Realiza la solicitud POST
    final response = await http.post(Uri.parse(url), body: formData);

    // Verifica si la solicitud fue exitosa
    if (response.statusCode == 200) {
      // La solicitud fue exitosa, puedes procesar la respuesta aquí si es necesario
      // ignore: use_build_context_synchronously
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
                  Navigator.of(context).pop(); // Cierra la alerta
                  Navigator.of(context).push(
                    // Navega a TableView
                    MaterialPageRoute(
                      builder: (BuildContext context) => const TableView(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Hubo un error al enviar los datos
      // print('Error al enviar datos: ${response.statusCode}');
    }
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
              const SizedBox(height: 10),
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
                        _selectedDate != null
                            ? "${_selectedDate!.toLocal()}"
                            : 'Selecciona una fecha',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Semana'),
                onChanged: (value) {
                  setState(() {
                    _semana = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mes'),
                onChanged: (value) {
                  setState(() {
                    _mes = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Maquinaria'),
                onChanged: (value) {
                  setState(() {
                    _maquinaria = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'MAQ'),
                onChanged: (value) {
                  setState(() {
                    _maq = value;
                  });
                },
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
                    const InputDecoration(labelText: 'Horometro inicio'),
                onChanged: (value) {
                  setState(() {
                    _horometroi = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Horometro final'),
                onChanged: (value) {
                  setState(() {
                    _horometrof = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hr Trabajadas'),
                onChanged: (value) {
                  setState(() {
                    _hrt = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'H'),
                onChanged: (value) {
                  setState(() {
                    _h = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Actividad'),
                onChanged: (value) {
                  setState(() {
                    _actividad = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Actividad general'),
                onChanged: (value) {
                  setState(() {
                    _actividadg = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Descripción específica'),
                onChanged: (value) {
                  setState(() {
                    _descripcion = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ubicación'),
                onChanged: (value) {
                  setState(() {
                    _ubicacion = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Ubicación General'),
                onChanged: (value) {
                  setState(() {
                    _ubicaciong = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Horometro carga'),
                onChanged: (value) {
                  setState(() {
                    _horometroc = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Tipo Combustible'),
                onChanged: (value) {
                  setState(() {
                    _tipocombustible = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Combustible'),
                onChanged: (value) {
                  setState(() {
                    _combustible = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'N° de viajes'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'maq'),
                onChanged: (value) {
                  setState(() {
                    _maqabrev = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'COSTO DE ALQUILER Volq (S/.)'),
                onChanged: (value) {
                  setState(() {
                    _costoAlquilerV = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'COSTO OPERADOR (S/.)'),
                onChanged: (value) {
                  setState(() {
                    _costoOperador = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'COSTO ALQUILER EXCAVADORA.'),
                onChanged: (value) {
                  setState(() {
                    _costoAlquilerE = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'COSTO RETROEXCAVADORA'),
                onChanged: (value) {
                  setState(() {
                    _costoRetro = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'COSTO MONT'),
                onChanged: (value) {
                  setState(() {
                    _costoMont = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'COSTO TOTAL (S/.)'),
                onChanged: (value) {
                  setState(() {
                    _costoTotal = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'BUDGET'),
                onChanged: (value) {
                  setState(() {
                    _budget = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'HEXTRAS'),
                onChanged: (value) {
                  setState(() {
                    _hextras = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedDate != null ? _sendFormData : null,
        child: const Icon(Icons.save),
      ),
    );
  }
}
