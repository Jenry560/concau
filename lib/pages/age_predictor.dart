// 2. Predictor de Edad
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgePredictorPage extends StatefulWidget {
  const AgePredictorPage({super.key});

  @override
  _AgePredictorPageState createState() => _AgePredictorPageState();
}

class _AgePredictorPageState extends State<AgePredictorPage> {
  final TextEditingController _nameController = TextEditingController();
  String _result = '';
  bool _isLoading = false;
  String _ageCategory = '';
  String _imageUrl = '';

  Future<void> _predictAge() async {
    if (_nameController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.agify.io/?name=${_nameController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final age = data['age'];

        String category;
        String imageUrl;

        if (age < 18) {
          category = 'Joven';
          imageUrl =
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&q=80';
        } else if (age < 60) {
          category = 'Adulto';
          imageUrl =
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&q=80';
        } else {
          category = 'Anciano';
          imageUrl =
              'https://images.unsplash.com/photo-1566616213894-2d4e1baee5d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=300&q=80';
        }

        setState(() {
          _result = 'Nombre: ${data['name']}\nEdad estimada: $age años';
          _ageCategory = category;
          _imageUrl = imageUrl;
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
      appBar: AppBar(title: const Text('Predictor de Edad')),
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
              onPressed: _isLoading ? null : _predictAge,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Predecir Edad'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _result,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Categoría: $_ageCategory',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrl,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
