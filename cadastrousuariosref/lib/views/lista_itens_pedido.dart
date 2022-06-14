import 'package:cadastrousuariosref/models/item_pedido_model.dart';
import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:cadastrousuariosref/views/cadastrar_alterar_item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/dialog_status_pedido.dart';
import '../components/total_pedido_bottom_widget.dart';
import '../controller/item_pedido_database_controller.dart';
import '../controller/pedidos_database_controller.dart';

// ignore: must_be_immutable
class ListaItensPedido extends StatefulWidget {
  ListaItensPedido(this.pedido, {Key? key, required this.calcularTotal})
      : super(key: key);

  PedidoModel pedido;
  void Function(String desconto) calcularTotal;

  @override
  State<ListaItensPedido> createState() => _ListaItensPedidoState();
}

class _ListaItensPedidoState extends State<ListaItensPedido> {
  late int pedidoId;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Provider.of<ItemPedidoDatabaseController>(context, listen: false)
        .getItemByPedidoId(widget.pedido.id!);
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

        await Provider.of<PedidosDatabaseController>(context, listen: false)
            .updatePedido(widget.pedido);

        const shouldPop = true;

        return shouldPop;
      },
      child: Scaffold(
        bottomSheet: TotalPedidoBottomWidget(widget.pedido),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CadastrarAlterarItemPedido();
                },
              ),
            ).then((value) {
              widget.calcularTotal(widget.pedido.desconto.toString());
              setState(() {
                TotalPedidoBottomWidget;
              });
            });
          },
        ),
        appBar: AppBar(
          title: const Text('Itens'),
          centerTitle: true,
        ),
        body: Consumer<ItemPedidoDatabaseController>(
          builder: ((context, controller, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 65),
              child: ListView.builder(
                itemCount:
                    controller.itens.isEmpty ? 0 : controller.itens.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(controller.itens[index].nomeProduto!),
                      subtitle: Text(
                          controller.itens[index].quantidadeVendida.toString()),
                      leading: const Icon(Icons.shopping_cart, size: 36),
                      trailing:
                          Text('R\$ ${controller.itens[index].valorTotal}'),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteDialog(controller.itens[index]);
                          },
                        ).then((value) {
                          widget
                              .calcularTotal(widget.pedido.desconto.toString());
                          setState(() {
                            TotalPedidoBottomWidget;
                          });
                        });
                      });
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog(this.item, {Key? key}) : super(key: key);

  final ItemPedidoModel item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deseja deletar este Item'),
      content: const Text('Este Item será apagado'),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Deletar'),
          onPressed: () async {
            await Provider.of<ItemPedidoDatabaseController>(context,
                    listen: false)
                .deletePedidoItem(item.id!, item);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
