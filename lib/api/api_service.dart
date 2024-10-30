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
      return false;
    }
  }

  // Method to fetch maquinaria options
  static Future<List<String>> fetchMaquinariaOptions() async {
    const url = '$baseUrl/maquinaria';
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
      rethrow;
    }
  }

  static Future<List<String>> fetchTipoVehichulo(String? tipo) async {
    final url = '$baseUrl/maquinaria/$tipo';
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
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchZonas() async {
    const url = '$baseUrl/get-zonas';
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
      rethrow;
    }
  }

  // Method to fetch maquinaria details
  static Future<List<Map<String, dynamic>>> fetchMaquinariaDetails(
      String maquinaria) async {
    final url = '$baseUrl/maquinaria/details/$maquinaria';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Asegúrate de que el cuerpo de la respuesta sea una lista
        final List<dynamic> jsonResponse = json.decode(response.body);

        // Convertir la lista dinámica a una lista de mapas
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load maquinaria details');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> fetchOperarioMaquinaria(String maquinaria) async {
    final url = '$baseUrl/maquinaria/operario/$maquinaria';
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
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchAbastecimientoMaquinaria(
      String maquinaria) async {
    final url = '$baseUrl/maquinaria/abastecimiento/$maquinaria';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load maquinaria details');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchCombustibleMaquinaria(
      String maquinaria) async {
    final url = '$baseUrl/maquinaria/combustible/$maquinaria';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load maquinaria details');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to send form data
  static Future<void> sendFormData(Map<String, dynamic> formData) async {
    const url = '$baseUrl/save-hr';

    // Convertir el mapa a JSON
    String jsonFormData = jsonEncode(formData);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Establecer el encabezado correcto
        body: jsonFormData,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save form data');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> sendFormDataUpdate(Map<String, dynamic> formData) async {
    const url = '$baseUrl/update-hr';

    // Convertir el mapa a JSON
    String jsonFormData = jsonEncode(formData);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Establecer el encabezado correcto
        body: jsonFormData,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save form data');
      }
    } catch (e) {
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
      final response = await http.get(Uri.parse(url));

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
      rethrow;
    }
  }

  static Future<List<String>> fetchZonaDetalle(String ubicacionId) async {
    final url = '$baseUrl/get-detalle/$ubicacionId';
    try {
      final response = await http.get(Uri.parse(url));

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
      rethrow;
    }
  }

  // Obtener actividad general
  static Future<List<String>> fetchActividadGeneral(String actividad) async {
    final response =
        await http.get(Uri.parse('$baseUrl/actividad-general/$actividad'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<String> result = data
          .map<String>((map) {
            if (map is Map<String, dynamic> && map.containsKey('nombre')) {
              return map['nombre'] as String;
            }
            return '';
          })
          .where((name) => name.isNotEmpty)
          .toList();

      return result;
    } else {
      throw Exception('Error al obtener actividad general');
    }
  }

  static Future<List<String>> fetchOperarios() async {
    final response = await http.get(Uri.parse('$baseUrl/operarios'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<String> result = data
          .map<String>((map) {
            if (map is Map<String, dynamic> && map.containsKey('nombre')) {
              return map['nombre'] as String;
            }
            return '';
          })
          .where((name) => name.isNotEmpty)
          .toList();
      return result;
    } else {
      throw Exception('Error al obtener actividad general');
    }
  }

  static Future<Map<String, dynamic>> getHorometroOne(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get/horometro/$id'));
      if (response.statusCode == 200) {
        // Decodificar el cuerpo como un mapa (objeto JSON)
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> downloadExcel() async {
    const url = '$baseUrl/download-excel'; // Cambia esto a la URL de tu API
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<List<dynamic>> fetchData() async {
    const url =
        '$baseUrl/get/almacen/temporal'; // Reemplaza 'tu_endpoint' con el endpoint correcto
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> saveMeta(String meta) async {
    const url = '$baseUrl/meta_almacen'; // Reemplaza con el endpoint correcto
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
          {'meta': meta}), // Asegúrate de que la clave 'meta' sea correcta
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve la respuesta
    } else {
      throw Exception('Failed to save meta');
    }
  }

  static Future<Map<String, dynamic>> fetchLatestMeta() async {
    const url =
        '$baseUrl/meta_almacen/latest'; // Asegúrate de que la URL sea correcta
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve la respuesta
    } else {
      throw Exception('Failed to fetch latest meta');
    }
  }

  static Future<String> guardarTratamiento(Map<String, dynamic> datos) async {
    const url = '$baseUrl/guardar-tratamiento';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datos),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['tratamiento']['id']
            .toString(); // Asegúrate de devolverlo como String
      } else {
        throw Exception('Error al guardar los datos');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerTratamientos() async {
    final response = await http.get(Uri.parse('$baseUrl/tratamientos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  static Future<void> guardarTratamientoDetalle(
      Map<String, dynamic> registro) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/guardar-tratamiento-detalle'), // Cambia 'tu_endpoint' al endpoint correcto
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registro),
    );
    if (response.statusCode == 201) {
      // Procesa la respuesta exitosa
      return; // O cualquier otra lógica que necesites
    } else {
      // Si no es un estado de éxito, maneja el error
      throw Exception('Error al guardar el registro: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerTratamientoDetalles(
      String tratamientoId) async {
    // Este es un ejemplo simple:
    final response = await http
        .get(Uri.parse('$baseUrl/tratamiento/detalles/$tratamientoId'));

    if (response.statusCode == 200) {
      // Parsear la respuesta y devolver la lista de registros
      List<dynamic> data = json.decode(response.body);
      return data.map((registro) => registro as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los detalles del tratamiento');
    }
  }

  static Future<void> eliminarTratamientoDetalle(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/tratamiento-detalle/$id'));
    if (response.statusCode == 200) {
      // Parsear la respuesta y devolver la lista de registros
    } else {
      throw Exception('Error al cargar los detalles del tratamiento');
    }
  }

  static Future<void> actualizarTratamientoDetalle(
      String id, Map<String, dynamic> registro) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tratamientos/detalle/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(registro),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al editar el registro');
    }
  }

  static Future<void> cambiarEstadoTratamiento(
      String id, Map<String, dynamic> registro) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tratamientos/terminar/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(registro), // Cambiado a un objeto JSON vacío
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cambiar el estado del tratamiento');
    }
  }

  Future<List<dynamic>?> getDetalle(int id) async {
    final url = '$baseUrl/tratamientos/get/detalle/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON
        return json.decode(response.body);
      } else {
        // print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error al hacer la solicitud: $e');
      return null;
    }
  }
}
