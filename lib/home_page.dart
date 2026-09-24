import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Map<String, dynamic>> noticias = [
  {
    'titulo': 'Nova tecnologia promete revolucionar os celulares',
    'resumo': 'Uma nova tecnologia foi apresentada e promete melhorar o desempenho e a bateria dos smartphones.',
    'categoria': 'Tecnologia',
    'data': '23/09/2026',
  },
  {
    'titulo': 'Brasil ganha destaque no cenário internacional',
    'resumo': 'O país recebeu destaque após novos avanços em tecnologia e inovação.',
    'categoria': 'Brasil',
    'data': '22/09/2026',
  },
  {
    'titulo': 'Novo jogo é lançado para consoles e PC',
    'resumo': 'O aguardado jogo chegou ao mercado com gráficos aprimorados e novas funcionalidades.',
    'categoria': 'Games',
    'data': '21/09/2026',
  },
  {
    'titulo': 'Mercado de tecnologia apresenta crescimento',
    'resumo': 'Empresas do setor registraram crescimento nas vendas durante o último trimestre.',
    'categoria': 'Economia',
    'data': '20/09/2026',
  },
  {
    'titulo': 'Aplicativo facilita o acesso às notícias',
    'resumo': 'Uma nova plataforma foi criada para reunir notícias de diferentes categorias em um único lugar.',
    'categoria': 'Tecnologia',
    'data': '19/09/2026',
  },
];

  static final List<String> categorias = [
    "Todas",
    "Tecnologia", 
    "Economia", 
    "Games", 
    "Brasil",
    ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/img/logotipo.png',
        height: 22,
        ),
        centerTitle: true,
        actions: [
          const Padding(
            padding:  EdgeInsets.only(right: 12),
            child:  Icon(Icons.search),
          )
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: categorias.map((categoria) {

                final selecionada = categoria == "Todas";

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: selecionada
                    ? Colors.black 
                    : const Color(0xFFEDEDED))
                  ),
                  alignment: Alignment.center,
                  child: Text(categoria, style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
            ),
        ],
      ),
    );
  }
}