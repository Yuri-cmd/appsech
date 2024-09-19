import 'package:flutter/material.dart';

class ActivityModal extends StatefulWidget {
  final double totalHours; // Horas ingresadas en el formulario principal

  ActivityModal({required this.totalHours});

  @override
  _ActivityModalState createState() => _ActivityModalState();
}

class _ActivityModalState extends State<ActivityModal> {
  final List<Map<String, dynamic>> _activities = [];
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  double _remainingHours = 0;

  @override
  void initState() {
    super.initState();
    _remainingHours = widget.totalHours;
  }

  void _addActivity() {
    final activity = _activityController.text;
    final hours = double.tryParse(_hoursController.text) ?? 0;

    if (activity.isEmpty || hours <= 0 || hours > _remainingHours) {
      return; // Mostrar mensaje de error si es necesario
    }

    setState(() {
      _activities.add({'activity': activity, 'hours': hours});
      _remainingHours -= hours;
    });

    _activityController.clear();
    _hoursController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Actividad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _activityController,
            decoration: const InputDecoration(labelText: 'Actividad'),
          ),
          TextField(
            controller: _hoursController,
            decoration: const InputDecoration(labelText: 'Horas'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          Text('Horas restantes: $_remainingHours'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addActivity,
            child: const Text('Agregar'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return ListTile(
                  title: Text(activity['activity']),
                  subtitle: Text('${activity['hours']} horas'),
                );
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
