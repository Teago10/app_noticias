import 'package:app_noticias/model/noticia.dart';
import 'package:flutter/material.dart';

class DetalheNoticiaPage extends StatelessWidget {
  final Noticia noticia;

  const DetalheNoticiaPage({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              color: const Color(0xFFE4E9Ef),
              child: Image.network(
                noticia.imagem!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.image_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepPurple,
                          ),
                        ),
                        child: Text(noticia.categoriaNome),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        noticia.dataFormatada,
                        style: const TextStyle(
                          color: Color(0xFF858D96),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow
                        .ellipsis, // coloca ... no final caso o texto ultrapasse duas linhas
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noticia.resumo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF586879),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
