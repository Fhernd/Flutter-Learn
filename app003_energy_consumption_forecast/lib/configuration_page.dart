import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TextEditingController _kwCostController = TextEditingController();
  final TextEditingController _lastPaidBillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _kwCostController.text = (prefs.getDouble('kwCost') ?? 0.0).toString();
      _lastPaidBillController.text = (prefs.getDouble('lastPaidBill') ?? 0.0).toString();
    });
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('kwCost', double.parse(_kwCostController.text));
    prefs.setDouble('lastPaidBill', double.parse(_lastPaidBillController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _kwCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'kW/h Cost'),
            ),
            TextField(
              controller: _lastPaidBillController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Last Paid Bill'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _savePreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preferences saved!')),
                );
              },
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
