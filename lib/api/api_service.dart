import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://magussystems.com/appsheet/public/api';

  static Future<dynamic> _get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to GET from $endpoint');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> _post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to POST to $endpoint');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method to get records
  static Future<List<Map<String, dynamic>>> getRegistros() async {
    final data = await _get('get-hr');
    return List<Map<String, dynamic>>.from(data);
  }

  // Method to delete a record
  static Future<bool> eliminarRegistro(int id) async {
    final response = await _post('delete-hr', {'id': id.toString()});
    return response['success'] ?? false;
  }

  // Method to save or update a record
  static Future<bool> guardarRegistro(Map<String, dynamic> datos,
      {int? id}) async {
    final endpoint = id != null ? 'update-hr' : 'create-hr';
    final response =
        await _post(endpoint, id != null ? {...datos, 'id': id} : datos);
    return response['success'] ?? false;
  }

  // Method to fetch maquinaria options
  static Future<List<String>> fetchMaquinariaOptions() async {
    final data = await _get('maquinaria');
    return List<String>.from(data.map((item) => item['nombre'].toString()));
  }

  static Future<List<String>> fetchTipoVehichulo(String? tipo) async {
    final maquinariaList = await _get('maquinaria/$tipo');
    return maquinariaList
        .map<String>((maquinaria) => maquinaria['nombre'].toString())
        .toList();
  }

  static Future<List<Map<String, dynamic>>> fetchZonas() async {
    final zonasList = await _get('get-zonas');
    return zonasList.map<Map<String, dynamic>>((zona) {
      return {
        'id': zona['id'].toString(),
        'nombre': zona['nombre'].toString(),
      };
    }).toList();
  }

  // Method to fetch maquinaria details
  static Future<List<Map<String, dynamic>>> fetchMaquinariaDetails(
      String maquinaria) async {
    final jsonResponse = await _get('maquinaria/details/$maquinaria');
    return jsonResponse.cast<Map<String, dynamic>>();
  }

  static Future<List<String>> fetchOperarioMaquinaria(String maquinaria) async {
    try {
      // Llamada al método _get con el endpoint adecuado
      final maquinariaList = await _get('maquinaria/operario/$maquinaria');

      // Mapeo de la respuesta para extraer los nombres
      return maquinariaList
          .map<String>((maquinaria) => maquinaria['nombre'].toString())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchAbastecimientoMaquinaria(
      String maquinaria) async {
    try {
      final response = await _get('maquinaria/abastecimiento/$maquinaria');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchCombustibleMaquinaria(
      String maquinaria) async {
    try {
      final response = await _get('maquinaria/combustible/$maquinaria');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Method to send form data
  static Future<void> sendFormData(
      Map<String, dynamic> formData, bool isCreate) async {
    var url = '$baseUrl/save-hr';
    if (!isCreate) {
      url = '$baseUrl/update-hr';
    }

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

  static Future<List<Map<String, dynamic>>> fetchMaquinariaActividades(
      String maquinaria) async {
    final List<dynamic> decodedResponse =
        await _get('maquinarias/actividades?nombre=$maquinaria');
    return decodedResponse
        .map<Map<String, dynamic>>((map) {
          if (map is Map<String, dynamic> &&
              map.containsKey('id_actividad') &&
              map.containsKey('nombre')) {
            return {
              'id_actividad': map['id_actividad'],
              'nombre': map['nombre'],
            };
          }
          return {};
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static Future<List<String>> fetchZonaDetalle(String ubicacionId) async {
    final List<dynamic> zonasList = await _get('get-detalle/$ubicacionId');
    return zonasList
        .map<String>((map) {
          if (map is Map<String, dynamic> && map.containsKey('nombre')) {
            return map['nombre'] as String;
          }
          return ''; // Maneja el caso cuando 'nombre' no esté presente
        })
        .where((name) => name.isNotEmpty) // Filtra valores vacíos
        .toList();
  }

  static Future<List<String>> fetchZonasEspecificas() async {
    final List<dynamic> zonasList = await _get('get-ubicaciones-especificas');
    return zonasList
        .map<String>((map) {
          if (map is Map<String, dynamic> && map.containsKey('nombre')) {
            return map['nombre'] as String;
          }
          return ''; // Maneja el caso cuando 'nombre' no esté presente
        })
        .where((name) => name.isNotEmpty) // Filtra valores vacíos
        .toList();
  }

  static Future<List<String>> fetchActividadGeneral(String actividad) async {
    List<dynamic> data = await _get('actividad-general/$actividad');
    return data
        .map<String>((map) {
          if (map is Map<String, dynamic> && map.containsKey('nombre')) {
            return map['nombre'] as String;
          }
          return '';
        })
        .where((name) => name.isNotEmpty) // Filtra valores vacíos
        .toList();
  }

  static Future<String> fetchActividadGeneralId(
      String nombreActividad, String nombreMaquinaria) async {
    final response =
        await _get('actividad-general-id/$nombreActividad/$nombreMaquinaria');
    return response.toString();
  }

  static Future<String> fetchZonaId(String zona) async {
    final response = await _get('zona-id/$zona');
    return response.toString();
  }

  static Future<List<String>> fetchOperarios() async {
    List<dynamic> data = await _get('operarios');
    return data
        .map<String>((map) {
          if (map is Map<String, dynamic> && map.containsKey('nombre')) {
            return map['nombre'] as String;
          }
          return '';
        })
        .where((name) => name.isNotEmpty) // Filtra valores vacíos
        .toList();
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
    final response = await _post('meta_almacen', {'meta': meta});
    return response;
  }

  static Future<Map<String, dynamic>> fetchLatestMeta() async {
    final response = await _get('meta_almacen/latest');
    return response;
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
            .toString(); // Devolver el ID como String
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        return responseData['message']; // Retornar el mensaje de error
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

  static Future<String> lastHorometro(String id) async {
    final url = '$baseUrl/horometro/get/last/$id';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON
        return response.body;
      } else {
        // print('Error: ${response.statusCode}');
        return '0.0';
      }
    } catch (e) {
      // print('Error al hacer la solicitud: $e');
      return '0.0';
    }
  }

  static Future<void> sendFormDataGrifo(
      Map<String, dynamic> formData, bool isCreate) async {
    var url = '$baseUrl/registro-grifo';
    if (!isCreate) {
      url = '$baseUrl/editar-grifo';
    }
    String jsonFormData = jsonEncode(formData);

    try {
      await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Establecer el encabezado correcto
        body: jsonFormData,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> eliminarGrifo(int id) async {
    String apiUrl =
        'https://magussystems.com/appsheet/public/api/eliminar-grifo/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getGrifoOne(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get/grifo/one/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Si la respuesta es una lista, devuelve el primer elemento
        if (data is List && data.isNotEmpty) {
          return Map<String, dynamic>.from(data[0]);
        }
        // Si es un objeto, simplemente devuélvelo
        return Map<String, dynamic>.from(data);
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchControles(
      String tipo, int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/controles-calidad/$tipo/$id'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  static Future<void> createControl(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/controles-calidad'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el control');
    }
  }

  static Future<void> updateControl(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/controles-calidad/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el control');
    }
  }

  static Future<void> deleteControl(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/controles-calidad/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el control');
    }
  }

  static Future<void> saveDatosPtari(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guardar-datos-ptari'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error al guardar los datos');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPtari() async {
    final response = await http.get(Uri.parse('$baseUrl/get-datos-ptari'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPtariAll() async {
    final jsonResponse = await _get('get-ptari');
    return List<Map<String, dynamic>>.from(jsonResponse);
  }

  static Future<List<List<String>>> fetchTablePtari(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get-datos-tabla/$id'));
    if (response.statusCode == 200) {
      // Mapeamos cada lista anidada y sus elementos para convertirlos en Strings
      return (json.decode(response.body) as List)
          .map<List<String>>(
              (row) => (row as List).map((e) => e.toString()).toList())
          .toList();
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  static Future<Map<String, dynamic>> fetchProPtard(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get-datos-ptard/$id'));
    if (response.statusCode == 200) {
      // Decodifica el JSON directamente como un mapa
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  static Future<Map<String, dynamic>> fetchProPtari(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get-datos-ptari/$id'));
    if (response.statusCode == 200) {
      // Decodifica el JSON directamente como un mapa
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  // Método para llamar a la API de consumo de actividades
  static Future<List<Map<String, dynamic>>> fetchConsumoActividad(
      String startDate, String endDate) async {
    const String url = '$baseUrl/consumo-actividad';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los datos: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchBudgetForYear(int year) async {
    final String url =
        '$baseUrl/budget/$year'; // Reemplaza con tu URL de la API

    try {
      // Realizar la solicitud GET a la API
      final response = await http.get(Uri.parse(url));

      // Verificar si la solicitud fue exitosa
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        List<dynamic> data = json.decode(response.body);
        // Convertir los datos en un formato adecuado (si es necesario)
        return data.map((item) {
          return {
            'id': item['id'],
            'mes': item['mes'],
            'presupuesto': item['presupuesto'] is int
                ? item['presupuesto']
                    .toDouble() // Convertir int a double si es necesario
                : double.parse(item['presupuesto']
                    .toString()), // Caso en el que sea un string
          };
        }).toList();
      } else {
        // Si la respuesta no fue exitosa, lanzar un error
        throw Exception('Error al cargar los datos del presupuesto');
      }
    } catch (e) {
      // Manejo de errores
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> saveAllBudgets(
      int year, List<Map<String, dynamic>> budgets) async {
    final url = Uri.parse('$baseUrl/budgets/update-all');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'year': year, 'budgets': budgets}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al guardar presupuestos: ${response.body}');
    }
  }

  // Método para obtener datos de utilización de maquinarias
  static Future<List<Map<String, dynamic>>> fetchUtilizacionMaquinaria(
      String startDate, String endDate) async {
    final data = {
      'start_date': startDate,
      'end_date': endDate,
    };
    final response = await _post('utilizacion-maquinaria', data);
    return List<Map<String, dynamic>>.from(response);
  }

  // Método para obtener datos de consumo de alquiler
  static Future<List<Map<String, dynamic>>> fetchConsumoAlquiler(
      String startDate, String endDate) async {
    final data = {
      'start_date': startDate,
      'end_date': endDate,
    };
    final response = await _post('consumo-alquiler', data);
    return List<Map<String, dynamic>>.from(response);
  }
}
