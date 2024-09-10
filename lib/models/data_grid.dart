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
            DataGridCell<String>(columnName: 'ID', value: model.id.toString()),
            DataGridCell<String>(
                columnName: 'Fecha', value: model.fecha.toString()),
            DataGridCell<String>(
                columnName: 'Hora Ingreso', value: model.horaIngreso),
            DataGridCell<String>(
                columnName: 'Hora Salida', value: model.horaSalida),
            DataGridCell<String>(
                columnName: 'No. Pedido de Venta',
                value: model.noPedidoDeVenta),
            DataGridCell<String>(
                columnName: 'No. Boleta', value: model.noBoleta),
            DataGridCell<String>(
                columnName: 'Código Residuo', value: model.codigoResiduo),
            DataGridCell<String>(columnName: 'Residuo', value: model.residuo),
            DataGridCell<String>(
                columnName: 'Nombre Producto Cliente',
                value: model.nombreProductoCliente),
            DataGridCell<String>(
                columnName: 'Clasificación Sigersol',
                value: model.clasificacionSigersol),
            DataGridCell<String>(columnName: 'Cliente', value: model.cliente),
            DataGridCell<String>(columnName: 'Gestor', value: model.gestor),
            DataGridCell<String>(
                columnName: 'Transportista', value: model.transportista),
            DataGridCell<String>(
                columnName: 'Generador', value: model.generador),
            DataGridCell<String>(
                columnName: 'Guía Remitente', value: model.guiaRemitente),
            DataGridCell<String>(
                columnName: 'Guía Transportista',
                value: model.guiaTransportista),
            DataGridCell<String>(columnName: 'Cantidad', value: model.cantidad),
            DataGridCell<String>(
                columnName: 'Unidad Venta', value: model.unidadVenta),
            DataGridCell<String>(
                columnName: 'Valor Unitario',
                value: model.valorUnitario.toString()),
            DataGridCell<String>(
                columnName: 'Valor Total', value: model.valorTotal.toString()),
            DataGridCell<String>(
                columnName: 'Manifiesto', value: model.manifiesto),
            DataGridCell<String>(columnName: 'Placa', value: model.placa),
            DataGridCell<String>(
                columnName: 'Zona de Recepción', value: model.zonaDeRecepcion),
            DataGridCell<String>(
                columnName: 'Nombre Tratamiento',
                value: model.nombreTratamiento),
            DataGridCell<String>(
                columnName: 'Zona Tratamiento', value: model.zonaTratamiento),
            DataGridCell<String>(columnName: 'pH', value: model.ph.toString()),
            DataGridCell<String>(
                columnName: 'Inflamabilidad', value: model.inflamabilidad),
            DataGridCell<String>(
                columnName: 'Coordenadas', value: model.coordenadas),
            DataGridCell<String>(
                columnName: 'Cantidad Contenedor',
                value: model.cantidadContenedor),
            DataGridCell<String>(
                columnName: 'Tipo Contenedor', value: model.tipoContenedor),
            DataGridCell<String>(
                columnName: 'Contenedores Adicionales',
                value: model.contenedoresAdicionales),
            DataGridCell<String>(
                columnName: 'Centro de Responsabilidad',
                value: model.centroDeResponsabilidad),
            DataGridCell<String>(
                columnName: 'CCosto Code', value: model.ccostoCode),
            DataGridCell<String>(
                columnName: 'CC Cesion Interna Code',
                value: model.ccCesionInternaCode),
            DataGridCell<String>(
                columnName: 'Pesaje', value: model.pesaje.toString()),
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
