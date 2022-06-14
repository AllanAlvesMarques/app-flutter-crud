import 'package:cadastrousuariosref/components/usuario_logado_sistema_bottom_widget.dart';
import 'package:flutter/material.dart';
import '../controller/usuario_logado_controller.dart';
import '../routes/app_routes.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  UsuarioLogadoController usuarioLogadoController = UsuarioLogadoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
      appBar: AppBar(
        title: const Text('ContatosApp'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 50),
                child: SizedBox(
                  height: 110,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamed(AppRoutes.usuariosPage);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person),
                        Text(
                          'Usuários',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 110,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.listaContatos);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.contacts),
                        Text(
                          'Contatos',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 50),
                child: SizedBox(
                  height: 110,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.listaProdutos);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.devices),
                        Text(
                          'Produtos',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 110,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.listaPedidos);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.local_grocery_store),
                        Text(
                          'Pedidos',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
