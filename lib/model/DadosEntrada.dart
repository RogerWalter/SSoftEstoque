class DadosEntrada{
  String _identificacao = "";
  String _data = "";
  String _operador = "";
  String _link = "";

  DadosEntrada();

  DadosEntrada.fromJson(Map <dynamic, dynamic> json)
  {
    _identificacao = json['identificacao'];
    _data = json['data'];
    _operador = json['operador'];
    _link = json['link'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identificacao'] = this._identificacao;
    data['data'] = this._data;
    data['operador'] = this._operador;
    data['link'] = this._link;
    return data;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  String get operador => _operador;

  set operador(String value) {
    _operador = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get identificacao => _identificacao;

  set identificacao(String value) {
    _identificacao = value;
  }
}