class Serial{
  String _codigo = "";
  List<String> _serial = [];
  int _qtd_informada = 0;

  String get codigo => _codigo;

  set codigo(String value) {
    _codigo = value;
  }

  List<String> get serial => _serial;

  set serial(List<String> value) {
    _serial = value;
  }

  int get qtd_informada => _qtd_informada;

  set qtd_informada(int value) {
    _qtd_informada = value;
  }
}