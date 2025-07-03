// 7. Acerca de
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/foto.jpeg'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jenry Sanchez',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Desarrollador Full Stack',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Datos de Contacto:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('📧 jenrydev@gmail.com'),
                  const Text('📱 +1 (829) 233 6246'),
                  const Text('💼 LinkedIn:  www.linkedin.com/in/jenry-sanchez'),
                  const Text('🌐 GitHub: Jenry560'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'jenrydev@gmail.com',
                        queryParameters: {
                          'subject': 'Oportunidad de Trabajo',
                          'body':
                              'Hola, me interesa contactarte para una oportunidad laboral.'
                        },
                      );

                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'No se pudo abrir el cliente de correo.';
                      }
                    },
                    child: const Text('Contactar para Trabajo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
