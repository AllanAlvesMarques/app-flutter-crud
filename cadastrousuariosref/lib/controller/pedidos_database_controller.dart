import 'package:cadastrousuariosref/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';

class PedidosDatabaseController extends ChangeNotifier {
  late Database db;

  final table = 'pedido';
  String columnId = 'id';

  List<PedidoModel> _pedido = [];
  List<PedidoModel> get pedidolist => _pedido;

  PedidosDatabaseController();

  Future<PedidoModel> insertPedido(PedidoModel pedido) async {
    db = await DatabaseHelper().database;
    await db.insert(table, pedido.toMap());

    final ultimoId = await getLastUpdatePedido();

    pedido.id = ultimoId;
    _pedido.add(pedido);
    notifyListeners();
    return pedido;
  }

  getPedidos() async {
    db = await DatabaseHelper().database;

    var resultado = await db.query(table);

    _pedido = resultado.isNotEmpty
        ? resultado.map((c) => PedidoModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  Future<void> updatePedido(PedidoModel pedido) async {
    db = await DatabaseHelper().database;

    await db.update(table, pedido.toMap(),
        where: '$columnId = ?', whereArgs: [pedido.id]);
    final index = _pedido.indexWhere((e) => e.id == pedido.id);

    if (index != -1) {
      _pedido[index] = pedido;
    }

    notifyListeners();
  }

  Future<void> deletePedido(int id, PedidoModel pedido) async {
    db = await DatabaseHelper().database;

    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    _pedido.remove(pedido);

    notifyListeners();
  }

  Future<int> getLastUpdatePedido() async {
    db = await DatabaseHelper().database;

    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT MAX(id) FROM $table'));

    return count ?? 0;
  }

  Future<void> getPedidoById(String pedidoId) async {
    db = await DatabaseHelper().database;
    final result =
        await db.rawQuery('SELECT * FROM pedido WHERE id =' + pedidoId);
    _pedido = result.map((e) => PedidoModel.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> clearPedidos() async {
    db = await DatabaseHelper().database;
    _pedido = [];
    notifyListeners();
  }
}
