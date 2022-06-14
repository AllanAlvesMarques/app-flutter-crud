import 'package:cadastrousuariosref/components/card_itens.dart';
import 'package:cadastrousuariosref/controller/item_pedido_database_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ItemInfo extends StatefulWidget {
  const ItemInfo({Key? key}) : super(key: key);

  @override
  State<ItemInfo> createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  double containerHeight = 50;
  bool showDesc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itens info'),
        centerTitle: true,
      ),
      body: Consumer<ItemPedidoDatabaseController>(
        builder: ((context, controller, child) {
          return ListView.builder(
            itemCount: controller.itens.length,
            itemBuilder: (BuildContext context, int index) {
              return CardItens(controller.itens[index]);
            },
          );
        }),
      ),
    );
  }
}
