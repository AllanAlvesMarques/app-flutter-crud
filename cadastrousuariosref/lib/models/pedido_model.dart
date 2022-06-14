// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PedidoModel {
  int? id;
  String? data;
  int? cliId;
  String? cliNome;
  double subTotal;
  double desconto;
  double total;
  String status;
  String? obs;
  PedidoModel({
    this.id,
    this.data,
    this.cliId,
    this.cliNome,
    this.subTotal = 0,
    this.desconto = 0,
    this.total = 0,
    this.status = 'I',
    this.obs,
  });

  PedidoModel copyWith({
    int? id,
    String? data,
    int? cliId,
    String? cliNome,
    double? subTotal,
    double? desconto,
    double? total,
    String? status,
    String? obs,
  }) {
    return PedidoModel(
      id: id ?? this.id,
      data: data ?? this.data,
      cliId: cliId ?? this.cliId,
      cliNome: cliNome ?? this.cliNome,
      subTotal: subTotal ?? this.subTotal,
      desconto: desconto ?? this.desconto,
      total: total ?? this.total,
      status: status ?? this.status,
      obs: obs ?? this.obs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data,
      'cliId': cliId,
      'cliNome': cliNome,
      'subTotal': subTotal,
      'desconto': desconto,
      'total': total,
      'status': status,
      'obs': obs,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'] != null ? map['id'] as int : null,
      data: map['data'] != null ? map['data'] as String : null,
      cliId: map['cliId'] != null ? map['cliId'] as int : null,
      cliNome: map['cliNome'] != null ? map['cliNome'] as String : null,
      subTotal: map['subTotal'] as double,
      desconto: map['desconto'] as double,
      total: map['total'] as double,
      status: map['status'] as String,
      obs: map['obs'] != null ? map['obs'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) =>
      PedidoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PedidoModel(id: $id, data: $data, cliId: $cliId, cliNome: $cliNome, subTotal: $subTotal, desconto: $desconto, total: $total, status: $status, obs: $obs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PedidoModel &&
        other.id == id &&
        other.data == data &&
        other.cliId == cliId &&
        other.cliNome == cliNome &&
        other.subTotal == subTotal &&
        other.desconto == desconto &&
        other.total == total &&
        other.status == status &&
        other.obs == obs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        cliId.hashCode ^
        cliNome.hashCode ^
        subTotal.hashCode ^
        desconto.hashCode ^
        total.hashCode ^
        status.hashCode ^
        obs.hashCode;
  }
}
