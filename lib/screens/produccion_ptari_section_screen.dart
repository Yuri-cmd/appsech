// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';

class ProduccionPtardSection extends StatefulWidget {
  // Agregar una GlobalKey para poder acceder a su estado desde otro widget
  static GlobalKey<_ProduccionPtardSectionState> produccionPtardSectionKey =
      GlobalKey<_ProduccionPtardSectionState>();
  final int? registro;
  const ProduccionPtardSection({super.key, this.registro});

  @override
  _ProduccionPtardSectionState createState() => _ProduccionPtardSectionState();
}

class _ProduccionPtardSectionState extends State<ProduccionPtardSection> {
  final TextEditingController _contometroInicialController =
      TextEditingController();

  final TextEditingController _contometroFinalController =
      TextEditingController();

  // Método para devolver los datos recopilados
  Map<String, dynamic> getDatosProduccion() {
    return {
      'contometro_inicial': _contometroInicialController.text,
      'contometro_final': _contometroFinalController.text,
    };
  }

  @override
  void dispose() {
    _contometroInicialController.dispose();
    _contometroFinalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDataForEdit(widget.registro ?? 0);
  }

  Future<void> _loadDataForEdit(int recordId) async {
    try {
      final existingData = await ApiService.fetchProPtard(recordId);
      setState(() {
        // Asigna los valores a los controladores
        _contometroInicialController.text =
            existingData['contometro_inicial'] ?? '';
        _contometroFinalController.text =
            existingData['contometro_final'] ?? '';
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
        const Text('Producción PTARD:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _contometroInicialController,
          decoration:
              const InputDecoration(labelText: 'Contómetro inicial (m3)'),
        ),
        TextFormField(
          controller: _contometroFinalController,
          decoration: const InputDecoration(labelText: 'Contómetro final (m3)'),
        ),
      ],
    );
  }
}
