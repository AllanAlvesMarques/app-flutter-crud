import '../http/http_cep.dart';
import 'package:cadastrousuariosref/models/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/contato_database_controller.dart';

class CadastrarAlterarContatos extends StatefulWidget {
  const CadastrarAlterarContatos({Key? key}) : super(key: key);

  @override
  State<CadastrarAlterarContatos> createState() =>
      _CadastrarAlterarContatosState();
}

class _CadastrarAlterarContatosState extends State<CadastrarAlterarContatos> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  late TextEditingController controllerTel;

  late TextEditingController controllerCell;

  late TextEditingController controllerEmail;

  late TextEditingController controllerRua;

  late TextEditingController controllerBairro;

  late TextEditingController controllerCidade;

  late TextEditingController controllerComplemento;

  late TextEditingController controllerCep;

  late ContatoModel contato;

  late int? cep;

  bool pesquisandoCep = false;

  String statusBuscaCep = '';

  @override
  void initState() {
    super.initState();
    controllerTel = TextEditingController();
    controllerEmail = TextEditingController();
    controllerCell = TextEditingController();
    controllerRua = TextEditingController();
    controllerBairro = TextEditingController();
    controllerCidade = TextEditingController();
    controllerComplemento = TextEditingController();
    controllerCep = TextEditingController();
    contato = ContatoModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if ((ModalRoute.of(context)?.settings.arguments as ContatoModel?) != null) {
      contato = ModalRoute.of(context)?.settings.arguments as ContatoModel;
      _formData['nome'] = contato.nome!;
      _formData['telefone'] = contato.telefone!;
      _formData['celular'] = contato.celular!;
      _formData['email'] = contato.email!;
      _formData['foto'] = contato.foto!;

      controllerTel.text = contato.telefone!;

      controllerCell.text = contato.celular!;

      controllerEmail.text = contato.email!;
      controllerRua.text = contato.endereco!;
      controllerBairro.text = contato.bairro!;
      controllerCidade.text = contato.cidade!;
      controllerCep.text = contato.cep!.toString();
      controllerComplemento.text = contato.complemento!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre/Altere'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState?.validate();

              if (isValid!) {
                _form.currentState!.save();
                salvarContato();
              }
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: _formData['nome'],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome é inválido';
                    }

                    if (value.trim().length < 3) {
                      return 'Nome muito curto.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome:',
                  ),
                  onSaved: (value) => _formData['nome'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerTel,
                  validator: (value) {
                    if (controllerEmail.text != '') {
                      return null;
                    }

                    if (value == null || value.trim().isEmpty) {
                      return 'Telefone invalido, informe o telefone ou o E-mail em seus campos';
                    }

                    if (value.trim().length < 13 || value.trim().length > 14) {
                      return 'Digite um telefone valido, ex: (xx) xxxx-xxxx';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Telefone:',
                  ),
                  onSaved: (value) => _formData['telefone'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerCell,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Celular:",
                  ),
                  onSaved: (value) => _formData['celular'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerEmail,
                  validator: (value) {
                    if (controllerTel.text != '') {
                      return null;
                    }

                    if (value == null || value.trim().isEmpty) {
                      return 'E-mail invalido, informe o E-mail ou o telefone em seus campos';
                    }

                    if (value.trim().contains('@') == false &&
                        value.trim().length < 2) {
                      return 'Digite um E-mail valido';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail:',
                  ),
                  onSaved: (value) => _formData['email'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  maxLength: 8,
                  controller: controllerCep,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value == '') {
                      return null;
                    }
                    if (value.trim().length < 8 || statusBuscaCep == 'F') {
                      return 'Cep Inválido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Visibility(
                      visible: !pesquisandoCep,
                      replacement: const SizedBox(
                          height: 50,
                          width: 60,
                          child: Center(child: CircularProgressIndicator())),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: localizarCep,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Cep:",
                  ),
                  onSaved: (value) => saveCep(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerRua,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Rua:",
                  ),
                  onSaved: (value) => _formData['rua'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerBairro,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Bairro:",
                  ),
                  onSaved: (value) => _formData['bairro'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerCidade,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Cidade:",
                  ),
                  onSaved: (value) => _formData['cidade'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: controllerComplemento,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Complemento:",
                  ),
                  onSaved: (value) => _formData['complemento'] = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  initialValue: _formData['foto'],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Url da foto:",
                  ),
                  onSaved: (value) => _formData['foto'] = value!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> localizarCep() async {
    setState(() {
      pesquisandoCep = true;
    });

    final cep = await buscarCepContato(controllerCep.text);

    if (cep.localidade == '' || cep.localidade == null) {
      setState(() {
        pesquisandoCep = false;
      });
      statusBuscaCep = 'F';
    } else {
      statusBuscaCep = 'C';
      controllerRua.text = cep.logradouro!;
      controllerBairro.text = cep.bairro!;
      controllerCidade.text = cep.localidade! + ', ' + cep.uf!;
      controllerComplemento.text = cep.complemento!;

      setState(() {
        pesquisandoCep = false;
      });
    }

    _form.currentState?.validate();
  }

  saveCep(value) {
    if (value == null || value == '') {
      cep = 0;
    } else {
      cep = int.tryParse(value);
      _formData['cep'] = value!;
    }
  }

  void salvarContato() async {
    contato.nome = _formData['nome'];
    contato.email = _formData['email'];
    contato.foto = _formData['foto'];
    contato.telefone = _formData['telefone'];
    contato.celular = _formData['celular'];
    contato.cep = _formData['cep'] ?? '';
    contato.bairro = _formData['bairro'];
    contato.endereco = _formData['rua'];
    contato.cidade = _formData['cidade'];
    contato.complemento = _formData['complemento'];

    if (contato.id == null) {
      await Provider.of<ContatoDatabaseController>(context, listen: false)
          .insertContato(contato);
    } else {
      await Provider.of<ContatoDatabaseController>(context, listen: false)
          .updateContato(contato);
    }
    Navigator.pop(context, contato);
  }
}
