class Noticia {

  final int id;
  final String titulo;
  final String resumo;
  final String conteudo;
  final int categoriaId;
  final String? imagem;
  final DateTime createAt;


  Noticia({
    required this.id,
    required this.titulo, 
    required this.resumo, 
    required this.conteudo, 
    required this.categoriaId, 
    required this.imagem, 
    required this.createAt
  });

  factory Noticia.fromJson(Map<String, dynamic> json){
    return Noticia(
      id: json['id'], 
      titulo: json['titulo'], 
      resumo: json['resumo'], 
      conteudo: json['conteudo'], 
      categoriaId: json['categoria_id'], 
      imagem: json['imagem'], 
      createAt: DateTime.parse(json['createAt']),
    );
  }


  String get dataFormatada{
    final dia = createAt.day.toString().padLeft(2,'0');
    final mes = createAt.month.toString().padLeft(2,'0');
    final ano = createAt.year.toString();

    return '$dia/$mes/$ano';
  }

}