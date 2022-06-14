import 'package:cadastrousuariosref/views/slider_pedidos_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/item_pedido_database_controller.dart';
import '../controller/pedidos_database_controller.dart';
import '../models/pedido_model.dart';

// ignore: must_be_immutable
class PedidosInfo extends StatelessWidget {
  PedidosInfo(this.pedido, {Key? key}) : super(key: key);

  PedidoModel pedido;
  // final _form = GlobalKey<FormState>();

  MaterialColor blueColor = Colors.indigo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(
        title: const Text('Pedido Info'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SliderPedidosItem(pedido);
                  },
                ),
              ).then((value) => Navigator.pop(context));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => dialogDeletePedido(context)).then(
                (value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 190.0,
                  height: 190.0,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 140,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    infoPedidoLayout('Id'),
                    infoPedidoLayout('data'),
                    infoPedidoLayout('CliId'),
                    infoPedidoLayout('obs'),
                    infoPedidoLayout('status'),
                    infoPedidoLayout('desconto'),
                    infoPedidoLayout('total'),
                    infoPedidoLayout('sub'),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogDeletePedido(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir pedido'),
      content: const Text('Você tem certeza que deseja excluir este pedido?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () async {
            await Provider.of<ItemPedidoDatabaseController>(context,
                    listen: false)
                .deleteAllItensOfPedido(pedido.id!);
            await Provider.of<PedidosDatabaseController>(context, listen: false)
                .deletePedido(pedido.id!, pedido);
            Navigator.pop(context, true);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }

  infoPedidoLayout(String nomeDoDado) {
    var tipoInfo = const Text('');
    var icone = const Icon(Icons.abc);

    switch (nomeDoDado) {
      case 'Id':
        tipoInfo = Text(pedido.id.toString());

        icone = Icon(
          Icons.select_all,
          color: blueColor,
        );
        break;

      case 'data':
        tipoInfo = Text(pedido.data.toString());

        icone = Icon(
          Icons.insert_invitation,
          color: blueColor,
        );
        break;

      case 'CliId':
        tipoInfo = Text(pedido.cliNome.toString());

        icone = Icon(
          Icons.person,
          color: blueColor,
        );
        break;

      case 'obs':
        tipoInfo = Text(pedido.obs.toString());

        icone = Icon(
          Icons.content_paste,
          color: blueColor,
        );
        break;

      case 'status':
        tipoInfo = Text(pedido.status.toString());

        icone = Icon(
          Icons.assessment,
          color: blueColor,
        );
        break;

      case 'desconto':
        tipoInfo = Text('${pedido.desconto.toString()} %');

        icone = Icon(
          Icons.local_offer,
          color: blueColor,
        );
        break;

      case 'total':
        tipoInfo = Text(pedido.total.toString());

        icone = Icon(
          Icons.payment,
          color: blueColor,
        );
        break;

      case 'sub':
        tipoInfo = Text(pedido.subTotal.toString());

        icone = Icon(
          Icons.attach_money,
          color: blueColor,
        );
        break;
    }

    return Card(
      elevation: 0.0,
      color: const Color.fromARGB(0, 255, 16, 16),
      child: ListTile(leading: icone, title: tipoInfo),
    );
  }
}
