class ConversorMoeda {
  double valorParaConverter;
  double cotacaoMoeda;

  ConversorMoeda(double valorParaConverter, double cotacaoMoeda) {
    this.valorParaConverter = valorParaConverter;
    this.cotacaoMoeda = cotacaoMoeda;
  }

  double converter() {
    var resultado = valorParaConverter / cotacaoMoeda;
    return resultado;
  }

  String converterEmString() {
    var resultado = 'US\$ ' + converter().toStringAsFixed(2);
    return resultado;
  }
}