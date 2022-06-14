import 'package:cadastrousuariosref/models/item_pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class ItemPedidoDatabaseController extends ChangeNotifier {
  late Database db;

  final table = 'pedido_item';
  String columnId = 'id';

  List<ItemPedidoModel> _item = [];
  List<ItemPedidoModel> get itens => _item;

  ItemPedidoDatabaseController();

  insertPedidoItem(ItemPedidoModel item) async {
    db = await DatabaseHelper().database;
    await db.insert(table, item.toMap());

    final ultimoId = await getLastUpdatePedidoItem();

    item.id = ultimoId;

    _item.add(item);
    notifyListeners();
  }

  getPedidoItens() async {
    db = await DatabaseHelper().database;

    var resultado = await db.query(table);

    _item = resultado.isNotEmpty
        ? resultado.map((c) => ItemPedidoModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  Future<void> updatePedidoItem(ItemPedidoModel item) async {
    db = await DatabaseHelper().database;

    await db.update(table, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
    final index = _item.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      _item[index] = item;
    }

    notifyListeners();
  }

  Future<void> deletePedidoItem(int id, ItemPedidoModel item) async {
    db = await DatabaseHelper().database;

    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    _item.remove(item);

    notifyListeners();
  }

  Future<int> getLastUpdatePedidoItem() async {
    db = await DatabaseHelper().database;

    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(id) FROM $table'));

    return count ?? 0;
  }

  Future<void> getItemByPedidoId(int idPed) async {
    db = await DatabaseHelper().database;
    final result = await db
        .rawQuery('SELECT * FROM pedido_item WHERE idPed =' + idPed.toString());
    _item = result.map((e) => ItemPedidoModel.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> deleteAllItensOfPedido(int idPed) async {
    await getItemByPedidoId(idPed);
    _item.forEach((element) {
      deletePedidoItem(element.id!, element);
    });
  }
}
