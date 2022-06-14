import 'package:cadastrousuariosref/views/contatos_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contato_model.dart';
import '../controller/contato_database_controller.dart';
import '../components/usuario_logado_sistema_bottom_widget.dart';
import '../routes/app_routes.dart';

class ListaContatosPage extends StatefulWidget {
  const ListaContatosPage({Key? key}) : super(key: key);

  @override
  State<ListaContatosPage> createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  late final ContatoDatabaseController db;
  final personIcon = 'assets/images/person_icon.png';

  @override
  void initState() {
    super.initState();
    db = Provider.of<ContatoDatabaseController>(context, listen: false);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    listarContatos();
  }

  listarContatos() async {
    await db.getContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const UsuarioLogadoSistemaBottomWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.group_add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.cadastrarAlterar);
        },
      ),
      appBar: AppBar(
        title: const Text('Contatos'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ContatoDatabaseController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.contatos.length,
            itemBuilder: (BuildContext context, int index) {
              return _listaContatos(context, controller.contatos[index]);
            },
          );
        },
      ),
    );
  }

  _listaContatos(BuildContext context, ContatoModel contato) {
    adicionaAvatar() {
      if (contato.foto == null || contato.foto == '') {
        return const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 226, 226, 226),
            radius: 28,
            backgroundImage: AssetImage('assets/images/person_icon.png'));
      } else {
        return CircleAvatar(
            radius: 28, backgroundImage: NetworkImage(contato.foto!));
      }
    }

    return ListTile(
      leading: adicionaAvatar(),
      title: Text(contato.nome!),
      subtitle: Text(contato.telefone!),
      trailing: contato.isFav
          ? const Icon(
              Icons.star,
              color: Colors.indigo,
            )
          : null,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ContatosInfo(contato);
          },
        ),
      ),
      onLongPress: () {
        Navigator.of(context).pop(contato);
      },
    );
  }
}

class Dialog extends StatefulWidget {
  const Dialog({Key? key}) : super(key: key);

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  String? valueChoose;

  List filtros = ['Nome', 'Código'];

  TextEditingController controller = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Escolha o filtro'),
      content: SizedBox(
        height: valueChoose == null ? 130 : 210,
        width: 280,
        child: Column(
          children: [
            DropdownButton(
                hint: const Text('Filtrar por: '),
                isExpanded: true,
                value: valueChoose,
                onChanged: (newValue) {
                  setState(() {
                    valueChoose = newValue.toString();
                  });
                },
                items: filtros.map((valueItem) {
                  return DropdownMenuItem(
                    child: Text(valueItem),
                    value: valueItem,
                  );
                }).toList()),
            Form(key: _form, child: getTextField()),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: valueChoose != null
                  ? ElevatedButton(
                      child: const Text('Pesquisar'),
                      onPressed: () {
                        final isValid = _form.currentState?.validate();
                        if (isValid!) {
                          Navigator.pop(context);
                          valueChoose == 'Nome'
                              ? Provider.of<ContatoDatabaseController>(context,
                                      listen: false)
                                  .getContatoByName(controller.text)
                              : Provider.of<ContatoDatabaseController>(context,
                                      listen: false)
                                  .getContatoById(controller.text);
                        }
                      },
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Provider.of<ContatoDatabaseController>(context,
                                listen: false)
                            .getContatos();
                        Navigator.pop(context);
                      },
                      child: const Text('Remover'),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTextField() {
    Widget textField = Container();

    if (valueChoose == 'Nome') {
      return textField = TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return 'Informe o campo';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Nome do contato: ",
        ),
      );
    }
    if (valueChoose == 'Código') {
      return textField = TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return 'Informe o campo';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Código do contato: ",
        ),
      );
    }
    // if (valueChoose == null) {
    //   return textField = Container();
    // }
    return textField;
  }
}
