import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contato_model.dart';
import '../helpers/database_helper.dart';
import 'dart:async';

class ContatoDatabaseController extends ChangeNotifier {
  late Database db;

  String contatoTable = 'contato';
  String columnId = 'id';

  List<ContatoModel> _contatos = [];
  List<ContatoModel> get contatos => _contatos;

  ContatoDatabaseController();

  Future<void> insertContato(ContatoModel contato) async {
    db = await DatabaseHelper().database;

    await db.insert(contatoTable, contato.toMap());

    final ultimoId = await getLastUpdate();

    contato.id = ultimoId;

    _contatos.add(contato);

    notifyListeners();
  }

  getContatos() async {
    db = await DatabaseHelper().database;
    var resultado = await db.query(contatoTable);

    _contatos = resultado.isNotEmpty
        ? resultado.map((c) => ContatoModel.fromMap(c)).toList()
        : [];

    notifyListeners();
  }

  Future<void> updateContato(ContatoModel contato) async {
    db = await DatabaseHelper().database;
    await db.update(contatoTable, contato.toMap(),
        where: '$columnId = ?', whereArgs: [contato.id]);
    final index = _contatos.indexWhere((e) => e.id == contato.id);

    if (index != -1) {
      _contatos[index] = contato;
      notifyListeners();
    }
  }

  Future<void> deleteContato(int id, ContatoModel contato) async {
    db = await DatabaseHelper().database;
    await db.delete(contatoTable, where: '$columnId = ?', whereArgs: [id]);
    _contatos.remove(contato);
    notifyListeners();
  }

  Future<int> getCount() async {
    db = await DatabaseHelper().database;
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT COUNT (*) from $contatoTable');

    int resultado = Sqflite.firstIntValue(list)!;
    return resultado;
  }

  Future<int> getLastUpdate() async {
    db = await DatabaseHelper().database;

    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX(id) FROM $contatoTable'));

    return count ?? 0;
  }

  getContatoByName(String nomeContato) async {
    db = await DatabaseHelper().database;

    final result = await db
        .rawQuery('SELECT * FROM contato WHERE nome LIKE \'$nomeContato%\'');
    _contatos = result
        .map(
          (e) => ContatoModel.fromMap(e),
        )
        .toList();
    notifyListeners();
  }

  getContatoById(String idContato) async {
    db = await DatabaseHelper().database;
    final result =
        await db.rawQuery('SELECT * FROM contato WHERE id =' + idContato);
    _contatos = result
        .map(
          (e) => ContatoModel.fromMap(e),
        )
        .toList();
    notifyListeners();
  }
}
