import 'package:concau/pages/about.dart';
import 'package:concau/pages/age_predictor.dart';
import 'package:concau/pages/gender_predictor_page.dart';
import 'package:concau/pages/news_wordpress.dart';
import 'package:concau/pages/pokemon.dart';
import 'package:concau/pages/universities.dart';
import 'package:concau/pages/weather.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja de Herramientas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen de caja de herramientas
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1504148455328-c376907d081c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Herramientas Disponibles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildToolCard(
                  context,
                  'Predictor de Género',
                  Icons.person,
                  Colors.purple,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GenderPredictorPage())),
                ),
                _buildToolCard(
                  context,
                  'Predictor de Edad',
                  Icons.cake,
                  Colors.orange,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AgePredictorPage())),
                ),
                _buildToolCard(
                  context,
                  'Universidades',
                  Icons.school,
                  Colors.green,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UniversitiesPage())),
                ),
                _buildToolCard(
                  context,
                  'Clima RD',
                  Icons.wb_sunny,
                  Colors.blue,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WeatherPage())),
                ),
                _buildToolCard(
                  context,
                  'Pokémon',
                  Icons.pets,
                  Colors.red,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PokemonPage())),
                ),
                _buildToolCard(
                  context,
                  'Noticias WordPress',
                  Icons.article,
                  Colors.teal,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WordPressNewsPage())),
                ),
                _buildToolCard(
                  context,
                  'Acerca de',
                  Icons.info,
                  Colors.indigo,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
