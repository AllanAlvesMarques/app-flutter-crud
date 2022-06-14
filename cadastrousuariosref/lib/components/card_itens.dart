import 'package:cadastrousuariosref/controller/produtos_database_controller.dart';
import 'package:cadastrousuariosref/models/item_pedido_model.dart';
import 'package:cadastrousuariosref/models/produtos_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardItens extends StatefulWidget {
  const CardItens(this.item, {Key? key}) : super(key: key);

  final ItemPedidoModel item;

  @override
  State<CardItens> createState() => _CardItensState();
}

class _CardItensState extends State<CardItens> {
  double containerHeight = 250;
  bool showDesc = false;
  int indexOfImg = 0;
  ProdutosModel produtoPedido =
      ProdutosModel(img1: '', img2: '', img3: '', img4: '', img5: '');

  getProdutoPedido(BuildContext context, String idProduto) async {
    await Provider.of<ProdutosDatabaseController>(context, listen: false)
        .getProdutos();
    await Provider.of<ProdutosDatabaseController>(context, listen: false)
        .getProdutoById(idProduto);
    produtoPedido =
        Provider.of<ProdutosDatabaseController>(context, listen: false)
            .produtos[0];
  }

  @override
  void initState() {
    super.initState();
    getProdutoPedido(context, widget.item.idProd!.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              showDesc = !showDesc;
              if (showDesc == true) {
                containerHeight = 375;
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
                            imagesCarrossel(produtoPedido),
                            SizedBox(
                              height: 210,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: getBullets(produtoPedido),
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
                              child: Text(widget.item.sequencia!.toString()),
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
                      child: Text(widget.item.nomeProduto!,
                          style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 26, top: 10),
                      child: Text('R\$ ${widget.item.valorUni}',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                showDesc
                    ? SizedBox(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                      'Vendidos  ${widget.item.quantidadeVendida}',
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Total  ${widget.item.valorTotal}',
                                      style: const TextStyle(fontSize: 16)),
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
                image: NetworkImage(imgs[index]), fit: BoxFit.fill),
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
