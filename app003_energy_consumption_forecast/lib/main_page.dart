import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuration_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> _meterReadings = [];

  _openAddReadingModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddReadingModal(onAddReading: _addReading);
      },
    );
  }

  _addReading(DateTime date, double reading) {
    setState(() {
      _meterReadings.add({
        'date': date,
        'reading': reading,
        'difference': _meterReadings.isNotEmpty ? reading - _meterReadings.last['reading'] : 0
      });
      _meterReadings.sort((a, b) => b['date'].compareTo(a['date']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Meter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigurationPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _meterReadings.length,
        itemBuilder: (context, index) {
          final reading = _meterReadings[index];
          return ListTile(
            title: Text('Date: ${reading['date']}'),
            subtitle: Text('Reading: ${reading['reading']} kW/h, Difference: ${reading['difference']} kW/h'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReadingModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddReadingModal extends StatefulWidget {
  final Function(DateTime, double) onAddReading;

  AddReadingModal({required this.onAddReading});

  @override
  _AddReadingModalState createState() => _AddReadingModalState();
}

class _AddReadingModalState extends State<AddReadingModal> {
  final TextEditingController _readingController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submit() {
    if (_readingController.text.isNotEmpty) {
      widget.onAddReading(_selectedDate, double.parse(_readingController.text));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Meter Reading'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _readingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Reading in kW/h'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != _selectedDate)
                setState(() {
                  _selectedDate = pickedDate;
                });
            },
            child: const Text('Select Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
