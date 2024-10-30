// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:appsech/models/data_model.dart'; // Importa el modelo de datos que definimos

// class DataTableWidget extends StatelessWidget {
//   final List<DataModel> data; // Lista de datos para mostrar en la tabla

//   const DataTableWidget({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columns: const <DataColumn>[
//           DataColumn(label: Text('ID')),
//           DataColumn(label: Text('Fecha')),
//           DataColumn(label: Text('Hora Ingreso')),
//           DataColumn(label: Text('Hora Salida')),
//           DataColumn(label: Text('No. Pedido de Venta')),
//           DataColumn(label: Text('No. Boleta')),
//           DataColumn(label: Text('Código Residuo')),
//           DataColumn(label: Text('Residuo')),
//           DataColumn(label: Text('Nombre Producto Cliente')),
//           DataColumn(label: Text('Clasificación Sigersol')),
//           DataColumn(label: Text('Cliente')),
//           DataColumn(label: Text('Gestor')),
//           DataColumn(label: Text('Transportista')),
//           DataColumn(label: Text('Generador')),
//           DataColumn(label: Text('Guía Remitente')),
//           DataColumn(label: Text('Guía Transportista')),
//           DataColumn(label: Text('Cantidad')),
//           DataColumn(label: Text('Unidad Venta')),
//           DataColumn(label: Text('Valor Unitario')),
//           DataColumn(label: Text('Valor Total')),
//           DataColumn(label: Text('Manifiesto')),
//           DataColumn(label: Text('Placa')),
//           DataColumn(label: Text('Zona de Recepción')),
//           DataColumn(label: Text('Nombre Tratamiento')),
//           DataColumn(label: Text('Zona Tratamiento')),
//           DataColumn(label: Text('pH')),
//           DataColumn(label: Text('Inflamabilidad')),
//           DataColumn(label: Text('Coordenadas')),
//           DataColumn(label: Text('Cantidad Contenedor')),
//           DataColumn(label: Text('Tipo Contenedor')),
//           DataColumn(label: Text('Contenedores Adicionales')),
//           DataColumn(label: Text('Centro de Responsabilidad')),
//           DataColumn(label: Text('CCosto Code')),
//           DataColumn(label: Text('CC Cesion Interna Code')),
//           DataColumn(label: Text('Pesaje')),
//           DataColumn(label: Text('Creado')),
//           DataColumn(label: Text('Actualizado')),
//         ],
//         rows: data.map((item) => DataRow(
//           cells: [
//             DataCell(Text(item.id.toString())),
//             DataCell(Text(DateFormat('yyyy-MM-dd').format(item.fecha))),
//             DataCell(Text(item.horaIngreso)),
//             DataCell(Text(item.horaSalida)),
//             DataCell(Text(item.noPedidoDeVenta)),
//             DataCell(Text(item.noBoleta)),
//             DataCell(Text(item.codigoResiduo)),
//             DataCell(Text(item.residuo)),
//             DataCell(Text(item.nombreProductoCliente)),
//             DataCell(Text(item.clasificacionSigersol)),
//             DataCell(Text(item.cliente)),
//             DataCell(Text(item.gestor)),
//             DataCell(Text(item.transportista)),
//             DataCell(Text(item.generador)),
//             DataCell(Text(item.guiaRemitente)),
//             DataCell(Text(item.guiaTransportista)),
//             DataCell(Text(item.cantidad)),
//             DataCell(Text(item.unidadVenta)),
//             DataCell(Text(item.valorUnitario.toString())),
//             DataCell(Text(item.valorTotal.toString())),
//             DataCell(Text(item.manifiesto)),
//             DataCell(Text(item.placa)),
//             DataCell(Text(item.zonaDeRecepcion)),
//             DataCell(Text(item.nombreTratamiento)),
//             DataCell(Text(item.zonaTratamiento)),
//             DataCell(Text(item.ph.toString())),
//             DataCell(Text(item.inflamabilidad)),
//             DataCell(Text(item.coordenadas)),
//             DataCell(Text(item.cantidadContenedor)),
//             DataCell(Text(item.tipoContenedor)),
//             DataCell(Text(item.contenedoresAdicionales)),
//             DataCell(Text(item.centroDeResponsabilidad)),
//             DataCell(Text(item.ccostoCode)),
//             DataCell(Text(item.ccCesionInternaCode)),
//             DataCell(Text(item.pesaje)),
//             DataCell(Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(item.createdAt))),
//             DataCell(Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(item.updatedAt))),
//           ],
//         )).toList(),
//       ),
//     );
//   }
// }
