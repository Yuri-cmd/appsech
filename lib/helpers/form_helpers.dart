import 'package:intl/intl.dart';
import 'package:appsech/api/api_service.dart';

class FormModalHelper {
  static String formatFecha(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static double calculateHoras(String horometroi, String horometrof) {
    double horometroiDouble = double.tryParse(horometroi) ?? 0.0;
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

  static Future<List<String>> fetchActividades(String maquinaria) async {
    try {
      return await ApiService.fetchMaquinariaActividades(maquinaria);
    } catch (e) {
      // print('Error fetching actividades: $e');
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
}
