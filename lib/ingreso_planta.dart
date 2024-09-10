// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:appsech/models/data_grid.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:appsech/models/data_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class IngresoPlanta extends StatefulWidget {
  const IngresoPlanta({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IngresoPlantaState createState() => _IngresoPlantaState();
}

class _IngresoPlantaState extends State<IngresoPlanta> {
  late List<DataModel> data;
  late DataModelDataSource
      dataSource; // Declaración de dataSource como variable de instancia

  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    data = []; // Inicialización de la lista de datos
    fetchData(); // Llamada a la función para obtener datos
  }

  Future<void> fetchData() async {
    final url =
        Uri.parse('https://magussystems.com/appsheet/public/api/listar-datos');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON

        var jsonResponse = jsonDecode(response.body);

        // Verificar la estructura de la respuesta JSON
        if (jsonResponse is List) {
          // Si la respuesta es una lista, puedes manejarla directamente
          List<DataModel> newData =
              jsonResponse.map((json) => DataModel.fromJson(json)).toList();

          setState(() {
            data = newData;
            dataSource = DataModelDataSource(data);
            isLoading = false;
          });
        } else {
          // Manejar otros tipos de respuesta según la estructura esperada
          // print('Respuesta inesperada: $jsonResponse');
        }
      } else {
        // print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
  }

  Future<void> uploadExcel(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://magussystems.com/appsheet/public/api/upload-excel'),
        );
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          // Procesar la respuesta y actualizar la lista de datos
          fetchData(); // Volver a cargar los datos después de subir el archivo
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Archivo Excel cargado con éxito'),
              duration: Duration(seconds: 2),
            ),
          );
          setState(() {}); // Actualizar la UI para reflejar los nuevos datos
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fallo al cargar el archivo'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar la solicitud'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos a Planta'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      dataSource
                          .applyFilter(value); // Aplicar filtro al escribir
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                      hintText: 'Ingrese texto para buscar...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        // ignore: unnecessary_null_comparison
                        dataSource !=
                                null // Verifica si dataSource está inicializado
                            ? SfDataGrid(
                                source: dataSource,
                                columns: [
                                  GridColumn(
                                      columnName: 'ID',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('ID'))),
                                  GridColumn(
                                      columnName: 'Fecha',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Fecha'))),
                                  GridColumn(
                                      columnName: 'Hora Ingreso',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Hora Ingreso'))),
                                  GridColumn(
                                      columnName: 'Hora Salida',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Hora Salida'))),
                                  GridColumn(
                                      columnName: 'No. Pedido de Venta',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('No. Pedido de Venta'))),
                                  GridColumn(
                                      columnName: 'No. Boleta',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('No. Boleta'))),
                                  GridColumn(
                                      columnName: 'Código Residuo',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Código Residuo'))),
                                  GridColumn(
                                      columnName: 'Residuo',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Residuo'))),
                                  GridColumn(
                                      columnName: 'Nombre Producto Cliente',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:
                                              const Text('Nombre Producto Cliente'))),
                                  GridColumn(
                                      columnName: 'Clasificación Sigersol',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:
                                              const Text('Clasificación Sigersol'))),
                                  GridColumn(
                                      columnName: 'Cliente',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Cliente'))),
                                  GridColumn(
                                      columnName: 'Gestor',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Gestor'))),
                                  GridColumn(
                                      columnName: 'Transportista',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Transportista'))),
                                  GridColumn(
                                      columnName: 'Generador',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Generador'))),
                                  GridColumn(
                                      columnName: 'Guía Remitente',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Guía Remitente'))),
                                  GridColumn(
                                      columnName: 'Guía Transportista',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Guía Transportista'))),
                                  GridColumn(
                                      columnName: 'Cantidad',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Cantidad'))),
                                  GridColumn(
                                      columnName: 'Unidad Venta',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Unidad Venta'))),
                                  GridColumn(
                                      columnName: 'Valor Unitario',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Valor Unitario'))),
                                  GridColumn(
                                      columnName: 'Valor Total',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Valor Total'))),
                                  GridColumn(
                                      columnName: 'Manifiesto',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Manifiesto'))),
                                  GridColumn(
                                      columnName: 'Placa',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Placa'))),
                                  GridColumn(
                                      columnName: 'Zona de Recepción',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Zona de Recepción'))),
                                  GridColumn(
                                      columnName: 'Nombre Tratamiento',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Nombre Tratamiento'))),
                                  GridColumn(
                                      columnName: 'Zona Tratamiento',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Zona Tratamiento'))),
                                  GridColumn(
                                      columnName: 'pH',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('pH'))),
                                  GridColumn(
                                      columnName: 'Inflamabilidad',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Inflamabilidad'))),
                                  GridColumn(
                                      columnName: 'Coordenadas',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Coordenadas'))),
                                  GridColumn(
                                      columnName: 'Cantidad Contenedor',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Cantidad Contenedor'))),
                                  GridColumn(
                                      columnName: 'Tipo Contenedor',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Tipo Contenedor'))),
                                  GridColumn(
                                      columnName: 'Contenedores Adicionales',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                              'Contenedores Adicionales'))),
                                  GridColumn(
                                      columnName: 'Centro de Responsabilidad',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text(
                                              'Centro de Responsabilidad'))),
                                  GridColumn(
                                      columnName: 'CCosto Code',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('CCosto Code'))),
                                  GridColumn(
                                      columnName: 'CC Cesion Interna Code',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child:
                                              const Text('CC Cesion Interna Code'))),
                                  GridColumn(
                                      columnName: 'Pesaje',
                                      label: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.center,
                                          child: const Text('Pesaje'))),
                                ],
                                allowSorting: true,
                                allowMultiColumnSorting: true,
                                allowTriStateSorting: true,
                                // allowSortingColumnHeaderTap: true,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadExcel(
              context); // Llama a la función para cargar el archivo Excel
        },
        tooltip: 'Cargar Excel',
        child: const Icon(Icons.file_upload),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
