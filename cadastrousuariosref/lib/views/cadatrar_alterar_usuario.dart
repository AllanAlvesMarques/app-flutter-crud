import 'package:cadastrousuariosref/controller/usuarios_database_controller.dart';
import 'package:cadastrousuariosref/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CadastrarAlterarUsuario extends StatefulWidget {
  CadastrarAlterarUsuario(this.usuario, this.title, {Key? key})
      : super(key: key);

  UsuarioModel? usuario;
  String title;

  @override
  State<CadastrarAlterarUsuario> createState() =>
      _CadastrarAlterarUsuarioState();
}

class _CadastrarAlterarUsuarioState extends State<CadastrarAlterarUsuario> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  late String? senha1;

  late String? senha2;

  bool visible = false;

  bool permitirVer = false;
  bool permitirCadastrar = false;
  bool permitirAlterar = false;
  bool permitirDeletar = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.usuario != null) {
      _formData['nome'] = widget.usuario!.nome!;
      _formData['login'] = widget.usuario!.login!;
      _formData['senha'] = widget.usuario!.senha!;
    } else {
      widget.usuario = UsuarioModel(
          permitirAlterar: false,
          permitirCadastrar: false,
          permitirDeletar: false,
          permitirVer: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 28, left: 16, right: 16, bottom: 26),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nome:",
                        prefixIcon: Icon(Icons.person),
                      ),
                      initialValue: _formData['nome'],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Este campo é obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['nome'] = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16, right: 16, bottom: 26),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Login:",
                        prefixIcon: Icon(Icons.account_circle_rounded),
                      ),
                      initialValue: _formData['login'],
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Este campo é obrigatorio';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['login'] = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16, right: 16, bottom: 26),
                    child: TextFormField(
                      obscureText: !visible,
                      decoration: InputDecoration(
                        labelText: "Senha:",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          icon: Icon(visible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      initialValue: _formData['senha'],
                      validator: (value) {
                        senha1 = value;
                        if (value == null || value == '') {
                          return 'Crie uma senha';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['senha'] = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16, right: 16, bottom: 26),
                    child: TextFormField(
                      obscureText: !visible,
                      decoration: InputDecoration(
                        labelText: "Confirme a senha:",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          icon: Icon(visible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      initialValue: _formData['senha'],
                      validator: (value) {
                        senha2 = value;
                        if (senha1 == senha2) {
                          return null;
                        } else {
                          return 'As senhas devem ser iguais';
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: permitirVer,
                              onChanged: (bool? value) {
                                setState(() {
                                  permitirVer = value!;
                                });
                              },
                            ),
                            const Text(' VER '),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Checkbox(
                              value: permitirCadastrar,
                              onChanged: (bool? value) {
                                setState(() {
                                  permitirCadastrar = value!;
                                });
                              },
                            ),
                            const Text(' CADASTRAR '),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Checkbox(
                              value: permitirAlterar,
                              onChanged: (bool? value) {
                                setState(() {
                                  permitirAlterar = value!;
                                });
                              },
                            ),
                            const Text(' ALTERAR '),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Checkbox(
                              value: permitirDeletar,
                              onChanged: (bool? value) {
                                setState(() {
                                  permitirDeletar = value!;
                                });
                              },
                            ),
                            const Text(' DELETAR '),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    width: 190,
                    child: ElevatedButton(
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        final isValid = _form.currentState?.validate();
                        if (isValid!) {
                          _form.currentState!.save();
                          salvaUsuario(context, widget.usuario!);
                        }
                      },
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

  Future<void> salvaUsuario(BuildContext context, UsuarioModel usuario) async {
    usuario.login = _formData['login'];
    usuario.nome = _formData['nome'];
    usuario.senha = _formData['senha'];
    usuario.permitirVer = permitirVer;
    usuario.permitirCadastrar = permitirCadastrar;
    usuario.permitirAlterar = permitirAlterar;
    usuario.permitirDeletar = permitirDeletar;

    if (usuario.id == null) {
      await Provider.of<UsuariosDatabaseController>(context, listen: false)
          .insertUsuario(usuario);
    } else {
      await Provider.of<UsuariosDatabaseController>(context, listen: false)
          .updateUsuario(usuario);
    }
    Navigator.pop(context, usuario);
  }
}
