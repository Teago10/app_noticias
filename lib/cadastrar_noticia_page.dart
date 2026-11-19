import 'dart:io';

import 'package:app_noticias/model/categoria.dart';
import 'package:app_noticias/model/noticia.dart';
import 'package:app_noticias/services/categorias_services.dart';
import 'package:app_noticias/services/noticias_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarNoticiaPage extends StatefulWidget {
  final Noticia? noticia;
  const CadastrarNoticiaPage({super.key, this.noticia});

  @override
  State<CadastrarNoticiaPage> createState() => _CadastrarNoticiaPageState();
}

class _CadastrarNoticiaPageState extends State<CadastrarNoticiaPage> {
  final NoticiasService _noticiasService = NoticiasService();
  final CategoriasServices _categoriasServices = CategoriasServices();

  final _tituloController = TextEditingController();
  final _resumoController = TextEditingController();
  final _conteudoController = TextEditingController();

  File? _imagemSelecionada;
  List<Categoria> _categorias = [];
  int? _categoriaSelecionadaId;
  late bool _status = true;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    carregarCategorias();

    if(widget.noticia != null){
      _tituloController.text = widget.noticia!.titulo;
      _resumoController.text = widget.noticia!.resumo;
      _conteudoController.text = widget.noticia!.conteudo;
      _categoriaSelecionadaId = widget.noticia!.categoriaId;
      _status = widget.noticia!.status == true || widget.noticia!.status == 1;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _resumoController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasServices.getCategoria();

      if (!mounted) return;

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  Future<void> salvarNoticia() async {
    if (_tituloController.text.isEmpty ||
        _resumoController.text.isEmpty ||
        _conteudoController.text.isEmpty ||
        _categoriaSelecionadaId == null ||
        (widget.noticia == null && _imagemSelecionada == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatorios'),
        ),
      );

      return;
    }

    try {
      if (widget.noticia == null) {
        // cadastrar
        await _noticiasService.criarNoticia(
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      } else {
        // editar

        await _noticiasService.editarNoticia(
          id: widget.noticia!.id,
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.noticia == null
                ? 'Noticia cadastrada com sucesso'
                : 'Noticia atualizada com sucesso',
          ),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar noticia.'),
        ),
      );
    }
  }

  Future<void> _selecionarImagem(ImageSource origem) async {
    final arquivo = await ImagePicker().pickImage(source: origem);
    if (arquivo != null) {
      setState(() {
        _imagemSelecionada = File(arquivo.path);
      });
    }
  }

  Future<void> _publicarNoticia() async {
    if (_tituloController.text.isEmpty ||
        _resumoController.text.isEmpty ||
        _conteudoController.text.isEmpty ||
        _categoriaSelecionadaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    try {
      await _noticiasService.criarNoticia(
        titulo: _tituloController.text,
        resumo: _resumoController.text,
        conteudo: _conteudoController.text,
        categoriaId: _categoriaSelecionadaId!,
        status: true,
        imagemArquivo: _imagemSelecionada,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notícia publicada com sucesso')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noticia == null ? 'Cadastrar Noticia' : 'Editar Noticia',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          TextFormField(
            controller: _resumoController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Resumo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          TextFormField(
            controller: _conteudoController,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Conteudo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Imagem de Capa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD7D7D7),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(3),
            ),
            child: _imagemSelecionada == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )
                : Image.file(
                    _imagemSelecionada!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, erro, stack) => const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selecionarImagem(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selecionarImagem(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Categorias',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            initialValue: _categoriaSelecionadaId,
            items: _categorias.map((categoria) {
              return DropdownMenuItem<int>(
                value: categoria.id,
                child: Text(categoria.nome),
              );
            }).toList(),
            onChanged: (valor) {
              setState(() {
                _categoriaSelecionadaId = valor;
              });
            },
          ),
          const SizedBox(height: 25),

          SwitchListTile(
            value: _status, 
            contentPadding: EdgeInsets.zero,
            title: const Text('Publicação ativa'),
            onChanged: (valor){
              setState(() {
                _status = valor;
              });
            },
            
          
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: _publicarNoticia,
            child: Text(
              widget.noticia == null ? 'Publicar noticia' : 'Salvar alterações'
            ),
          ),
        ],
      ),
    );
  }
}
