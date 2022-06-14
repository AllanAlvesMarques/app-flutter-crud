// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cadastrousuariosref/controller/produtos_database_controller.dart';
import 'package:cadastrousuariosref/models/produtos_model.dart';
import 'package:cadastrousuariosref/views/cadastrar_alterar_produtos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardProdutos extends StatefulWidget {
  CardProdutos(
      {Key? key,
      required this.produto,
      this.onSelectProduto,
      this.onDeleteProduto})
      : super(key: key);

  final ProdutosModel produto;
  void Function(ProdutosModel produto)? onDeleteProduto;
  void Function(ProdutosModel produto)? onSelectProduto;

  @override
  State<CardProdutos> createState() => _CardProdutosState();
}

class _CardProdutosState extends State<CardProdutos> {
  double containerHeight = 250;
  bool showDesc = false;
  int indexOfImg = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Center(
        child: GestureDetector(
          onLongPress: () {
            if (widget.onSelectProduto != null) {
              widget.onSelectProduto!(widget.produto);
            }
          },
          onTap: () {
            setState(() {
              showDesc = !showDesc;
              if (showDesc == true) {
                containerHeight = 390;
              } else {
                containerHeight = 250;
              }
            });
          },
          child: Container(
            width: 380,
            height: containerHeight,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 233, 233, 233),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 215,
                        child: Stack(
                          children: [
                            imagesCarrossel(widget.produto),
                            SizedBox(
                              height: 210,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: getBullets(widget.produto),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 233, 233, 233),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Center(
                              child: Text(widget.produto.estoque!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10),
                      child: Text(widget.produto.nome!),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 26, top: 10),
                      child: Text('R\$ ' + widget.produto.preco!),
                    ),
                  ],
                ),
                showDesc
                    ? SizedBox(
                        width: 340,
                        child: Column(
                          children: [
                            TextFormField(
                              readOnly: true,
                              maxLines: 4,
                              initialValue: widget.produto.desc!,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CadastrarAlterarProdutos(
                                              'Editar Produto', widget.produto);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.create),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    if (widget.onDeleteProduto != null) {
                                      widget.onDeleteProduto!(widget.produto);
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DeleteDialog(widget.produto);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  imagesCarrossel(ProdutosModel produto) {
    List imgs = [];

    produto.img1 != '' ? imgs.add(produto.img1) : null;
    produto.img2 != '' ? imgs.add(produto.img2) : null;
    produto.img3 != '' ? imgs.add(produto.img3) : null;
    produto.img4 != '' ? imgs.add(produto.img4) : null;
    produto.img5 != '' ? imgs.add(produto.img5) : null;

    return PageView.builder(
      onPageChanged: (value) {
        setState(() {
          indexOfImg = value;
        });
      },
      itemCount: imgs.length,
      itemBuilder: (BuildContext _, int index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imgs[index]),
            ),
          ),
        );
      },
    );
  }

  bullet(int bulletId) {
    var singleBulelet = Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            color: indexOfImg == bulletId ? Colors.indigo : Colors.grey),
      ),
    );

    return singleBulelet;
  }

  getBullets(ProdutosModel produto) {
    List<Widget> listBullet = [];
    produto.img1 != '' ? listBullet.add(bullet(listBullet.length)) : null;
    produto.img2 != '' ? listBullet.add(bullet(listBullet.length)) : null;
    produto.img3 != '' ? listBullet.add(bullet(listBullet.length)) : null;
    produto.img4 != '' ? listBullet.add(bullet(listBullet.length)) : null;
    produto.img5 != '' ? listBullet.add(bullet(listBullet.length)) : null;
    return listBullet;
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog(this.produto, {Key? key}) : super(key: key);

  final ProdutosModel produto;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
