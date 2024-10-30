// // ignore_for_file: unused_field, use_build_context_synchronously, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:appsech/horometro.dart';
// import 'package:appsech/api/api_service.dart';
// import 'package:intl/intl.dart';
// import 'package:appsech/helpers/form_helpers.dart';

// class FormModalEdit extends StatefulWidget {
//   final int registro;

//   const FormModalEdit({Key? key, required this.registro}) : super(key: key);

//   @override
//   _FormModalEditState createState() => _FormModalEditState();
// }

// class _FormModalEditState extends State<FormModalEdit> {
//   final List<String> _opcionesPropiaAlquilada = ['Propia', 'Alquilada'];
//   DateTime _selectedDate = DateTime.now();
//   String? _semana;
//   String? _mes;
//   String? _maquinaria;
//   String? _maq;
//   String? _propiedad;
//   String? _operador;
//   String _horometroi = '';
//   String _horometrof = '';
//   double _horas = 0.0;
//   double _horasUsadas = 0.0;
//   String? _nviajes = '';
//   String? _destino = '';
//   String? _cantidad = '';
//   String? _nuevoOperario;
//   // Variables para el modal
//   String? _horasActividad;
//   String? _actividad;
//   String? _actividadg;
//   String? _descripcion;
//   String? _ubicacion;
//   String? _ubicaciong;
//   String? _ubicacionT;
//   // Carga de Combustible
//   bool _cargaCombustible =
//       false; // Valor por defecto para si se carga combustible o no
//   String? _tipoCombustible; // Almacena el tipo de combustible
//   final List<String> _opcionesCombustible = [
//     'GLP-unid',
//     'diesel-gl',
//     'gasolina'
//   ]; // Opciones de tipo de combustible

//   List<String> _maquinariaOptions = [];
//   List<String> _actividadOptions = [];
//   List<String> _actividadGenerals = [];
//   List<Map<String, dynamic>> _zonas = [];
//   Map<String, dynamic> _selectedMaquinariaDetails = {};
//   List<String> _ubicacionesGenerales = [];
//   final TextEditingController _maqController = TextEditingController();
//   final TextEditingController _horometroiController = TextEditingController();
//   final TextEditingController _horometrofController = TextEditingController();
//   final TextEditingController _cantidadfController = TextEditingController();

//   final List<Map<String, String?>> _actividadesAgregadas = [];

//   List<String> _operarios = [];
//   bool _otrosSelected = false;
//   final TextEditingController _nuevoOperarioController =
//       TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchMaquinariaOptions();
//     _fetchZonas();
//     _loadDataForEdit(widget.registro);
//     _maqController.addListener(() {
//       _maq = _maqController.text;
//     });
//   }

//   @override
//   void dispose() {
//     _maqController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _fetchMaquinariaOptions() async {
//     final options = await FormModalHelper.fetchMaquinariaOptions();
//     setState(() {
//       _maquinariaOptions = options;
//     });
//   }

//   Future<void> _fetchMaquinariaDetails(String maquinaria) async {
//     final details = await FormModalHelper.fetchMaquinariaDetails(maquinaria);
//     _fetchOperarios(maquinaria);
//     setState(() {
//       _selectedMaquinariaDetails = details;
//       _maq = details['tipo'];
//       _propiedad = details['propiedad'];
//       _maqController.text = _maq ?? '';
//       _fetchActividades(maquinaria);
//     });
//   }

//   Future<void> _fetchActividades(String maquinaria) async {
//     final actividades = await FormModalHelper.fetchActividades(maquinaria);
//     setState(() {
//       _actividadOptions = actividades;
//     });
//   }

//   Future<void> _fetchActividadGenerals(String actividad) async {
//     final actividadGeneralsResponse =
//         await FormModalHelper.fetchActividadGenerals(actividad);
//     setState(() {
//       _actividadGenerals = actividadGeneralsResponse;
//     });
//   }

//   Future<void> _fetchZonas() async {
//     final zonasResponse = await FormModalHelper.fetchZonas();
//     setState(() {
//       _zonas = zonasResponse;
//     });
//   }

//   Future<void> _fetchDetalleZona(String? ubicacionId) async {
//     if (ubicacionId == null) return;
//     final zonasDetalle = await FormModalHelper.fetchDetalleZona(ubicacionId);
//     setState(() {
//       _ubicacionesGenerales = zonasDetalle;
//     });
//   }

//   // Función para obtener operarios de la API
//   Future<void> _fetchOperarios(String maquinaria) async {
//     final operarios = await ApiService.fetchOperarioMaquinaria(maquinaria);
//     setState(() {
//       _operarios = operarios;
//       _operarios.add('Otros'); // Agregar la opción "Otros"
//     });
//   }

//   Future<void> _loadDataForEdit(int recordId) async {
//     // Llamada a la API para obtener los datos del registro por ID
//     final existingData = await ApiService.getHorometroOne(recordId);

//     setState(() {
//       // _selectedDate = DateTime.parse(existingData['fecha']);
//       _semana = existingData['semana'];
//       _mes = existingData['mes'];
//       _maquinaria = existingData['maquinaria'];
//       _maqController.text = existingData['maq'];
//       _propiedad = existingData['propiedad'];
//       _operador = existingData['operador'];
//       _horometroiController.text = existingData['horometroi'].toString();
//       _horometrofController.text = existingData['horometrof'].toString();
//       // _horas = existingData['horas'];
//       _fetchMaquinariaDetails(existingData['maquinaria']);
//       _updateHoras();
//       _nviajes = existingData['nviajes']?.toString() ?? '';
//       _destino = existingData['destino'];
//       _cargaCombustible = existingData['cargaCombustible'] == 1 ? true : false;
//       _tipoCombustible = existingData['tipoCombustible'];
//       _cantidadfController.text = existingData['cantidad'].toString();
//       _nuevoOperario = existingData['operador'];

//       print(existingData['actividades']);

//       // Limpiar la lista actual y agregar nuevas actividades si existen
//       if (existingData.containsKey('actividades')) {
//         _actividadesAgregadas
//             .clear(); // Limpia las actividades anteriores, si es necesario
//         List<dynamic> actividades =
//             existingData['actividades']; // Asegúrate de que sea una lista
//         for (var actividad in actividades) {
//           if (actividad is Map<String, dynamic>) {
//             // Crear un nuevo mapa asegurándote de que todas las claves son String
//             final Map<String, String?> newActividad = {};
//             actividad.forEach((key, value) {
//               newActividad[key.toString()] =
//                   value?.toString(); // Asegura que el valor sea String
//             });
//             _actividadesAgregadas.add(newActividad);
//           }
//         }
//       }
//     });
//   }

//   Future<void> _sendFormData() async {
//     final formData = {
//       'id': widget.registro,
//       'fecha': FormModalHelper.formatFecha(_selectedDate),
//       'semana': _semana ?? '',
//       'mes': _mes ?? '',
//       'maquinaria': _maquinaria ?? '',
//       'maq': _maq ?? '',
//       'propiedad': _propiedad ?? '',
//       'operador': _operador ?? '',
//       'horometroi': _horometroi,
//       'horometrof': _horometrof,
//       'horas': _horas,
//       'nviajes': _nviajes ?? '',
//       'destino': _destino ?? '',
//       'cargaCombustible': _cargaCombustible,
//       'tipoCombustible': _tipoCombustible ?? '',
//       'cantidad': _cantidad ?? '',
//       'nuevoOperario': _nuevoOperario ?? '',
//       // Campos adicionales del modal de detalles
//       'actividades': _actividadesAgregadas
//           .map((actividad) => {
//                 'horaActividad': actividad['horaActividad'],
//                 'actividad': actividad['actividad'],
//                 'actividadGeneral': actividad['actividadGeneral'],
//                 'descripcion': actividad['descripcion'],
//                 'ubicacion': actividad['ubicacion'],
//                 'ubicaciong': actividad['ubicaciong'],
//               })
//           .toList(),
//     };

//     try {
//       await ApiService.sendFormDataUpdate(formData);
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Éxito'),
//             content: const Text('Los datos se guardaron correctamente.'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => const Horometro(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print('Error saving form data: $e');
//     }
//   }

//   void _showDetailsModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled:
//           true, // Asegúrate de que el modal pueda ajustarse al tamaño
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: 0.8, // Ajusta la altura del modal si es necesario
//           child: SingleChildScrollView(
//             // Hace que el contenido sea desplazable
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text('Detalles Adicionales'),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Horas'),
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       setState(() {
//                         _horasActividad = value;
//                       });
//                     },
//                   ),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: 'Actividad'),
//                     value: _actividad,
//                     onChanged: (String? newValue) async {
//                       if (newValue != null) {
//                         setState(() {
//                           _actividad = newValue;
//                         });

//                         // Obtener las actividades generales basadas en la actividad seleccionada
//                         await _fetchActividadGenerals(newValue);
//                       }
//                     },
//                     items: _actividadOptions.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   DropdownButtonFormField<String>(
//                     decoration:
//                         const InputDecoration(labelText: 'Actividad General'),
//                     value: _actividadg,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _actividadg = newValue;
//                       });
//                     },
//                     items: _actividadGenerals.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Descripción'),
//                     onChanged: (value) {
//                       setState(() {
//                         _descripcion = value;
//                       });
//                     },
//                   ),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: 'Ubicación'),
//                     value: _ubicacion,
//                     items: _zonas.map<DropdownMenuItem<String>>((zona) {
//                       return DropdownMenuItem<String>(
//                         value: zona['id'],
//                         child: Text(zona['nombre']),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _ubicacion = newValue;
//                         _ubicacionT = _zonas.firstWhere(
//                             (zona) => zona['id'] == newValue)['nombre'];
//                       });
//                       _fetchDetalleZona(
//                           newValue); // Asegúrate de actualizar las ubicaciones generales
//                     },
//                   ),
//                   DropdownButtonFormField<String>(
//                     decoration:
//                         const InputDecoration(labelText: 'Ubicación General'),
//                     value: _ubicaciong,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _ubicaciong = newValue;
//                       });
//                     },
//                     items: _ubicacionesGenerales.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       double horasActividad =
//                           double.tryParse(_horasActividad ?? '0') ?? 0.0;
//                       if (_actividad != null && horasActividad > 0) {
//                         if (_horasUsadas + horasActividad <= _horas) {
//                           setState(() {
//                             _actividadesAgregadas.add({
//                               'horaActividad': _horasActividad,
//                               'actividad': _actividad,
//                               'actividadGeneral': _actividadg,
//                               'descripcion': _descripcion,
//                               'ubicacion': _ubicacionT,
//                               'ubicaciong': _ubicaciong,
//                             });
//                             _horasUsadas += horasActividad;
//                             _actividad = null;
//                             _actividadg = null;
//                             _descripcion = null;
//                             _ubicacion = null;
//                             _ubicaciong = null;
//                             _horasActividad = null;
//                           });
//                           Navigator.pop(context);
//                         } else {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Error'),
//                                 content: const Text(
//                                     'Las horas asignadas superan el total disponible.'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     child: const Text('OK'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       }
//                     },
//                     child: const Text('Agregar Actividad'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _updateHoras() {
//     setState(() {
//       _horas = FormModalHelper.calculateHoras(_horometroi, _horometrof);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Formulario'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Llena los campos requeridos:'),
//               const SizedBox(height: 16.0),

//               // Fecha
//               InkWell(
//                 onTap: () => _selectDate(context),
//                 child: InputDecorator(
//                   decoration: const InputDecoration(
//                     labelText: 'Fecha',
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         DateFormat('dd/MM/yyyy').format(_selectedDate),
//                       ),
//                       const Icon(Icons.calendar_today),
//                     ],
//                   ),
//                 ),
//               ),

//               // Maquinaria
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Maquinaria'),
//                 value: _maquinaria,
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     setState(() {
//                       _maquinaria = newValue;
//                     });
//                     _fetchMaquinariaDetails(newValue);
//                   }
//                 },
//                 items: _maquinariaOptions.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),

//               // MAQ
//               TextFormField(
//                 controller: _maqController,
//                 decoration: const InputDecoration(labelText: 'MAQ'),
//                 onChanged: (value) {
//                   setState(() {
//                     _maqController.text = value;
//                   });
//                 },
//               ),

//               // Mostrar campos adicionales si MAQ es volquete
//               if (_maqController.text.toLowerCase() == 'volquete') ...[
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'N° de viajes'),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     setState(() {
//                       _nviajes = value;
//                     });
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Destino'),
//                   onChanged: (value) {
//                     setState(() {
//                       _destino = value;
//                     });
//                   },
//                 ),
//               ],

//               // Propia/Alquilada
//               DropdownButtonFormField<String>(
//                 decoration:
//                     const InputDecoration(labelText: 'Propia/Alquilada'),
//                 value: _propiedad,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _propiedad = newValue;
//                   });
//                 },
//                 items: _opcionesPropiaAlquilada.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),

//               // Operador
//               // Dropdown de operarios
//               DropdownButtonFormField<String>(
//                 value: _operador,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _operador = newValue;
//                     _otrosSelected =
//                         newValue == 'Otros'; // Verificar si seleccionó "Otros"
//                   });
//                 },
//                 items: _operarios.map((String operario) {
//                   return DropdownMenuItem<String>(
//                     value: operario,
//                     child: Text(operario),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(labelText: 'Operador'),
//               ),

//               // Mostrar el campo para un nuevo operario si se selecciona "Otros"
//               if (_otrosSelected)
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       labelText: 'Nombre del nuevo Operador'),
//                   onChanged: (value) {
//                     setState(() {
//                       _nuevoOperario = value;
//                     });
//                   },
//                 ),

//               // Horómetro Inicial
//               TextFormField(
//                 controller:
//                     _horometroiController, // Controlador para Horómetro Inicial
//                 decoration:
//                     const InputDecoration(labelText: 'Horómetro Inicial'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _horometroi = value;
//                   });
//                   _updateHoras();
//                 },
//               ),

//               TextFormField(
//                 controller:
//                     _horometrofController, // Controlador para Horómetro Final
//                 decoration: const InputDecoration(labelText: 'Horómetro Final'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _horometrof = value;
//                   });
//                   _updateHoras();
//                 },
//               ),

//               // Horas calculadas
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Horas'),
//                 controller: TextEditingController(text: _horas.toString()),
//                 readOnly: true,
//               ),

//               // Radio buttons para combustible
//               const SizedBox(height: 16.0),
//               const Text('¿Cargo combustible?'),
//               RadioListTile<bool>(
//                 title: const Text('Sí'),
//                 value: true,
//                 groupValue: _cargaCombustible,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     _cargaCombustible = value!;
//                   });
//                 },
//               ),
//               RadioListTile<bool>(
//                 title: const Text('No'),
//                 value: false,
//                 groupValue: _cargaCombustible,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     _cargaCombustible = value!;
//                   });
//                 },
//               ),

//               // Mostrar opciones de combustible si selecciona "Sí"
//               if (_cargaCombustible) ...[
//                 DropdownButtonFormField<String>(
//                   decoration:
//                       const InputDecoration(labelText: 'Tipo de Combustible'),
//                   value: _tipoCombustible,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _tipoCombustible = newValue!;
//                     });
//                   },
//                   items:
//                       ['GLP-unid', 'diesel-gl', 'gasolina'].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//                 TextFormField(
//                   controller: _cantidadfController,
//                   decoration: const InputDecoration(
//                       labelText: 'Cantidad de Combustible'),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     setState(() {
//                       _cantidad = value;
//                     });
//                   },
//                 ),
//               ],

//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _showDetailsModal,
//                 child: const Text('Agregar Actividad'),
//               ),

//               const SizedBox(height: 16.0),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: _actividadesAgregadas.length,
//                 itemBuilder: (context, index) {
//                   final actividad = _actividadesAgregadas[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text(actividad['actividad'] ?? ''),
//                       subtitle: Text(
//                         'Horas: ${actividad['horaActividad'] ?? ''}\nDescripción: ${actividad['descripcion'] ?? ''}\nUbicación: ${actividad['ubicacion'] ?? ''}\nUbicación General: ${actividad['ubicaciong'] ?? ''}',
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _sendFormData,
//                 child: const Text('Enviar'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
