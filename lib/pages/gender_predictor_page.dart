import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 1. Predictor de Género
class GenderPredictorPage extends StatefulWidget {
  const GenderPredictorPage({super.key});

  @override
  _GenderPredictorPageState createState() => _GenderPredictorPageState();
}

class _GenderPredictorPageState extends State<GenderPredictorPage> {
  final TextEditingController _nameController = TextEditingController();
  String _result = '';
  bool _isLoading = false;
  Color _backgroundColor = Colors.white;

  Future<void> _predictGender() async {
    if (_nameController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.genderize.io/?name=${_nameController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final gender = data['gender'];
        final probability = data['probability'];

        setState(() {
          _result =
              'Nombre: ${data['name']}\nGénero: $gender\nProbabilidad: ${(probability * 100).toStringAsFixed(1)}%';
          _backgroundColor =
              gender == 'male' ? Colors.blue[100]! : Colors.pink[100]!;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error al obtener datos';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predictor de Género')),
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ingresa un nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _predictGender,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Predecir Género'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
