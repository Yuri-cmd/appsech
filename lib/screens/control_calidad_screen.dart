// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';

class ControlCalidadSection extends StatefulWidget {
  static GlobalKey<_ControlCalidadSectionState> consumoControlKey =
      GlobalKey<_ControlCalidadSectionState>();
  final int? registro;
  const ControlCalidadSection({super.key, this.registro});

  @override
  _ControlCalidadSectionState createState() => _ControlCalidadSectionState();
}

class _ControlCalidadSectionState extends State<ControlCalidadSection> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchControles(widget.registro ?? 0);
  }

  Future<void> _fetchControles(int recordId) async {
    try {
      List<Map<String, dynamic>> controles =
          await ApiService.fetchControles('control', recordId);
      setState(() {
        _data = controles;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $error')),
      );
    }
  }

  void _addRow() {
    setState(() {
      _data.add({'descripcion': '', 'cantidad': '', 'costo': ''});
    });
  }

  void _guardarValor(int index) async {
    try {
      if (_data[index]['id'] == null) {
        // Se envía el tipo al crear el control
        await ApiService.createControl({
          'descripcion': _data[index]['descripcion'],
          'cantidad': '0',
          'costo': _data[index]['costo'],
          'tipo': 'control',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Control creado con éxito')),
        );
      } else {
        await ApiService.updateControl(_data[index]['id'], _data[index]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Control actualizado con éxito')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $error')),
      );
    }
  }

  void _eliminarControl(int index) async {
    // Mostrar cuadro de confirmación
    bool? confirmacion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este control?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Devuelve "false"
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Devuelve "true"
              },
            ),
          ],
        );
      },
    );

    // Si se confirmó, proceder con la eliminación
    if (confirmacion == true) {
      try {
        if (_data[index]['id'] != null) {
          await ApiService.deleteControl(_data[index]['id']);
        }
        setState(() {
          _data.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Control eliminado con éxito')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $error')),
        );
      }
    }
  }

// Método para obtener los datos
  List<Map<String, dynamic>> getDatosConsumo() {
    return _data; // Devolver los datos actuales de la tabla
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Control de calidad:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: IntrinsicColumnWidth(),
                  4: IntrinsicColumnWidth(), // Columna adicional para el botón de eliminar
                },
                children: [
                  const TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Descripción'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Cantidad'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Valor'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Acción'),
                    ),
                  ]),
                  for (int i = 0; i < _data.length; i++)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _data[i]['descripcion'],
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (newValue) {
                            setState(() {
                              _data[i]['descripcion'] = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _data[i]['cantidad'],
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (newValue) {
                            setState(() {
                              _data[i]['cantidad'] = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _data[i]['costo'],
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (newValue) {
                            setState(() {
                              _data[i]['costo'] = newValue;
                            });
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.save, color: Colors.blue),
                                onPressed: () => _guardarValor(i),
                                tooltip: 'Guardar',
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarControl(i),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          )),
                    ]),
                ],
              ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addRow,
          child: const Text('Agregar Fila'),
        ),
      ],
    );
  }
}
