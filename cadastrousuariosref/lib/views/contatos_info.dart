import 'package:cadastrousuariosref/models/contato_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/contato_database_controller.dart';
import '../components/usuario_logado_sistema_bottom_widget.dart';
import '../routes/app_routes.dart';

// ignore: must_be_immutable
class ContatosInfo extends StatefulWidget {
  ContatosInfo(this.contato, {Key? key}) : super(key: key);

  ContatoModel? contato;

  @override
  State<ContatosInfo> createState() => _ContatosInfoState();
}

const blueColor = Colors.indigo;

class _ContatosInfoState extends State<ContatosInfo> {
  final personIcon = 'assets/images/person_icon.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
      backgroundColor: blueColor,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Informações'),
        actions: [
          IconButton(
              icon: widget.contato!.isFav
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              onPressed: () {
                setState(() {
                  widget.contato!.isFav = !widget.contato!.isFav;
                });
                Provider.of<ContatoDatabaseController>(context, listen: false)
                    .updateContato(widget.contato!);
              }),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.cadastrarAlterar,
                        arguments: widget.contato)
                    .then(
                  (value) {
                    setState(() {
                      widget.contato = value as ContatoModel;
                    });
                  },
                );
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => dialogDeleteContato()).then(
                (value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 190.0,
                  height: 190.0,
                  child: getAvatarImage(widget.contato!),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    infoContatoLayout('Id'),
                    infoContatoLayout('Nome'),
                    infoContatoLayout('Telefone'),
                    infoContatoLayout('Email'),
                    infoContatoLayout('Celular'),
                    infoContatoLayout('Cep'),
                    infoContatoLayout('Endereco'),
                    infoContatoLayout('Bairro'),
                    infoContatoLayout('Cidade'),
                    infoContatoLayout('Complemento'),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogDeleteContato() {
    return AlertDialog(
      title: const Text('Excluir contato'),
      content: const Text('Você tem certeza que deseja excluir este contato?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () async {
            await Provider.of<ContatoDatabaseController>(context, listen: false)
                .deleteContato(
                    int.parse(widget.contato!.id.toString()), widget.contato!);
            Navigator.pop(context, true);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }

  infoContatoLayout(String nomeDoDado) {
    var tipoInfo = const Text('');
    var icone = const Icon(Icons.abc);

    switch (nomeDoDado) {
      case 'Id':
        tipoInfo = Text(
          widget.contato!.id.toString(),
        );

        icone = const Icon(
          Icons.select_all,
          color: blueColor,
        );
        break;

      case 'Nome':
        tipoInfo = Text(
          widget.contato!.nome.toString(),
        );

        icone = const Icon(
          Icons.person,
          color: blueColor,
        );
        break;

      case 'Telefone':
        tipoInfo = Text(
          widget.contato!.telefone.toString(),
        );

        icone = const Icon(
          Icons.phone,
          color: blueColor,
        );
        break;

      case 'Email':
        tipoInfo = Text(
          widget.contato!.email.toString(),
        );

        icone = const Icon(
          Icons.email_outlined,
          color: blueColor,
        );
        break;

      case 'Celular':
        tipoInfo = Text(
          widget.contato!.celular.toString(),
        );

        icone = const Icon(
          Icons.phone_android_outlined,
          color: blueColor,
        );
        break;

      case 'Cep':
        tipoInfo = Text(
          widget.contato!.cep.toString(),
        );

        icone = const Icon(
          Icons.numbers,
          color: blueColor,
        );
        break;

      case 'Endereco':
        tipoInfo = Text(
          widget.contato!.endereco.toString(),
        );

        icone = const Icon(
          Icons.house_rounded,
          color: blueColor,
        );
        break;

      case 'Bairro':
        tipoInfo = Text(
          widget.contato!.bairro.toString(),
        );

        icone = const Icon(
          Icons.account_balance_rounded,
          color: blueColor,
        );
        break;

      case 'Complemento':
        tipoInfo = Text(
          widget.contato!.complemento.toString(),
        );

        icone = const Icon(Icons.landscape, color: blueColor);
        break;

      case 'Cidade':
        tipoInfo = Text(
          widget.contato!.cidade.toString(),
        );

        icone = const Icon(Icons.business_rounded, color: blueColor);
        break;
    }

    return Card(
      elevation: 0.0,
      color: const Color.fromARGB(0, 255, 16, 16),
      child: ListTile(leading: icone, title: tipoInfo),
    );
  }

  getAvatarImage(ContatoModel contato) {
    if (contato.foto == null || contato.foto == '') {
      return CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(
          personIcon,
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(
        widget.contato!.foto.toString(),
      ),
    );
  }
}
