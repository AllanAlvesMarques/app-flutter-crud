import 'package:cadastrousuariosref/controller/pedidos_database_controller.dart';
import 'package:cadastrousuariosref/models/contato_model.dart';
import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/dialog_status_pedido.dart';
import '../routes/app_routes.dart';

// ignore: must_be_immutable
class CadastrarAlterarPedido extends StatefulWidget {
  CadastrarAlterarPedido(
      {required this.pedido, Key? key, required this.formKey})
      : super(key: key);
  PedidoModel pedido;
  final GlobalKey<FormState> formKey;

  @override
  State<CadastrarAlterarPedido> createState() => _CadastrarAlterarPedidoState();
}

class _CadastrarAlterarPedidoState extends State<CadastrarAlterarPedido> {
  int? idCli;

  TextEditingController totalController = TextEditingController();
  TextEditingController subtotalController = TextEditingController();
  TextEditingController cliNomeController = TextEditingController();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.pedido.id != null) {
      totalController.text = widget.pedido.total.toString();
      subtotalController.text = widget.pedido.subTotal.toString();
      cliNomeController.text = widget.pedido.cliNome!;
      idCli = widget.pedido.cliId;
    } else {
      totalController.text = '0';
      subtotalController.text = '0';
      widget.pedido.desconto = 0;
    }
    salvarPedido();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final pedidoFinalizado = await showWarning(context);

        if (pedidoFinalizado!) {
          widget.pedido.status = 'Finalizado';
        } else {
          widget.pedido.status = 'Cancelado';
        }

        widget.formKey.currentState!.save();

        if (widget.pedido.id == null) {
          await Provider.of<PedidosDatabaseController>(context, listen: false)
              .insertPedido(widget.pedido);
        } else {
          await Provider.of<PedidosDatabaseController>(context, listen: false)
              .updatePedido(widget.pedido);
        }

        const shouldPop = true;

        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fazer pedido'),
          centerTitle: true,
        ),
        body: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: TextFormField(
                    controller: cliNomeController,
                    validator: (value) {
                      if (value == null || value == '' || idCli == null) {
                        return 'Informe o cliente';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.pedido.cliNome = value!;
                      widget.pedido.cliId = idCli;
                    },
                    onChanged: (value) {
                      widget.formKey.currentState?.validate();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cliente: ",
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          localizaContato();
                        },
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
                    initialValue: widget.pedido.obs,
                    onSaved: (value) => widget.pedido.obs = value!,
                    onChanged: (value) {
                      widget.formKey.currentState?.validate();
                    },
                    decoration: const InputDecoration(
                      labelText: "Observação: ",
                      prefixIcon: Icon(Icons.content_paste),
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
                    keyboardType: TextInputType.number,
                    initialValue: widget.pedido.desconto.toString(),
                    onSaved: (value) => widget.pedido.desconto =
                        value == '' || value == null
                            ? 0
                            : double.tryParse(value)!,
                    decoration: const InputDecoration(
                      labelText: "Desconto: ",
                      prefixIcon: Icon(Icons.local_offer),
                      suffix: Padding(
                        padding: EdgeInsets.only(right: 13),
                        child: Text('%', style: TextStyle(fontSize: 18)),
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
                    controller: totalController,
                    enabled: false,
                    onSaved: (value) =>
                        widget.pedido.total = double.tryParse(value!)!,
                    decoration: const InputDecoration(
                      labelText: "Total: ",
                      prefixIcon: Icon(Icons.payment),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 50,
                  ),
                  child: TextFormField(
                    controller: subtotalController,
                    enabled: false,
                    onSaved: (value) =>
                        widget.pedido.subTotal = double.tryParse(value!)!,
                    decoration: const InputDecoration(
                      labelText: "Subtotal: ",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  localizaContato() {
    Navigator.of(context).pushNamed(AppRoutes.listaContatos).then((value) {
      idCli = (value as ContatoModel).id!;
      cliNomeController.text = value.nome!;
    });
  }

  salvarPedido() async {
    if (widget.pedido.id == null) {
      widget.pedido.data =
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
      await Provider.of<PedidosDatabaseController>(context, listen: false)
          .insertPedido(widget.pedido);
    }
  }
}
