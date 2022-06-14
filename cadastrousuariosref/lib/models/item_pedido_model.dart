// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemPedidoModel {
  int? id;
  int? sequencia;
  int? idProd;
  String? nomeProduto;
  int quantidadeVendida;
  double valorUni;
  double valorTotal;
  int? idPed;
  ItemPedidoModel({
    this.id,
    this.sequencia,
    this.idProd,
    this.nomeProduto,
    this.quantidadeVendida = 1,
    this.valorUni = 0,
    this.valorTotal = 0,
    this.idPed,
  });

  ItemPedidoModel copyWith({
    int? id,
    int? sequencia,
    int? idProd,
    String? nomeProduto,
    int? quantidadeVendida,
    double? valorUni,
    double? valorTotal,
    int? idPed,
  }) {
    return ItemPedidoModel(
      id: id ?? this.id,
      sequencia: sequencia ?? this.sequencia,
      idProd: idProd ?? this.idProd,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      quantidadeVendida: quantidadeVendida ?? this.quantidadeVendida,
      valorUni: valorUni ?? this.valorUni,
      valorTotal: valorTotal ?? this.valorTotal,
      idPed: idPed ?? this.idPed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sequencia': sequencia,
      'idProd': idProd,
      'nomeProduto': nomeProduto,
      'quantidadeVendida': quantidadeVendida,
      'valorUni': valorUni,
      'valorTotal': valorTotal,
      'idPed': idPed,
    };
  }

  factory ItemPedidoModel.fromMap(Map<String, dynamic> map) {
    return ItemPedidoModel(
      id: map['id'] != null ? map['id'] as int : null,
      sequencia: map['sequencia'] != null ? map['sequencia'] as int : null,
      idProd: map['idProd'] != null ? map['idProd'] as int : null,
      nomeProduto:
          map['nomeProduto'] != null ? map['nomeProduto'] as String : null,
      quantidadeVendida: map['quantidadeVendida'] as int,
      valorUni: map['valorUni'] as double,
      valorTotal: map['valorTotal'] as double,
      idPed: map['idPed'] != null ? map['idPed'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemPedidoModel.fromJson(String source) =>
      ItemPedidoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemPedidoModel(id: $id, sequencia: $sequencia, idProd: $idProd, nomeProduto: $nomeProduto, quantidadeVendida: $quantidadeVendida, valorUni: $valorUni, valorTotal: $valorTotal, idPed: $idPed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemPedidoModel &&
        other.id == id &&
        other.sequencia == sequencia &&
        other.idProd == idProd &&
        other.nomeProduto == nomeProduto &&
        other.quantidadeVendida == quantidadeVendida &&
        other.valorUni == valorUni &&
        other.valorTotal == valorTotal &&
        other.idPed == idPed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sequencia.hashCode ^
        idProd.hashCode ^
        nomeProduto.hashCode ^
        quantidadeVendida.hashCode ^
        valorUni.hashCode ^
        valorTotal.hashCode ^
        idPed.hashCode;
  }
}
