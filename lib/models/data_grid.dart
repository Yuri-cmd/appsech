import 'package:appsech/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataModelDataSource extends DataGridSource {
  List<DataModel> data;
  List<DataModel> filteredData = [];

  DataModelDataSource(this.data) {
    filteredData.addAll(data); // Inicialmente llena los datos filtrados
  }

  // Método para aplicar el filtro según el texto de búsqueda
  void applyFilter(String text) {
    filteredData.clear();
    filteredData.addAll(data.where((model) =>
        model.id.toString().contains(text) ||
        model.fecha.toString().contains(text.toLowerCase()) ||
        model.horaIngreso.toLowerCase().contains(text.toLowerCase()) ||
        model.horaSalida.toLowerCase().contains(text.toLowerCase()) ||
        model.codigoResiduo.toLowerCase().contains(text.toLowerCase()) ||
        model.residuo.toLowerCase().contains(text.toLowerCase()) ||
        model.nombreProductoCliente
            .toLowerCase()
            .contains(text.toLowerCase()) ||
        model.cliente.toLowerCase().contains(text.toLowerCase())));
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => filteredData
      .map<DataGridRow>((model) => DataGridRow(cells: [
            DataGridCell<String>(
                columnName: 'ID', value: model.id.toString() ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Fecha', value: model.fecha.toString() ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Hora Ingreso', value: model.horaIngreso ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Hora Salida', value: model.horaSalida ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'No. Pedido de Venta',
                value: model.noPedidoDeVenta ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'No. Boleta', value: model.noBoleta ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Código Residuo',
                value: model.codigoResiduo ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Residuo', value: model.residuo ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Nombre Producto Cliente',
                value: model.nombreProductoCliente ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Clasificación Sigersol',
                value: model.clasificacionSigersol ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Cliente', value: model.cliente ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Gestor', value: model.gestor ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Transportista',
                value: model.transportista ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Generador', value: model.generador ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Guía Remitente',
                value: model.guiaRemitente ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Guía Transportista',
                value: model.guiaTransportista ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Cantidad', value: model.cantidad ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Unidad Venta', value: model.unidadVenta ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Valor Unitario',
                value: model.valorUnitario.toString() ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Valor Total',
                value: model.valorTotal.toString() ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Manifiesto', value: model.manifiesto ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Placa', value: model.placa ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Zona de Recepción',
                value: model.zonaDeRecepcion ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Nombre Tratamiento',
                value: model.nombreTratamiento ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Zona Tratamiento',
                value: model.zonaTratamiento ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'pH', value: model.ph.toString() ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Inflamabilidad',
                value: model.inflamabilidad ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Coordenadas', value: model.coordenadas ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Cantidad Contenedor',
                value: model.cantidadContenedor ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Tipo Contenedor',
                value: model.tipoContenedor ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Contenedores Adicionales',
                value: model.contenedoresAdicionales ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Centro de Responsabilidad',
                value: model.centroDeResponsabilidad ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'CCosto Code', value: model.ccostoCode ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'CC Cesion Interna Code',
                value: model.ccCesionInternaCode ?? 'N/A'),
            DataGridCell<String>(
                columnName: 'Pesaje', value: model.pesaje.toString() ?? 'N/A'),
          ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
