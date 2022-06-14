import 'package:cadastrousuariosref/models/produtos_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class ProdutosDatabaseController extends ChangeNotifier {
  late Database db;

  final table = 'produto';
  String columnId = 'id';

  List<ProdutosModel> _produtos = [];
  List<ProdutosModel> get produtos => _produtos;

  ProdutosDatabaseController();

  Future<void> insertProduto(ProdutosModel produto) async {
    db = await DatabaseHelper().database;
    await db.insert(table, produto.toMap());

    final ultimoId = await getLastUpdateProdutos();

    produto.id = ultimoId.toString();
    _produtos.add(produto);
    notifyListeners();
  }

  getProdutos() async {
    db = await DatabaseHelper().database;
    var resultado = await db.query(table);

    _produtos = resultado.isNotEmpty
        ? resultado.map((c) => ProdutosModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  Future<void> updateProdutos(ProdutosModel produto) async {
    db = await DatabaseHelper().database;
    await db.update(table, produto.toMap(),
        where: '$columnId = ?', whereArgs: [produto.id]);
    final index = _produtos.indexWhere((e) => e.id == produto.id);

    if (index != -1) {
      _produtos[index] = produto;
    }
    notifyListeners();
  }

  Future<void> deleteProduto(int id, ProdutosModel produto) async {
    db = await DatabaseHelper().database;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    _produtos.remove(produto);
    notifyListeners();
  }

  Future<int> getLastUpdateProdutos() async {
    db = await DatabaseHelper().database;

    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(id) FROM $table'));

    return count ?? 0;
  }

  Future<void> getProdutoByName(String nomeProduto) async {
    db = await DatabaseHelper().database;

    final result = await db
        .rawQuery('SELECT * FROM produto WHERE nome LIKE \'$nomeProduto%\'');
    _produtos = result.map((e) => ProdutosModel.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> getProdutoById(String idProduto) async {
    db = await DatabaseHelper().database;
    final result =
        await db.rawQuery('SELECT * FROM produto WHERE id =' + idProduto);
    _produtos = result.map((e) => ProdutosModel.fromMap(e)).toList();
    notifyListeners();
  }
}
