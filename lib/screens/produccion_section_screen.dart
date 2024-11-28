// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';

class ProduccionSection extends StatefulWidget {
  // Definir el GlobalKey para acceder al estado de este widget
  static GlobalKey<_ProduccionSectionState> produccionSectionKey =
      GlobalKey<_ProduccionSectionState>();
  final int? registro;
  const ProduccionSection({super.key, this.registro});

  @override
  _ProduccionSectionState createState() => _ProduccionSectionState();
}

class _ProduccionSectionState extends State<ProduccionSection> {
  final TextEditingController _aguaTratadaController = TextEditingController();
  final TextEditingController _lodosGeneradosController =
      TextEditingController();
  final TextEditingController _aguaRiegoController = TextEditingController();
  final TextEditingController _horasDisponiblesController =
      TextEditingController();
  final TextEditingController _horasMantenimientoController =
      TextEditingController();
  final TextEditingController _paradasOperativasController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataForEdit(widget.registro ?? 0);
  }

  // Método para devolver los datos recopilados
  Map<String, dynamic> getDatosProduccion() {
    return {
      'agua_tratada': _aguaTratadaController.text,
      'lodos_generados': _lodosGeneradosController.text,
      'agua_riego': _aguaRiegoController.text,
      'horas_disponibles': _horasDisponiblesController.text,
      'horas_mantenimiento': _horasMantenimientoController.text,
      'paradas_operativas': _paradasOperativasController.text,
    };
  }

  Future<void> _loadDataForEdit(int recordId) async {
    try {
      final existingData = await ApiService.fetchProPtari(recordId);
      setState(() {
        _aguaTratadaController.text = existingData['agua_tratada'] ?? '';
        _lodosGeneradosController.text = existingData['lodos_generados'] ?? '';
        _aguaRiegoController.text = existingData['agua_riego'] ?? '';
        _horasDisponiblesController.text =
            existingData['horas_disponibles'] ?? '';
        _horasMantenimientoController.text =
            existingData['horas_mantenimiento'] ?? '';
        _paradasOperativasController.text =
            existingData['paradas_operativas'] ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Producción:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _aguaTratadaController,
          decoration: const InputDecoration(labelText: 'Agua Tratada (m3)'),
        ),
        TextFormField(
          controller: _lodosGeneradosController,
          decoration: const InputDecoration(labelText: 'Lodos generados (m3)'),
        ),
        TextFormField(
          controller: _aguaRiegoController,
          decoration:
              const InputDecoration(labelText: 'Agua utilizada para riego'),
        ),
        TextFormField(
          controller: _horasDisponiblesController,
          decoration: const InputDecoration(labelText: 'Horas Disponibles'),
        ),
        TextFormField(
          controller: _horasMantenimientoController,
          decoration: const InputDecoration(labelText: 'Horas Mantenimiento'),
        ),
        TextFormField(
          controller: _paradasOperativasController,
          decoration: const InputDecoration(labelText: 'Paradas Operativas'),
        ),
      ],
    );
  }
}
