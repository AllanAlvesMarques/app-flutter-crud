import 'package:cadastrousuariosref/components/card_produtos.dart';
import 'package:cadastrousuariosref/controller/produtos_database_controller.dart';
import 'package:cadastrousuariosref/models/produtos_model.dart';
import 'package:cadastrousuariosref/views/cadastrar_alterar_produtos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListarProdutos extends StatefulWidget {
  const ListarProdutos({Key? key}) : super(key: key);

  @override
  State<ListarProdutos> createState() => _ListarProdutosState();
}

class _ListarProdutosState extends State<ListarProdutos> {
  double containerHeight = 250;
  bool showDesc = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await Provider.of<ProdutosDatabaseController>(context, listen: false)
        .getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CadastrarAlterarProdutos('Cadastrar Produtos', null);
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
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
      body: Consumer<ProdutosDatabaseController>(
        builder: ((context, controller, child) {
          return ListView.builder(
            itemCount: controller.produtos.length,
            itemBuilder: (BuildContext context, int index) {
              return CardProdutos(
                  produto: controller.produtos[index],
                  onDeleteProduto: (deleteProduto),
                  onSelectProduto: (selectProduto));
            },
          );
        }),
      ),
    );
  }

  selectProduto(ProdutosModel value) {
    Navigator.of(context).pop(value);
  }

  deleteProduto(produto) {
    AlertDialog(
      title: const Text('Deseja deletar este Produto'),
      content: const Text('Este Produto será apagado'),
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
            await Provider.of<ProdutosDatabaseController>(context,
                    listen: false)
                .deleteProduto(int.tryParse(produto.id!)!, produto);
            Navigator.pop(context);
          },
        ),
      ],
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
                          valueChoose == 'Nome'
                              ? Provider.of<ProdutosDatabaseController>(context,
                                      listen: false)
                                  .getProdutoByName(controller.text)
                              : Provider.of<ProdutosDatabaseController>(context,
                                      listen: false)
                                  .getProdutoById(controller.text);
                          Navigator.pop(context);
                        }
                      },
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Provider.of<ProdutosDatabaseController>(context,
                                listen: false)
                            .getProdutos();
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
          labelText: "Nome do produto: ",
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
          labelText: "Código do produto: ",
        ),
      );
    }
    // if (valueChoose == null) {
    //   return textField = Container();
    // }
    return textField;
  }
}
