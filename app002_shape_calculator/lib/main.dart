import 'package:flutter/material.dart';

void main() {
  runApp(ShapeCalculatorApp());
}

class ShapeCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shape Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShapeCalculatorScreen(),
    );
  }
}

class ShapeCalculatorScreen extends StatefulWidget {
  @override
  _ShapeCalculatorScreenState createState() => _ShapeCalculatorScreenState();
}

class _ShapeCalculatorScreenState extends State<ShapeCalculatorScreen> {
  String _selectedShape = 'Circle';
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double _area = 0;
  double _perimeter = 0;

  void _calculate() {
    setState(() {
      if (_selectedShape == 'Circle') {
        final radius = double.tryParse(_radiusController.text) ?? 0;
        _area = 3.14159 * radius * radius;
        _perimeter = 2 * 3.14159 * radius;
      } else if (_selectedShape == 'Rectangle') {
        final width = double.tryParse(_widthController.text) ?? 0;
        final height = double.tryParse(_heightController.text) ?? 0;
        _area = width * height;
        _perimeter = 2 * (width + height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shape Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _selectedShape,
              items: ['Circle', 'Rectangle'].map((String shape) {
                return DropdownMenuItem<String>(
                  value: shape,
                  child: Text(shape),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedShape = value!;
                  _radiusController.clear();
                  _widthController.clear();
                  _heightController.clear();
                  _area = 0;
                  _perimeter = 0;
                });
              },
            ),
            if (_selectedShape == 'Circle')
              TextField(
                controller: _radiusController,
                decoration: const InputDecoration(labelText: 'Radius'),
                keyboardType: TextInputType.number,
              ),
            if (_selectedShape == 'Rectangle') ...[
              TextField(
                controller: _widthController,
                decoration: const InputDecoration(labelText: 'Width'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text('Area: $_area'),
            Text('Perimeter: $_perimeter'),
          ],
        ),
      ),
    );
  }
}
