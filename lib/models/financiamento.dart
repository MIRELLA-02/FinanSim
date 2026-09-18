class Financiamento {
  double valor;
  int parcelas;
  double taxa;
  double montante;
  double valorParcela;

  Financiamento({
    required this.valor,
    required this.parcelas,
    required this.taxa,
    required this.montante,
    required this.valorParcela,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'parcelas': parcelas,
      'taxa': taxa,
      'montante': montante,
      'valorParcela': valorParcela,
    };
  }

  factory Financiamento.fromMap(Map<String, dynamic> map) {
    return Financiamento(
      valor: map['valor'],
      parcelas: map['parcelas'],
      taxa: map['taxa'],
      montante: map['montante'],
      valorParcela: map['valorParcela'],
    );
  }
}
