import 'package:cadastrousuariosref/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../controller/usuario_logado_controller.dart';

class UsuariosDatabaseController extends ChangeNotifier {
  late Database db;

  final usuarioLogadoController = UsuarioLogadoController();

  String usuarioTable = 'usuario';
  String columnId = 'id';

  UsuarioModel usuarioLogado = UsuarioModel(
      permitirAlterar: false,
      permitirCadastrar: false,
      permitirDeletar: false,
      permitirVer: false);

  List<UsuarioModel> _usuarios = [];

  UsuariosDatabaseController();

  List<UsuarioModel> get usuarios => _usuarios;

  Future<void> insertUsuario(UsuarioModel usuario) async {
    db = await DatabaseHelper().database;

    await db.insert(usuarioTable, usuario.toMap());

    final ultimoId = await getLastUpdateUsuarios();

    usuario.id = ultimoId;

    _usuarios.add(usuario);

    notifyListeners();
  }

  getUsuarios() async {
    db = await DatabaseHelper().database;
    var resultado = await db.query(usuarioTable);

    _usuarios = resultado.isNotEmpty
        ? resultado.map((c) => UsuarioModel.fromMap(c)).toList()
        : [];
    notifyListeners();
  }

  Future<void> updateUsuario(UsuarioModel usuario) async {
    db = await DatabaseHelper().database;
    await db.update(usuarioTable, usuario.toMap(),
        where: '$columnId = ?', whereArgs: [usuario.id]);
    final index = _usuarios.indexWhere((e) => e.id == usuario.id);

    if (index != -1) {
      _usuarios[index] = usuario;
      notifyListeners();
    }
  }

  Future<void> deleteUsuario(int id, UsuarioModel usuario) async {
    db = await DatabaseHelper().database;
    await db.delete(usuarioTable, where: '$columnId = ?', whereArgs: [id]);
    _usuarios.remove(usuario);
    notifyListeners();
  }

  Future<int> getLastUpdateUsuarios() async {
    db = await DatabaseHelper().database;

    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT MAX(id) FROM $usuarioTable'));

    return count ?? 0;
  }

  carregarUsuarioSalvo() async {
    final user = await usuarioLogadoController.getUsuarioPermaneceLogado();
    if (user.id != null) {
      usuarioLogado = user;
    }
  }
}
