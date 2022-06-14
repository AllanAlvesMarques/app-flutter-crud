import 'package:cadastrousuariosref/controller/usuarios_database_controller.dart';
import 'package:cadastrousuariosref/models/usuario_model.dart';
import 'package:cadastrousuariosref/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/usuario_logado_controller.dart';

import 'cadatrar_alterar_usuario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UsuarioLogadoController usuarioLogadoController = UsuarioLogadoController();

  final _form = GlobalKey<FormState>();

  bool visible = false;
  late UsuariosDatabaseController controller;
  List<UsuarioModel> listaUsuarios = [];

  UsuarioModel? valueChoose;

  late TextEditingController senhaController;

  bool permanecerLogado = false;

  @override
  void initState() {
    super.initState();
    controller = UsuariosDatabaseController();
    senhaController = TextEditingController();
    verificaUsuarioLogado();
  }

  verificaUsuarioLogado() async {
    await Provider.of<UsuariosDatabaseController>(context, listen: false)
        .carregarUsuarioSalvo();
    final user = Provider.of<UsuariosDatabaseController>(context, listen: false)
        .usuarioLogado;

    if (user.id != null) {
      Navigator.of(context).pushNamed(AppRoutes.homePage).then(
        (_) {
          atualizarListaUsuarios();
        },
      );
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    atualizarListaUsuarios();
  }

  void atualizarListaUsuarios() async {
    await controller.getUsuarios();

    setState(() {
      listaUsuarios = controller.usuarios;
      valueChoose = null;
      senhaController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  DropdownButtonFormField<UsuarioModel>(
                    hint: const Text('Selecione a conta'),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um usuário';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                    ),
                    isExpanded: true,
                    value: valueChoose,
                    onChanged: (value) {
                      setState(
                        () {
                          valueChoose = value;
                        },
                      );
                    },
                    items: listaUsuarios.map(
                      (e) {
                        return DropdownMenuItem<UsuarioModel>(
                          value: e,
                          child: Text(e.login ?? ''),
                        );
                      },
                    ).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0, bottom: 16),
                    child: TextFormField(
                      controller: senhaController,
                      obscureText: !visible,
                      validator: (value) {
                        if (value == '' || value == null) {
                          return 'Digite sua senha';
                        }
                        if (valueChoose!.senha == value) {
                          return null;
                        } else {
                          return 'Digite a senha correta';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Senha:",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                visible = !visible;
                              },
                            );
                          },
                          icon: Icon(visible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Permanecer logado:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: permanecerLogado,
                        onChanged: (value) {
                          setState(
                            () {
                              permanecerLogado = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      height: 50,
                      width: 190,
                      child: Consumer<UsuariosDatabaseController>(
                        builder: (context, controller, child) {
                          return listaUsuarios.isNotEmpty
                              ? ElevatedButton(
                                  onPressed: () {
                                    final isValid =
                                        _form.currentState?.validate();

                                    if (isValid!) {
                                      entranoapp();
                                    }
                                  },
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CadastrarAlterarUsuario(
                                              UsuarioModel(
                                                  id: null,
                                                  nome: '',
                                                  login: '',
                                                  senha: '',
                                                  permitirAlterar: false,
                                                  permitirCadastrar: false,
                                                  permitirDeletar: false,
                                                  permitirVer: false),
                                              'Cadastre-se');
                                        },
                                      ),
                                    ).then((value) => atualizarListaUsuarios());
                                  },
                                  child: const Text(
                                    'Cadastrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void entranoapp() async {
    if (permanecerLogado == true) {
      usuarioLogadoController.saveUsuarioLogado(valueChoose!);

      Provider.of<UsuariosDatabaseController>(context, listen: false)
          .usuarioLogado = valueChoose!;

      Navigator.of(context).pushNamed(AppRoutes.homePage).then(
        (_) {
          atualizarListaUsuarios();
        },
      );
    } else {
      Provider.of<UsuariosDatabaseController>(context, listen: false)
          .usuarioLogado = valueChoose!;

      usuarioLogadoController.removeUsuarioLogado();

      Navigator.of(context).pushNamed(AppRoutes.homePage).then(
        (_) {
          atualizarListaUsuarios();
        },
      );
    }
  }
}
