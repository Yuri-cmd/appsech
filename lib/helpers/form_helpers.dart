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

  static Future<String> lastHorometro(String ubicacionId) async {
    try {
      return await ApiService.lastHorometro(ubicacionId);
    } catch (e) {
      // print('Error fetching actividades: $e');
      return '0.0';
    }
  }

  static Future<void> sendFormHormetro(formData, context) async {
    try {
      await ApiService.sendFormData(formData);
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
      _selectedDate,
      _semana,
      _mes,
      _maquinaria,
      _maq,
      _propiedad,
      _operador,
      _horometroi,
      _horometrof,
      _horas,
      _cargaCombustible,
      _tipoCombustible,
      _cantidad,
      _nuevoOperario,
      _actividadesAgregadas) {
    final formData = {
      'fecha': FormModalHelper.formatFecha(_selectedDate),
      'semana': _semana ?? '',
      'mes': _mes ?? '',
      'maquinaria': _maquinaria ?? '',
      'maq': _maq ?? '',
      'propiedad': _propiedad ?? '',
      'operador': _operador ?? '',
      'horometroi': _horometroi,
      'horometrof': _horometrof,
      'horas': _horas,
      'cargaCombustible': _cargaCombustible,
      'tipoCombustible': _tipoCombustible ?? '',
      'cantidad': _cantidad ?? '',
      'nuevoOperario': _nuevoOperario ?? '',
      // Campos adicionales del modal de detalles
      'actividades': _actividadesAgregadas
          .map((actividad) => {
                'horaActividad': actividad['horaActividad'],
                'actividad': actividad['actividadNombre'],
                'actividadGeneral': actividad['actividadGeneral'],
                'descripcion': actividad['descripcion'],
                'ubicacion': actividad['ubicacion'],
                'ubicaciong': actividad['ubicaciong'],
                'nviajes': actividad['nviaje'],
                'destino': actividad['destino'],
              })
          .toList(),
    };
    return formData;
  }
}
