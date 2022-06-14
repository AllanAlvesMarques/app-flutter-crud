import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/produtos_database_controller.dart';
import '../models/produtos_model.dart';

// ignore: must_be_immutable
class CadastrarAlterarProdutos extends StatefulWidget {
  CadastrarAlterarProdutos(this.title, this.produto, {Key? key})
      : super(key: key);

  String title;
  ProdutosModel? produto;

  @override
  State<CadastrarAlterarProdutos> createState() =>
      _CadastrarAlterarProdutosState();
}

class _CadastrarAlterarProdutosState extends State<CadastrarAlterarProdutos> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.produto != null) {
      _formData['Produto'] = widget.produto!.nome!;
      _formData['Preço'] = widget.produto!.preco!;
      _formData['Estoque'] = widget.produto!.estoque!;
      _formData['Descrição'] = widget.produto!.desc!;
      _formData['Imagem1'] = widget.produto!.img1!;
      _formData['Imagem2'] = widget.produto!.img2!;
      _formData['Imagem3'] = widget.produto!.img3!;
      _formData['Imagem4'] = widget.produto!.img4!;
      _formData['Imagem5'] = widget.produto!.img5!;
    } else {
      widget.produto = ProdutosModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 30, bottom: 20),
                child: TextFormField(
                  initialValue: _formData['Produto'],
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Informe o nome do produto';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['Produto'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Produto",
                    prefixIcon: Icon(Icons.computer),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: _formData['Preço'],
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Informe o preço do produto';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['Preço'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Preço",
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: _formData['Estoque'],
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Informe a quantia de estoque do produto';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['Estoque'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Estoque",
                    prefixIcon: Icon(Icons.local_grocery_store),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: TextFormField(
                  initialValue: _formData['Descrição'],
                  onSaved: (value) => _formData['Descrição'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    prefixIcon: Icon(Icons.format_align_left),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 35),
                child: TextFormField(
                  initialValue: _formData['Imagem1'],
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Informe a imagem do produto';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['Imagem1'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Imagem 1",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 35),
                child: TextFormField(
                  initialValue: _formData['Imagem2'],
                  onSaved: (value) => _formData['Imagem2'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Imagem 2",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 35),
                child: TextFormField(
                  initialValue: _formData['Imagem3'],
                  onSaved: (value) => _formData['Imagem3'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Imagem 3",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 35),
                child: TextFormField(
                  initialValue: _formData['Imagem4'],
                  onSaved: (value) => _formData['Imagem4'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Imagem 4",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 35),
                child: TextFormField(
                  initialValue: _formData['Imagem5'],
                  onSaved: (value) => _formData['Imagem5'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Imagem 5",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: 190,
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _form.currentState?.validate();
                    if (isValid!) {
                      _form.currentState!.save();
                      salvarProduto();
                    }
                  },
                  child: const Text(
                    'Confirma',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void salvarProduto() async {
    widget.produto!.nome = _formData['Produto'];
    widget.produto!.preco = _formData['Preço'];
    widget.produto!.estoque = _formData['Estoque'];
    widget.produto!.desc = _formData['Descrição'];
    widget.produto!.img1 = _formData['Imagem1'];
    widget.produto!.img2 = _formData['Imagem2'];
    widget.produto!.img3 = _formData['Imagem3'];
    widget.produto!.img4 = _formData['Imagem4'];
    widget.produto!.img5 = _formData['Imagem5'];

    if (widget.produto!.id == null) {
      Provider.of<ProdutosDatabaseController>(context, listen: false)
          .insertProduto(widget.produto!);
    } else {
      Provider.of<ProdutosDatabaseController>(context, listen: false)
          .updateProdutos(widget.produto!);
    }
    Navigator.pop(context, widget.produto!);
  }
}
