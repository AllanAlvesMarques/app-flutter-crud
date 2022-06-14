import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/usuarios_database_controller.dart';

class UsuarioLogadoSistemaBottomWidget extends StatelessWidget {
  const UsuarioLogadoSistemaBottomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      height: 40,
      width: double.infinity,
      //color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Text(
          'O usuário: ' +
              Provider.of<UsuariosDatabaseController>(context, listen: false)
                  .usuarioLogado
                  .nome! +
              ', está logado no sistema',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
