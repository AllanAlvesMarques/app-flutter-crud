import 'package:cadastrousuariosref/controller/pedidos_database_controller.dart';
import 'package:cadastrousuariosref/views/slider_pedidos_itens_info.dart';
import 'package:cadastrousuariosref/views/slider_pedidos_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaPedidosPage extends StatefulWidget {
  const ListaPedidosPage({Key? key}) : super(key: key);

  @override
  State<ListaPedidosPage> createState() => _ListaPedidosPageState();
}

class _ListaPedidosPageState extends State<ListaPedidosPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PedidosDatabaseController>(context, listen: false).getPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SliderPedidosItem(null);
            },
          ),
        ),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Pedidos'), centerTitle: true),
      body: Consumer<PedidosDatabaseController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.pedidolist.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(controller.pedidolist[index].id!.toString()),
                subtitle: Text(controller.pedidolist[index].data!),
                leading: const Icon(Icons.shopping_cart, size: 35),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SliderPedidosItensInfo(
                          controller.pedidolist[index]);
                    },
                  ),
                ),
                trailing: controller.pedidolist[index].status == 'Cancelado'
                    ? const Icon(Icons.done, color: Colors.blue)
                    : const Icon(Icons.done_all, color: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
