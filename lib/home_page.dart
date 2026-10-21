import 'package:app_noticias/detalhe_noticia_page.dart';
import 'package:app_noticias/model/categoria.dart';
import 'package:app_noticias/model/noticia.dart';
import 'package:app_noticias/services/categorias_services.dart';
import 'package:app_noticias/services/noticias_service.dart';
import 'package:app_noticias/services/sobre_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticiasService _noticiasService = NoticiasService();
  late Future<List<Noticia>> _listaNoticia;
  final CategoriasServices _categoriasServices = CategoriasServices();

  List<Categoria> _listaCategorias = [];
  String _categoriaSelecionada = 'Todas';

  static final List<String> categorias = ["Todas"];

  bool _buscando = false;
  String _textoPesquisa = '';

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasServices.getCategoria();

      if (!mounted) return;

      setState(() {
        _listaCategorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  List<Noticia> aplicarFiltro(List<Noticia> noticias) {
    if (_textoPesquisa.isNotEmpty) {
      return noticias.where((noticia) {
        return noticia.titulo.toLowerCase().contains(
              _textoPesquisa.toLowerCase(),
            ) ||
            noticia.resumo.toLowerCase().contains(
              _textoPesquisa.toLowerCase(),
            );
      }).toList();
    }

    if (_categoriaSelecionada != 'Todas') {
      return noticias.where((noticia) {
        return noticia.categoriaNome.toLowerCase() ==
            _categoriaSelecionada.toLowerCase();
      }).toList();
    }

    return noticias;
  }

  @override
  void initState() {
    super.initState();
    _listaNoticia = _noticiasService.getNoticia();
    carregarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Pesquisando...',
                ),
                onChanged: (valor) {
                  setState(() {
                    _textoPesquisa = valor;
                  });
                },
              )
            : Image.asset(
                'assets/img/logotipo.png',
                height: 22,
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _buscando = !_buscando;

                  if (!_buscando) {
                    _textoPesquisa = '';
                  }
                });
              },
              icon: Icon(
                _buscando ? Icons.close : Icons.search,
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/img/logotipo.png',
                height: 24,
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Lista de Noticias'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SobrePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: _listaCategorias.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemBuilder: (context, index) {
                final categoria = index == 0
                    ? 'Todas'
                    : _listaCategorias[index - 1].nome;

                final selecionada = _categoriaSelecionada == categoria;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: selecionada
                            ? Colors.black
                            : const Color(0xFFEDEDED),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categoria,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: _listaNoticia,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text('${asyncSnapshot.error}'),
                  );
                }

                final todasNoticias = asyncSnapshot.data ?? [];

                final noticias = aplicarFiltro(todasNoticias);

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = noticias[index];

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalheNoticiaPage(noticia: noticia),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFCBD2D9),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120,
                              color: const Color(0xFFE4E9EF),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        child: Text(
                                          noticia.categoriaNome,
                                        ),
                                      ),

                                      const SizedBox(width: 15),

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
                                    overflow: TextOverflow.ellipsis,
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
