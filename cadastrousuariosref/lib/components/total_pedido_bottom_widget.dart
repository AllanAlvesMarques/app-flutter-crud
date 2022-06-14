import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TotalPedidoBottomWidget extends StatefulWidget {
  TotalPedidoBottomWidget(this.pedido, {Key? key}) : super(key: key);

  PedidoModel pedido;

  @override
  State<TotalPedidoBottomWidget> createState() =>
      _TotalPedidoBottomWidgetState();
}

class _TotalPedidoBottomWidgetState extends State<TotalPedidoBottomWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.indigo,
      ),
      height: 70,
      width: double.infinity,
      //color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Bruto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'R\$ ${widget.pedido.total}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Total',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'R\$ ${widget.pedido.subTotal}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
