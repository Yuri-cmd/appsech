import 'package:flutter/material.dart';

class TablaTratamientosScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TablaTratamientosScreen({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Tratamientos'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Fecha de inicio')),
            DataColumn(label: Text('Fecha Fin')),
            DataColumn(label: Text('Tipo de desvío')),
            DataColumn(label: Text('Ubicación')),
            DataColumn(label: Text('Total Tratado (Ton)')),
            DataColumn(label: Text('Tierra utilizada')),
            DataColumn(label: Text('Cemento utilizado')),
            DataColumn(label: Text('H.Excavadora')),
            DataColumn(label: Text('H.Volquete')),
            DataColumn(label: Text('Total Lodos (Ton)')),
            DataColumn(label: Text('Total Lixiviados (Ton)')),
            DataColumn(label: Text('Tierra estabilizada (Ton)')),
            DataColumn(label: Text('Residuo utilizado')),
            DataColumn(label: Text('Lugar de Disposición')),
            DataColumn(label: Text('Ratio tierra')),
            DataColumn(label: Text('Ratio cemento')),
            DataColumn(label: Text('Ratio Hr. Exc / Tn tierra')),
            DataColumn(label: Text('Ratio volq / Tn tierra')),
            DataColumn(label: Text('Ratio cemento')),
            DataColumn(label: Text('Tierra ahorrada')),
            DataColumn(label: Text('Total de Tierra sin mejoras')),
            DataColumn(label: Text('Ahorro Alq. Volquete')),
            DataColumn(label: Text('Ahorro Alq. Excavadora')),
            DataColumn(label: Text('Ahorro en combustible (PEN)')),
            DataColumn(label: Text('Consumo cemento')),
            DataColumn(label: Text('Ahorros neto')),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('01/01/2024')),
              DataCell(Text('31/01/2024')),
              DataCell(Text('Desvío Tipo A')),
              DataCell(Text('Ubicación 1')),
              DataCell(Text('90')),
              DataCell(Text('50')),
              DataCell(Text('10')),
              DataCell(Text('2h')),
              DataCell(Text('3h')),
              DataCell(Text('5')),
              DataCell(Text('4')),
              DataCell(Text('70')),
              DataCell(Text('0')),
              DataCell(Text('L2')),
              DataCell(Text('0.5')),
              DataCell(Text('0.7')),
              DataCell(Text('0.3')),
              DataCell(Text('0.2')),
              DataCell(Text('0.1')),
              DataCell(Text('0')),
              DataCell(Text('100')),
              DataCell(Text('50')),
              DataCell(Text('20')),
              DataCell(Text('10')),
              DataCell(Text('0')),
              DataCell(Text('0')), // Añadir celda si es necesario
            ]),
            // Agrega más filas según sea necesario
          ],
        ),
      ),
    );
  }
}
