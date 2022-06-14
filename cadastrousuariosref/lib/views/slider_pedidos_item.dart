import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:cadastrousuariosref/views/cadastrar_alterar_pedido.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/total_pedido_bottom_widget.dart';
import '../controller/item_pedido_database_controller.dart';
import '../controller/pedidos_database_controller.dart';
import 'lista_itens_pedido.dart';

// ignore: must_be_immutable
class SliderPedidosItem extends StatefulWidget {
  SliderPedidosItem(this.editarPedido, {Key? key}) : super(key: key);

  PedidoModel? editarPedido;

  @override
  State<SliderPedidosItem> createState() => _SliderPedidosItemState();
}

class _SliderPedidosItemState extends State<SliderPedidosItem> {
  int paginaAtual = 0;
  late PageController paginaController;
  late ItemPedidoDatabaseController itemDB;
  PedidoModel pedido = PedidoModel();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    itemDB = Provider.of<ItemPedidoDatabaseController>(context, listen: false);
    paginaController = PageController(initialPage: paginaAtual);
    if (widget.editarPedido != null) {
      pedido = widget.editarPedido!;
    }
  }

  changePage(pagina) {
    final isValid = _form.currentState?.validate();

    if (isValid!) {
      _form.currentState!.save();

      savePedido();

      calcularTotal(pedido.desconto.toString());
      setState(() {
        TotalPedidoBottomWidget;

        paginaAtual = pagina;
      });
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return const InformeClienteDialog();
          });
      paginaController.jumpToPage(0);
    }
  }

  savePedido() async {
    if (pedido.id != null) {
      await Provider.of<PedidosDatabaseController>(context, listen: false)
          .updatePedido(pedido);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: paginaController,
        children: [
          CadastrarAlterarPedido(
            pedido: pedido,
            formKey: _form,
          ),
          ListaItensPedido(pedido, calcularTotal: (calcularTotal)),
        ],
        onPageChanged: changePage,
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

  calcularTotal(String desconto) {
    pedido.subTotal = 0;
    pedido.total = 0;

    for (var i = 0; i < itemDB.itens.length; i++) {
      pedido.total = pedido.total +
          double.tryParse(itemDB.itens[i].valorTotal.toString())!;
    }

    double porcentagem = double.tryParse(desconto)! / 100;

    pedido.subTotal = pedido.total - (pedido.total * porcentagem);
  }
}

class InformeClienteDialog extends StatelessWidget {
  const InformeClienteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Informe o cliente'),
      content: const Text('O campo "cliente" não foi informado'),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
