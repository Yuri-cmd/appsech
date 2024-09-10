import 'package:flutter/material.dart';

class DfPage extends StatelessWidget {
  const DfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DF')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('USUARIO:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('RESPONSABLE DEL DEPÓSITO',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            const Text('ESPECIFICACIONES:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            const Text('Campos del modulo',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const Text('D1', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fecha',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      buildEditableField(context, isDate: true),
                      buildEditableField(context, isDate: true),
                      buildEditableField(context, isDate: true),
                      buildEditableField(context, isDate: true),
                      buildEditableField(context, isDate: true),
                      buildEditableField(context, isDate: true),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Residuos directos',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ing plataforma',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                      buildEditableField(context),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Ubicación D1',
                style: TextStyle(fontWeight: FontWeight.bold)),
            buildLocationTable(context),
            const SizedBox(height: 16.0),
            const Text('Bombeo de lixiviados',
                style: TextStyle(fontWeight: FontWeight.bold)),
            buildLeachatePumpingTable(context),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(BuildContext context, {bool isDate = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: isDate
              ? IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      // Tu lógica para manejar la selección de fecha
                    }
                  },
                )
              : null,
        ),
        readOnly: isDate,
      ),
    );
  }

  Widget buildLocationTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
              label:
                  Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Directo a depósito (Ton)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Ingreso desde Plataforma',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Ingreso de Tierra Estabilizada (Ton)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('H.H', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text('NAV')),
            const DataCell(Text('NAV')),
            DataCell(buildEditableField(context)),
            const DataCell(Text('Formula')),
            DataCell(buildEditableField(context)),
          ]),
          const DataRow(cells: [
            DataCell(Text('1/01/2024')),
            DataCell(Text('0')),
            DataCell(Text('0')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]),
          const DataRow(cells: [
            DataCell(Text('2/01/2024')),
            DataCell(Text('69')),
            DataCell(Text('0')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]),
        ],
      ),
    );
  }

  Widget buildLeachatePumpingTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
              label:
                  Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Hora inicia',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Hora Final',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Responsable',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          DataRow(cells: [
            DataCell(buildEditableField(context, isDate: true)),
            DataCell(buildEditableField(context)),
            DataCell(buildEditableField(context)),
            DataCell(buildEditableField(context)),
          ]),
          const DataRow(cells: [
            DataCell(Text('Buzon de lixiviados',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('m3', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(SizedBox.shrink()),
            DataCell(SizedBox.shrink()),
          ]),
          buildLeachateRow('Buzon 1'),
          buildLeachateRow('Buzon 2'),
          buildLeachateRow('Buzon 3'),
          buildLeachateRow('Buzon 7'),
          buildLeachateRow('Balsa de Lixiviados'),
        ],
      ),
    );
  }

  DataRow buildLeachateRow(String label) {
    return DataRow(cells: [
      DataCell(Text(label)),
      const DataCell(Text('0')),
      const DataCell(SizedBox.shrink()),
      const DataCell(SizedBox.shrink()),
    ]);
  }
}
