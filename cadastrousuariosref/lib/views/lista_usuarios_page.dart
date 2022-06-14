import 'package:cadastrousuariosref/components/usuario_logado_sistema_bottom_widget.dart';
import 'package:cadastrousuariosref/models/usuario_model.dart';
import 'package:cadastrousuariosref/views/cadatrar_alterar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/usuarios_database_controller.dart';

class ListaUsuariosPage extends StatefulWidget {
  const ListaUsuariosPage({Key? key}) : super(key: key);

  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  late final UsuariosDatabaseController db;

  @override
  void initState() {
    super.initState();
    db = Provider.of<UsuariosDatabaseController>(context, listen: false);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await db.getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      floatingActionButton: db.usuarioLogado.permitirCadastrar
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CadastrarAlterarUsuario(
                            null, 'Cadastrar Usuário');
                      },
                    ),
                  ),
              child: const Icon(Icons.person_add))
          : null,
      body: usuariosPage(),
    );
  }

  Widget usuariosPage() {
    return db.usuarioLogado.permitirVer
        ? Consumer<UsuariosDatabaseController>(
            builder: (context, controller, child) {
              return ListView.builder(
                itemCount: controller.usuarios.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listaUsuarios(context, controller.usuarios[index]);
                },
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.warning,
                  size: 80,
                  color: Colors.red,
                ),
                Text(
                  'Você não tem permição para visualizar os usuários',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          );
  }

  _listaUsuarios(BuildContext context, UsuarioModel usuario) {
    return ListTile(
      title: Text(usuario.nome!),
      leading: const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
        backgroundImage: AssetImage('assets/images/person_icon.png'),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            verificaPermicoes('alterar', usuario),
            verificaPermicoes('deletar', usuario),
          ],
        ),
      ),
    );
  }

  Widget verificaPermicoes(String tipoPermicao, UsuarioModel usuario) {
    late Widget buttom;

    switch (tipoPermicao) {
      case 'alterar':
        db.usuarioLogado.permitirAlterar
            ? buttom = IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CadastrarAlterarUsuario(
                            usuario, 'Edite o usuário');
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.create),
              )
            : buttom = Container();
        break;

      case 'deletar':
        db.usuarioLogado.permitirDeletar
            ? buttom = IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Deseja deletar este Usuário?'),
                        content: const Text('Este Usuário será apagado'),
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
                              await db.deleteUsuario(usuario.id!, usuario);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : buttom = Container();
        break;
    }
    return buttom;
  }
}
