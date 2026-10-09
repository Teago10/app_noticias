import 'dart:convert';

import 'package:app_noticias/model/noticia.dart';
import 'package:http/http.dart' as http;


class NoticiasService {

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Noticia>> getNoticia() async{
    final resposta = await http.get(Uri.parse('$baseUrl/noticias'));

    try {
      if(resposta.statusCode == 200){

        final List dados = jsonDecode(resposta.body);
        
        return dados.map((item) => Noticia.fromJson(item)).toList();

      }else{
        throw Exception('Não foi possivel carregar as notícias');
      }
    } catch (e) {
      throw Exception('Não foi possivel conectar, erro: $e');

    }

  }

}