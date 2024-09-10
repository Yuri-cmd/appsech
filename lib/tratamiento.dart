import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Tratamiento extends StatefulWidget {
  const Tratamiento({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TratamientoState createState() => _TratamientoState();
}

class _TratamientoState extends State<Tratamiento> {
  List<List<String>> tableData = [];

  // Text controllers for the form fields
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinController = TextEditingController();
  TextEditingController tipoLodoController = TextEditingController();
  TextEditingController ubicacionController = TextEditingController();
  TextEditingController tratadoController = TextEditingController();
  TextEditingController tierraUtilizadaController = TextEditingController();
  TextEditingController lodoUtilizadoController = TextEditingController();
  TextEditingController excavadoController = TextEditingController();
  TextEditingController volqexcController = TextEditingController();
  TextEditingController totalLodosController = TextEditingController();
  TextEditingController totalLixiviadosController = TextEditingController();
  TextEditingController tierraEstabilizadaController = TextEditingController();
  TextEditingController lugarDisposicionController = TextEditingController();
  TextEditingController tierraUsadaController = TextEditingController();
  TextEditingController ratioCementadoController = TextEditingController();
  TextEditingController tierraAhorradaController = TextEditingController();
  TextEditingController totalTierraSinEsparjaController =
      TextEditingController();
  TextEditingController ahorroAlgVolqueteController = TextEditingController();
  TextEditingController ahorroAlgExcavadorController = TextEditingController();
  TextEditingController ahorroCementoController = TextEditingController();
  TextEditingController consumoCementoController = TextEditingController();
  TextEditingController ahorroNetoController = TextEditingController();

  final String apiUrl =
      'https://magussystems.com/appsheet/public/api/get-tratamiento'; // Cambia esto a tu URL de API

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tableData = data
            .map((item) => [
                  item['fecha_inicio']?.toString() ?? '',
                  item['fecha_fin']?.toString() ?? '',
                  item['tipo_lodo']?.toString() ?? '',
                  item['ubicacion']?.toString() ?? '',
                  item['tratado']?.toString() ?? '',
                  item['tierra_utilizada']?.toString() ?? '',
                  item['lodo_utilizado']?.toString() ?? '',
                  item['excavado']?.toString() ?? '',
                  item['volqexc']?.toString() ?? '',
                  item['total_lodos']?.toString() ?? '',
                  item['total_lixiviados']?.toString() ?? '',
                  item['tierra_estabilizada']?.toString() ?? '',
                  item['lugar_disposicion']?.toString() ?? '',
                  item['tierra_usada']?.toString() ?? '',
                  item['ratio_cementado']?.toString() ?? '',
                  item['tierra_ahorrada']?.toString() ?? '',
                  item['total_tierra_sin_esparja']?.toString() ?? '',
                  item['ahorro_alg_volquete']?.toString() ?? '',
                  item['ahorro_alg_excavador']?.toString() ?? '',
                  item['ahorro_cemento']?.toString() ?? '',
                  item['consumo_cemento']?.toString() ?? '',
                  item['ahorro_neto']?.toString() ?? '',
                ])
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _guardarFila() async {
    final Map<String, String> data = {
      'fecha_inicio': fechaInicioController.text,
      'fecha_fin': fechaFinController.text,
      'tipo_lodo': tipoLodoController.text,
      'ubicacion': ubicacionController.text,
      'tratado': tratadoController.text,
      'tierra_utilizada': tierraUtilizadaController.text,
      'lodo_utilizado': lodoUtilizadoController.text,
      'excavado': excavadoController.text,
      'volqexc': volqexcController.text,
      'total_lodos': totalLodosController.text,
      'total_lixiviados': totalLixiviadosController.text,
      'tierra_estabilizada': tierraEstabilizadaController.text,
      'lugar_disposicion': lugarDisposicionController.text,
      'tierra_usada': tierraUsadaController.text,
      'ratio_cementado': ratioCementadoController.text,
      'tierra_ahorrada': tierraAhorradaController.text,
      'total_tierra_sin_esparja': totalTierraSinEsparjaController.text,
      'ahorro_alg_volquete': ahorroAlgVolqueteController.text,
      'ahorro_alg_excavador': ahorroAlgExcavadorController.text,
      'ahorro_cemento': ahorroCementoController.text,
      'consumo_cemento': consumoCementoController.text,
      'ahorro_neto': ahorroNetoController.text,
    };
    final response = await http.post(
      Uri.parse(
          'https://magussystems.com/appsheet/public/api/tratamiento-registro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      // Agregar la fila a la tabla después de guardarla en el servidor
      setState(() {
        tableData.add(data.values.toList());
      });
      _limpiarControladores();
    } else {
      throw Exception('Failed to save data $data');
    }
  }

  void _limpiarControladores() {
    fechaInicioController.clear();
    fechaFinController.clear();
    tipoLodoController.clear();
    ubicacionController.clear();
    tratadoController.clear();
    tierraUtilizadaController.clear();
    lodoUtilizadoController.clear();
    excavadoController.clear();
    volqexcController.clear();
    totalLodosController.clear();
    totalLixiviadosController.clear();
    tierraEstabilizadaController.clear();
    lugarDisposicionController.clear();
    tierraUsadaController.clear();
    ratioCementadoController.clear();
    tierraAhorradaController.clear();
    totalTierraSinEsparjaController.clear();
    ahorroAlgVolqueteController.clear();
    ahorroAlgExcavadorController.clear();
    ahorroCementoController.clear();
    consumoCementoController.clear();
    ahorroNetoController.clear();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != DateTime.now()) {
      controller.text =
          "${selectedDate.toLocal()}".split(' ')[0]; // Format: YYYY-MM-DD
    }
  }

  void _agregarFilaManual() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nueva fila'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePickerField('Fecha de inicio', fechaInicioController),
                _buildDatePickerField('Fecha Fin', fechaFinController),
                _buildTextField('Tipo de lodo', tipoLodoController),
                _buildTextField('Ubicación', ubicacionController),
                _buildTextField('Tratado', tratadoController),
                _buildTextField('Tierra utilizada', tierraUtilizadaController),
                _buildTextField('Lodo utilizado', lodoUtilizadoController),
                _buildTextField('Excavado', excavadoController),
                _buildTextField('Volqexc', volqexcController),
                _buildTextField('Total Lodos (Ton)', totalLodosController),
                _buildTextField(
                    'Total Lixiviados (Ton)', totalLixiviadosController),
                _buildTextField('Tierra estabilizada (Tierra utilizada)',
                    tierraEstabilizadaController),
                _buildTextField(
                    'Lugar de Disposición', lugarDisposicionController),
                _buildTextField('Tierra usada', tierraUsadaController),
                _buildTextField('Ratio cementado', ratioCementadoController),
                _buildTextField('Tierra ahorrada', tierraAhorradaController),
                _buildTextField('Total de Tierra sin esparja',
                    totalTierraSinEsparjaController),
                _buildTextField(
                    'Ahorro Alg. Volquete', ahorroAlgVolqueteController),
                _buildTextField(
                    'Ahorro Alg. Excavador', ahorroAlgExcavadorController),
                _buildTextField('Ahorro en cemento', ahorroCementoController),
                _buildTextField('Consumo cemento', consumoCementoController),
                _buildTextField('Ahorro neto', ahorroNetoController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _guardarFila();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () => _selectDate(context, controller),
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha Inicio')),
                    DataColumn(label: Text('Fecha Fin')),
                    DataColumn(label: Text('Tipo Lodo')),
                    DataColumn(label: Text('Ubicación')),
                    DataColumn(label: Text('Tratado')),
                    DataColumn(label: Text('Tierra Utilizada')),
                    DataColumn(label: Text('Lodo Utilizado')),
                    DataColumn(label: Text('Excavado')),
                    DataColumn(label: Text('Volqexc')),
                    DataColumn(label: Text('Total Lodos')),
                    DataColumn(label: Text('Total Lixiviados')),
                    DataColumn(label: Text('Tierra Estabilizada')),
                    DataColumn(label: Text('Lugar Disposición')),
                    DataColumn(label: Text('Tierra Usada')),
                    DataColumn(label: Text('Ratio Cementado')),
                    DataColumn(label: Text('Tierra Ahorrada')),
                    DataColumn(label: Text('Total Tierra Sin Esparja')),
                    DataColumn(label: Text('Ahorro Alg. Volquete')),
                    DataColumn(label: Text('Ahorro Alg. Excavador')),
                    DataColumn(label: Text('Ahorro Cemento')),
                    DataColumn(label: Text('Consumo Cemento')),
                    DataColumn(label: Text('Ahorro Neto')),
                  ],
                  rows: tableData
                      .map(
                        (row) => DataRow(
                          cells:
                              row.map((cell) => DataCell(Text(cell))).toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _agregarFilaManual,
              child: const Text('Agregar fila manual'),
            ),
          ],
        ),
      ),
    );
  }
}
