import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';
import 'dart:convert';

class UsuarioLogadoController {
  final key = 'USER_PERMANECERLOGADO';

  saveUsuarioLogado(UsuarioModel usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, usuario.toJson());
  }

  Future<UsuarioModel> getUsuarioPermaneceLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(key);

    if (res != null) {
      return UsuarioModel.fromMap(json.decode(res));
    }
    return UsuarioModel(
        permitirAlterar: false,
        permitirCadastrar: false,
        permitirDeletar: false,
        permitirVer: false);
  }

  removeUsuarioLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
