// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsuarioModel {
  int? id;
  String? nome;
  String? login;
  String? senha;
  bool permitirCadastrar = false;
  bool permitirAlterar = false;
  bool permitirDeletar = false;
  bool permitirVer = false;

  UsuarioModel({
    this.id,
    this.nome,
    this.login,
    this.senha,
    required this.permitirCadastrar,
    required this.permitirAlterar,
    required this.permitirDeletar,
    required this.permitirVer,
  });

  UsuarioModel copyWith({
    int? id,
    String? nome,
    String? login,
    String? senha,
    bool? permitirCadastrar,
    bool? permitirAlterar,
    bool? permitirDeletar,
    bool? permitirVer,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      permitirCadastrar: permitirCadastrar ?? this.permitirCadastrar,
      permitirAlterar: permitirAlterar ?? this.permitirAlterar,
      permitirDeletar: permitirDeletar ?? this.permitirDeletar,
      permitirVer: permitirVer ?? this.permitirVer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'login': login,
      'senha': senha,
      'permitirCadastrar': permitirCadastrar ? 'S' : 'N',
      'permitirAlterar': permitirAlterar ? 'S' : 'N',
      'permitirDeletar': permitirDeletar ? 'S' : 'N',
      'permitirVer': permitirVer ? 'S' : 'N',
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] != null ? map['id'] as int : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      login: map['login'] != null ? map['login'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      permitirCadastrar: map['permitirCadastrar'] == 'S',
      permitirAlterar: map['permitirAlterar'] == 'S',
      permitirDeletar: map['permitirDeletar'] == 'S',
      permitirVer: map['permitirVer'] == 'S',
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) =>
      UsuarioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioModel(id: $id, nome: $nome, login: $login, senha: $senha, permitirCadastrar: $permitirCadastrar, permitirAlterar: $permitirAlterar, permitirDeletar: $permitirDeletar, permitirVer: $permitirVer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsuarioModel &&
        other.id == id &&
        other.nome == nome &&
        other.login == login &&
        other.senha == senha &&
        other.permitirCadastrar == permitirCadastrar &&
        other.permitirAlterar == permitirAlterar &&
        other.permitirDeletar == permitirDeletar &&
        other.permitirVer == permitirVer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        login.hashCode ^
        senha.hashCode ^
        permitirCadastrar.hashCode ^
        permitirAlterar.hashCode ^
        permitirDeletar.hashCode ^
        permitirVer.hashCode;
  }
}
