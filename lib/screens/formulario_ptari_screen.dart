// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:appsech/api/api_service.dart';
import 'package:appsech/theme/app_theme.dart';
import 'package:appsech/screens/screens.dart';

class FormularioPtari extends StatefulWidget {
  final int? registro;
  const FormularioPtari({super.key, this.registro});

  @override
  State<FormularioPtari> createState() => _FormularioPtariState();
}

class _FormularioPtariState extends State<FormularioPtari> {
  DateTime? selectedDate;
  String? selectedValue;
  // Método para recolectar los datos de IngresosTable y enviarlos al API
  void _guardarDatos(BuildContext context) {
    var ingresosData =
        IngresosTable.ingresosTableKey.currentState?.getDatosTabla();
    var produccionData = ProduccionSection.produccionSectionKey.currentState
        ?.getDatosProduccion();
    var produccionPtardData = ProduccionPtardSection
        .produccionPtardSectionKey.currentState
        ?.getDatosProduccion();
    var consumoInsumosData = ConsumoInsumosTable
        .consumoInsumosTableKey.currentState
        ?.getDatosConsumo();
    var consumoControlData =
        ControlCalidadSection.consumoControlKey.currentState?.getDatosConsumo();

    if (ingresosData != null && produccionData != null) {
      // Crea un solo mapa con todos los datos
      Map<String, dynamic> requestBody = {
        'ingresos': ingresosData,
        'produccion': produccionData,
        'produccion_ptard': produccionPtardData,
        'consumo_insumos': consumoInsumosData,
        'consumo_control': consumoControlData,
      };

      ApiService.saveDatosPtari(requestBody).then((response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados con éxito')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los datos: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron obtener los datos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Ptari'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de selección de fecha
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: selectedDate != null
                    ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                    : '',
              ),
            ),
            const SizedBox(height: 20),

            // Selector de valores
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Turno',
              ),
              value: selectedValue,
              items: const [
                DropdownMenuItem(value: '1', child: Text('1')),
                DropdownMenuItem(value: '2', child: Text('2')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 20),
            IngresosTable(
                key: IngresosTable.ingresosTableKey, registro: widget.registro),
            const SizedBox(height: 20),
            ProduccionSection(
                key: ProduccionSection.produccionSectionKey,
                registro: widget.registro),
            const SizedBox(height: 20),
            ProduccionPtardSection(
                key: ProduccionPtardSection.produccionPtardSectionKey,
                registro: widget.registro),
            const SizedBox(height: 20),
            ConsumoInsumosTable(
                key: ConsumoInsumosTable.consumoInsumosTableKey,
                registro: widget.registro),
            const SizedBox(height: 20),
            ControlCalidadSection(
                key: ControlCalidadSection.consumoControlKey,
                registro: widget.registro),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_button',
        onPressed: () {
          _guardarDatos(context); // Llamar al método de guardar
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
