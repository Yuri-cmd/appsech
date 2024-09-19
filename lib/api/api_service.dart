import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://magussystems.com/appsheet/public/api';

  // Method to get records
  static Future<List<Map<String, dynamic>>> getRegistros() async {
    const url = '$baseUrl/get-hr';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to delete a record
  static Future<bool> eliminarRegistro(int id) async {
    const url = '$baseUrl/delete-hr';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Method to save or update a record
  static Future<bool> guardarRegistro(Map<String, dynamic> datos,
      {int? id}) async {
    final String url = id != null ? '$baseUrl/update-hr' : '$baseUrl/create-hr';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: id != null ? {...datos, 'id': id.toString()} : datos,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Method to fetch maquinaria options
  static Future<List<String>> fetchMaquinariaOptions() async {
    final url = '$baseUrl/maquinaria';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> maquinariaList = json.decode(response.body);
        return maquinariaList
            .map((maquinaria) => maquinaria['nombre'].toString())
            .toList();
      } else {
        throw Exception('Failed to load maquinaria options');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchZonas() async {
    final url = '$baseUrl/get-zonas';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> zonasList = json.decode(response.body);
        return zonasList.map((zona) {
          return {
            'id': zona['id_zona'].toString(),
            'nombre': zona['nombre'].toString(),
          };
        }).toList();
      } else {
        throw Exception('Failed to load zonas');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to fetch maquinaria details
  static Future<Map<String, dynamic>> fetchMaquinariaDetails(
      String maquinaria) async {
    final url = '$baseUrl/maquinaria/details?nombre=$maquinaria';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load maquinaria details');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to send form data
  static Future<void> sendFormData(Map<String, String> formData) async {
    final url = '$baseUrl/save-hr';
    try {
      final response = await http.post(Uri.parse(url), body: formData);
      if (response.statusCode != 200) {
        throw Exception('Failed to save form data');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllRegistros() async {
    final response = await http.get(Uri.parse('$baseUrl/get-hr'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load registros');
    }
  }

  // Method to fetch maquinaria activities
  static Future<List<String>> fetchMaquinariaActividades(
      String maquinaria) async {
    final url = '$baseUrl/maquinarias/actividades?nombre=$maquinaria';
    try {
      print('Fetching URL: $url');
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        // Extrae los nombres de las actividades de la respuesta
        return decodedResponse
            .map<String>((map) {
              if (map is Map<String, dynamic> && map.containsKey('nombre')) {
                return map['nombre'] as String;
              }
              return ''; // Maneja el caso donde 'nombre' no esté presente
            })
            .where(
                (name) => name.isNotEmpty) // Filtra valores vacíos si los hay
            .toList();
      } else {
        throw Exception('Failed to load maquinaria activities');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<List<String>> fetchZonaDetalle(String ubicacionId) async {
    final url = '$baseUrl/get-detalle/$ubicacionId';
    try {
      print('Fetching URL: $url');
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        // Extrae los nombres de las zonas de la respuesta
        return decodedResponse
            .map<String>((map) {
              if (map is Map<String, dynamic> && map.containsKey('zona')) {
                return map['zona'] as String;
              }
              return ''; // Maneja el caso donde 'zona' no esté presente
            })
            .where(
                (name) => name.isNotEmpty) // Filtra valores vacíos si los hay
            .toList();
      } else {
        throw Exception('Failed to load zonas');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Obtener actividad general
  static Future<List<String>> fetchActividadGeneral(String actividad) async {
    final response =
        await http.get(Uri.parse('$baseUrl/actividad-general/$actividad'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(
          'Response body: ${response.body}'); // Verificar la respuesta completa

      List<String> result = data
          .map<String>((map) {
            if (map is Map<String, dynamic> && map.containsKey('nombre')) {
              print('Nombre encontrado: ${map['nombre']}'); // Depuración
              return map['nombre'] as String;
            }
            print('Nombre no encontrado en: $map'); // Depuración
            return '';
          })
          .where((name) => name.isNotEmpty)
          .toList();

      print('Mapped result: $result'); // Depuración de la lista mapeada
      return result;
    } else {
      throw Exception('Error al obtener actividad general');
    }
  }
}
