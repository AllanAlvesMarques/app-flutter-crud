class ContatoModel {
  int? id;
  String? nome;
  String? telefone;
  String? celular;
  String? email;
  String? endereco;
  String? bairro;
  String? cidade;
  String? complemento;
  String? foto;
  bool isFav = false;
  String? cep;

  ContatoModel({
    this.id,
    this.nome,
    this.telefone,
    this.celular,
    this.email,
    this.endereco,
    this.bairro,
    this.cidade,
    this.complemento,
    this.foto,
    this.isFav = false,
    this.cep,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'celular': celular,
      'email': email,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'complemento': complemento,
      'foto': foto,
      'isFav': isFav ? 'S' : 'N',
      'cep': cep
    };
    return map;
  }

  ContatoModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    telefone = map['telefone'];
    celular = map['celular'];
    email = map['email'];
    endereco = map['endereco'];
    bairro = map['bairro'];
    cidade = map['cidade'];
    complemento = map['complemento'];
    foto = map['foto'];
    isFav = map['isFav'] == 'S';
    cep = map['cep'].toString();
  }

  @override
  String toString() {
    return "Contato => ('id: $id,'nome: $nome, telefone: $telefone, celular: $celular, email: $email, endereco: $endereco, bairro: $bairro, cidade: $cidade, complemento: $complemento,foto: $foto, isFav: $isFav, cep: $cep)";
  }
}
