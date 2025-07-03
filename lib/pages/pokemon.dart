// 5. Pokémon
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController _pokemonController = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;
  final AudioPlayer _justAudioPlayer = AudioPlayer();

  Future<void> _searchPokemon() async {
    if (_pokemonController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://pokeapi.co/api/v2/pokemon/${_pokemonController.text.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pokemonData = data;
        });
      } else {
        throw Exception('Pokemon no encontrado');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon no encontrado')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playCry() async {
    if (_pokemonData != null) {
      try {
        // Obtener la URL del audio
        final String url = _pokemonData!['cries']['latest'];

        // Cargar la URL y reproducir
        await _justAudioPlayer.setUrl(url);
        await _justAudioPlayer.play();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo reproducir el sonido')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pokemonController,
              decoration: const InputDecoration(
                labelText: 'Ingresa el nombre del Pokémon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchPokemon,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Buscar Pokémon'),
            ),
            const SizedBox(height: 20),
            if (_pokemonData != null) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _pokemonData!['name'].toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Image.network(
                            _pokemonData!['sprites']['front_default'],
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Experiencia Base: ${_pokemonData!['base_experience']}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Habilidades:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...(_pokemonData!['abilities'] as List)
                              .map(
                                  (ability) => Text(ability['ability']['name']))
                              .toList(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _playCry,
                            child: const Text('Reproducir Sonido'),
                          ),
                        ],
                      ),
                    ),
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
