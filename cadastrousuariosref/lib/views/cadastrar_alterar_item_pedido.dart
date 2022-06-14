// ignore_for_file: unnecessary_null_comparison
import 'package:cadastrousuariosref/controller/item_pedido_database_controller.dart';
import 'package:cadastrousuariosref/controller/produtos_database_controller.dart';
import 'package:cadastrousuariosref/models/item_pedido_model.dart';
import 'package:cadastrousuariosref/models/produtos_model.dart';
import 'package:cadastrousuariosref/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/pedidos_database_controller.dart';

class CadastrarAlterarItemPedido extends StatefulWidget {
  const CadastrarAlterarItemPedido({Key? key}) : super(key: key);

  @override
  State<CadastrarAlterarItemPedido> createState() =>
      _CadastrarAlterarItemPedidoState();
}

class _CadastrarAlterarItemPedidoState
    extends State<CadastrarAlterarItemPedido> {
  final _form = GlobalKey<FormState>();

  final Map<dynamic, String> _formData = {};

  TextEditingController valorUniController = TextEditingController();

  TextEditingController totalController = TextEditingController();

  TextEditingController quantidadeController = TextEditingController();

  TextEditingController idController = TextEditingController();

  TextEditingController nomeProdutoController = TextEditingController();

  late ProdutosDatabaseController db;

  late int pedidoId;

  late ItemPedidoModel item;

  int sequencia = 1;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    db = Provider.of<ProdutosDatabaseController>(context, listen: false);

    final ultimoPedId = await getPedidoId(context);

    quantidadeController.text = '1';

    item = ItemPedidoModel(idPed: pedidoId = ultimoPedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar item'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () async {
              final ultimoPedId = await getPedidoId(context);
              final isValid = _form.currentState?.validate();
              if (isValid!) {
                _form.currentState!.save();
                await salvarItem();
                Navigator.of(context).pop();
              }
              item = ItemPedidoModel(id: null, idPed: pedidoId = ultimoPedId);

              sequencia++;
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 5,
                ),
                child: TextFormField(
                  controller: idController,
                  onChanged: (value) {
                    if (value != '' &&
                        value != null &&
                        quantidadeController.text != '' &&
                        quantidadeController.text != null) {
                      calcularValor(idController.text,
                          int.tryParse(quantidadeController.text)!, context);
                    } else {
                      valorUniController.text = '';
                      totalController.text = '';
                      nomeProdutoController.text = '';
                    }
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Informe o ID do produto';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['idProduto'] = value!,
                  decoration: InputDecoration(
                    labelText: "ID do produto: ",
                    prefixIcon: const Icon(Icons.select_all),
                    suffixIcon: IconButton(
                      onPressed: () {
                        localizarProduto();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: nomeProdutoController,
                  onSaved: (value) => _formData['nomeProduto'] = value!,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Nome do produto: ",
                    prefixIcon: Icon(Icons.devices_other),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: quantidadeController,
                  onChanged: (value) {
                    if (value != '' &&
                        value != null &&
                        idController.text != '' &&
                        idController.text != null) {
                      calcularValor(idController.text,
                          int.tryParse(quantidadeController.text)!, context);
                    } else {
                      valorUniController.text = '';
                      totalController.text = '';
                    }
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Informe a quantidade vendida';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['quantidadeVendida'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Quantidade vendida: ",
                    prefixIcon: Icon(Icons.filter_1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: valorUniController,
                  enabled: false,
                  onSaved: (value) => _formData['valorUni'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Valor unitario: ",
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: totalController,
                  enabled: false,
                  onSaved: (value) => _formData['total'] = value!,
                  decoration: const InputDecoration(
                    labelText: "Valor total: ",
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getPedidoId(BuildContext context) async {
    final lastUpdatePedido =
        await Provider.of<PedidosDatabaseController>(context, listen: false)
            .getLastUpdatePedido();
    return lastUpdatePedido;
  }

  calcularValor(String id, int quantVendida, BuildContext context) async {
    await db.getProdutoById(id);

    if (db.produtos.isNotEmpty) {
      final produto = db.produtos[0];

      totalController.text = '';
      valorUniController.text = '';

      valorUniController.text = produto.preco!;

      nomeProdutoController.text = produto.nome!;

      double total = int.tryParse(quantidadeController.text)! *
          double.tryParse(produto.preco!)!;

      totalController.text = total.toString();
    }
  }

  salvarItem() async {
    item.idProd = int.tryParse(_formData['idProduto']!);
    item.quantidadeVendida = int.tryParse(_formData['quantidadeVendida']!)!;
    item.sequencia = sequencia;
    item.valorUni = double.tryParse(_formData['valorUni']!)!;
    item.valorTotal = double.tryParse(_formData['total']!)!;
    item.nomeProduto = _formData['nomeProduto'];
    if (item.id == null) {
      await Provider.of<ItemPedidoDatabaseController>(context, listen: false)
          .insertPedidoItem(item);
    } else {
      await Provider.of<ItemPedidoDatabaseController>(context, listen: false)
          .updatePedidoItem(item);
    }
  }

  void localizarProduto() {
    Navigator.of(context).pushNamed(AppRoutes.listaProdutos).then((value) {
      idController.text = (value as ProdutosModel).id!;
      valorUniController.text = value.preco!;
      nomeProdutoController.text = value.nome!;
      double total = int.tryParse(quantidadeController.text)! *
          double.tryParse(value.preco!)!;

      totalController.text = total.toString();
    });
  }
}
