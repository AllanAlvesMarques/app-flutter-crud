class HttpCepModel {
  final String? logradouro;
  final String? bairro;
  final String? localidade;
  final String? complemento;
  final String? uf;

  HttpCepModel(
      {this.complemento,
      this.logradouro,
      this.bairro,
      this.localidade,
      this.uf});
}
