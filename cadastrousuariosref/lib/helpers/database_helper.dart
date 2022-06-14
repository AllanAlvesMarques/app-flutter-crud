import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    return _databaseHelper ??= DatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ??= await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'contatos.db';

    var contatosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE contato(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, 
            telefone TEXT, celular TEXT, email TEXT, endereco TEXT, bairro TEXT, cidade TEXT, complemento TEXT, foto TEXT, isFav TEXT, cep INTEGER)''');

    await db.execute(
        '''CREATE TABLE usuario(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, login TEXT, senha TEXT, permitirAlterar Text, permitirCadastrar Text, permitirDeletar Text, permitirVer Text)''');

    await db.execute(
        '''CREATE TABLE produto(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, preco TEXT, estoque TEXT, desc Text, img1 Text, img2 Text, img3 Text, img4 Text, img5 Text)''');

    await db.execute(
        '''CREATE TABLE pedido(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT, cliId INTEGER, cliNome TEXT, subTotal real, desconto real, total real, status Text, obs Text)''');

    await db.execute(
        '''CREATE TABLE pedido_item(id INTEGER PRIMARY KEY AUTOINCREMENT, sequencia INTEGER, idProd INTEGER, nomeProduto TEXT, quantidadeVendida INTEGER, valorUni real, valorTotal real, idPed INTEGER)''');
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}
