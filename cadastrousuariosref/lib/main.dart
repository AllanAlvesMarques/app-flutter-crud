import 'package:cadastrousuariosref/controller/item_pedido_database_controller.dart';
import 'package:cadastrousuariosref/controller/pedidos_database_controller.dart';
import 'package:cadastrousuariosref/controller/produtos_database_controller.dart';
import 'package:cadastrousuariosref/views/cadastrar_alterar_contatos.dart';
import 'package:cadastrousuariosref/views/home_page.dart';
import 'package:cadastrousuariosref/views/lista_contatos_page.dart';
import 'package:cadastrousuariosref/views/lista_produtos_page.dart';
import 'package:cadastrousuariosref/views/login_page.dart';
import 'package:cadastrousuariosref/views/lista_usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/contato_database_controller.dart';
import 'controller/usuarios_database_controller.dart';
import 'routes/app_routes.dart';
import 'views/lista_pedidos_page.dart';

void main() {
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContatoDatabaseController>(
            create: (context) => ContatoDatabaseController()),
        ChangeNotifierProvider<UsuariosDatabaseController>(
            create: (context) => UsuariosDatabaseController()),
        ChangeNotifierProvider<ProdutosDatabaseController>(
            create: (context) => ProdutosDatabaseController()),
        ChangeNotifierProvider<PedidosDatabaseController>(
            create: (context) => PedidosDatabaseController()),
        ChangeNotifierProvider<ItemPedidoDatabaseController>(
            create: (context) => ItemPedidoDatabaseController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.loginPage: (_) => const LoginPage(),
          AppRoutes.homePage: (_) => HomePage(),
          AppRoutes.usuariosPage: (_) => const ListaUsuariosPage(),
          AppRoutes.listaContatos: (_) => const ListaContatosPage(),
          AppRoutes.cadastrarAlterar: (_) => const CadastrarAlterarContatos(),
          AppRoutes.listaProdutos: (_) => const ListarProdutos(),
          AppRoutes.listaPedidos: (_) => const ListaPedidosPage(),
        },
      ),
    );
  }
}
