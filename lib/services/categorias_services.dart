
import 'dart:convert';

import 'package:app_noticias/model/categoria.dart';
import 'package:http/http.dart' as http;


class CategoriasServices {
  
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Categoria>> getCategoria() async{
    final resposta = await http.get(Uri.parse('$baseUrl/categorias'));

    try {
      if(resposta.statusCode == 200){

        final List dados = jsonDecode(resposta.body);

        return dados.map((item) => Categoria.fromJson(item)).toList();

      }else{
        throw Exception('Não foi possivel carregar as categorias');
      }
    } catch (e){
      throw Exception('Não foi possivel conectar, erro: $e');
    }
  }

}