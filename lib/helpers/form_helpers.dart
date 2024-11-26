import 'package:appsech/grifo.dart';
import 'package:appsech/horometro.dart';
import 'package:intl/intl.dart';
import 'package:appsech/api/api_service.dart';
import 'package:flutter/material.dart';

class FormModalHelper {
  static String formatFecha(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static double calculateHoras(String? horometroi, String horometrof) {
    double horometroiDouble = double.tryParse(horometroi ?? '0.0') ?? 0.0;
    double horometrofDouble = double.tryParse(horometrof) ?? 0.0;
    return horometrofDouble - horometroiDouble;
  }

  static Future<List<String>> fetchMaquinariaOptions() async {
    try {
      return await ApiService.fetchMaquinariaOptions();
    } catch (e) {
      // print('Error fetching maquinaria options: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchMaquinariaDetails(
      String maquinaria) async {
    try {
      return await ApiService.fetchMaquinariaDetails(maquinaria);
    } catch (e) {
      // En caso de error, devuelve una lista vacía
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchActividades(
      String maquinaria) async {
    try {
      // Suponiendo que la API devuelve una lista de actividades con id y nombre
      final response = await ApiService.fetchMaquinariaActividades(maquinaria);
      return response
          .map<Map<String, dynamic>>((item) => {
                'id': item['id_actividad'],
                'nombre': item['nombre'],
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<String>> fetchActividadGenerals(String actividad) async {
    try {
      return await ApiService.fetchActividadGeneral(actividad);
    } catch (e) {
      // print('Error fetching actividad general: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchZonas() async {
    try {
      return await ApiService.fetchZonas();
    } catch (e) {
      // print('Error fetching zonas: $e');
      return [];
    }
  }

  static Future<List<String>> fetchDetalleZona(String ubicacionId) async {
    try {
      return await ApiService.fetchZonaDetalle(ubicacionId);
    } catch (e) {
      // print('Error fetching actividades: $e');
      return [];
    }
  }

  static Future<List<String>> fetchZonasEspecificas() async {
    try {
      return await ApiService.fetchZonasEspecificas();
    } catch (e) {
      // print('Error fetching actividades: $e');
      return [];
    }
  }

  static Future<String> lastHorometro(String ubicacionId) async {
    try {
      return await ApiService.lastHorometro(ubicacionId);
    } catch (e) {
      // print('Error fetching actividades: $e');
      return '0.0';
    }
  }

  static Future<void> sendFormHormetro(formData, isCreate, context) async {
    try {
      await ApiService.sendFormData(formData, isCreate);
    } catch (e) {
      // Handle the error
    }
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
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Horometro(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Map<String, dynamic> formDateHorometro(
      selectedDate,
      semana,
      mes,
      maquinaria,
      maq,
      propiedad,
      operador,
      horometroi,
      horometrof,
      horas,
      cargaCombustible,
      tipoCombustible,
      cantidad,
      nuevoOperario,
      horometroCarga,
      actividadesAgregadas,
      id) {
    final formData = {
      'fecha': FormModalHelper.formatFecha(selectedDate),
      'semana': semana ?? '',
      'mes': mes ?? '',
      'maquinaria': maquinaria ?? '',
      'maq': maq ?? '',
      'propiedad': propiedad ?? '',
      'operador': operador ?? '',
      'horometroi': horometroi,
      'horometrof': horometrof,
      'horas': horas,
      'cargaCombustible': cargaCombustible,
      'tipoCombustible': tipoCombustible ?? '',
      'cantidad': cantidad ?? '',
      'nuevoOperario': nuevoOperario ?? '',
      'horometroCarga': horometroCarga,
      'id': id,
      // Campos adicionales del modal de detalles
      'actividades': actividadesAgregadas
          .map((actividad) => {
                'horaActividad': actividad['horaActividad'],
                'actividad': actividad['actividadNombre'],
                'actividadGeneral': actividad['actividadGeneral'],
                'descripcion': actividad['descripcion'],
                'ubicacion': actividad['ubicacion'],
                'ubicaciong': actividad['ubicaciong'],
                'nviajes': actividad['nviajes'],
                'destino': actividad['destino'],
                'destinoE': actividad['destinoE']
              })
          .toList(),
    };
    return formData;
  }

  static Map<String, dynamic> formDataGrifo(
      selectedTipo,
      selectedMaquinaria,
      operario,
      abastecimientoController,
      horometroController,
      selectedCombustible,
      cantidadController,
      marcaController,
      selectDate,
      id) {
    final formData = {
      'tipo': selectedTipo,
      'maquinaria': selectedMaquinaria ?? '',
      'operario': operario ?? '',
      'abastecimiento': abastecimientoController ?? '',
      'horometro': horometroController ?? '',
      'combustible': selectedCombustible ?? '',
      'cantidad': cantidadController ?? '',
      'observacion': marcaController,
      'fecha': FormModalHelper.formatFecha(selectDate),
      'id': id,
    };
    return formData;
  }

  static Future<void> sendFormGrifo(formData, isCreate, context) async {
    try {
      await ApiService.sendFormDataGrifo(formData, isCreate);
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Grifo(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // print(e);
    }
  }
}
