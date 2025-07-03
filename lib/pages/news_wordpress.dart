// 6. Noticias WordPress
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class WordPressNewsPage extends StatefulWidget {
  @override
  _WordPressNewsPageState createState() => _WordPressNewsPageState();
}

class _WordPressNewsPageState extends State<WordPressNewsPage> {
  List<dynamic> _news = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Usando WordPress REST API de un sitio público
      final response = await http.get(
        Uri.parse('https://ma.tt/wp-json/wp/v2/posts?per_page=3'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _news = data;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener noticias')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      SizedBox(
                        width: 40, // Ancho del círculo
                        height: 40, // Alto del círculo
                        child: ClipOval(
                          child: Image(
                            image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/WordPress_blue_logo.svg/1024px-WordPress_blue_logo.svg.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Blog Ma.tt',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _news.length,
                    itemBuilder: (context, index) {
                      final article = _news[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            article['title']['rendered'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['excerpt']['rendered']
                                    .replaceAll(RegExp(r'<[^>]*>'), '')
                                    .trim(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final url = article['link'];
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                child: const Text(
                                  'Visitar artículo',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
