import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:cadastrousuariosref/views/item_info.dart';
import 'package:cadastrousuariosref/views/pedidos_Info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/item_pedido_database_controller.dart';

// ignore: must_be_immutable
class SliderPedidosItensInfo extends StatefulWidget {
  SliderPedidosItensInfo(this.pedido, {Key? key}) : super(key: key);

  PedidoModel pedido;

  @override
  State<SliderPedidosItensInfo> createState() => _SliderPedidosItensInfoState();
}

class _SliderPedidosItensInfoState extends State<SliderPedidosItensInfo> {
  int paginaAtual = 0;
  late PageController paginaController;

  @override
  void initState() {
    super.initState();
    paginaController = PageController(initialPage: paginaAtual);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Provider.of<ItemPedidoDatabaseController>(context, listen: false)
        .getItemByPedidoId(widget.pedido.id!);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: paginaController,
        children: [PedidosInfo(widget.pedido), const ItemInfo()],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel), label: 'Pedido'),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'itens'),
        ],
        onTap: (pagina) {
          paginaController.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
          );
        },
      ),
    );
  }
}
