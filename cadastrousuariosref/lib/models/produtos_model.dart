// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProdutosModel {
  String? id;
  String? nome;
  String? preco;
  String? estoque;
  String? desc;
  String? img1;
  String? img2;
  String? img3;
  String? img4;
  String? img5;
  ProdutosModel({
    this.id,
    this.nome,
    this.preco,
    this.estoque,
    this.desc,
    this.img1,
    this.img2,
    this.img3,
    this.img4,
    this.img5,
  });

  ProdutosModel copyWith({
    String? id,
    String? nome,
    String? preco,
    String? estoque,
    String? desc,
    String? img1,
    String? img2,
    String? img3,
    String? img4,
    String? img5,
  }) {
    return ProdutosModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      estoque: estoque ?? this.estoque,
      desc: desc ?? this.desc,
      img1: img1 ?? this.img1,
      img2: img2 ?? this.img2,
      img3: img3 ?? this.img3,
      img4: img4 ?? this.img4,
      img5: img5 ?? this.img5,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'preco': preco,
      'estoque': estoque,
      'desc': desc,
      'img1': img1,
      'img2': img2,
      'img3': img3,
      'img4': img4,
      'img5': img5,
    };
  }

  factory ProdutosModel.fromMap(Map<String, dynamic> map) {
    return ProdutosModel(
      // ignore: unnecessary_cast
      id: map['id'] != null ? map['id'].toString() as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      preco: map['preco'] != null ? map['preco'] as String : null,
      estoque: map['estoque'] != null ? map['estoque'] as String : null,
      desc: map['desc'] != null ? map['desc'] as String : null,
      img1: map['img1'] != null ? map['img1'] as String : null,
      img2: map['img2'] != null ? map['img2'] as String : null,
      img3: map['img3'] != null ? map['img3'] as String : null,
      img4: map['img4'] != null ? map['img4'] as String : null,
      img5: map['img5'] != null ? map['img5'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutosModel.fromJson(String source) =>
      ProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProdutosModel(id: $id, nome: $nome, preco: $preco, estoque: $estoque, desc: $desc, img1: $img1, img2: $img2, img3: $img3, img4: $img4, img5: $img5)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProdutosModel &&
        other.id == id &&
        other.nome == nome &&
        other.preco == preco &&
        other.estoque == estoque &&
        other.desc == desc &&
        other.img1 == img1 &&
        other.img2 == img2 &&
        other.img3 == img3 &&
        other.img4 == img4 &&
        other.img5 == img5;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        preco.hashCode ^
        estoque.hashCode ^
        desc.hashCode ^
        img1.hashCode ^
        img2.hashCode ^
        img3.hashCode ^
        img4.hashCode ^
        img5.hashCode;
  }
}
