class RegistroBaixa{
  String _identificacao = "";
  String _data = "";
  String _tecnico = "";
  String _codigo = "";
  String _nome = "";
  int _qtd = 0;
  String _unidade = "";

  RegistroBaixa();

  RegistroBaixa.fromJson(Map <dynamic, dynamic> json)
  {
    _identificacao = json['identificacao'];
    _data = json['data'];
    _tecnico = json['tecnico'];
    _codigo = json['codigo'];
    _nome = json['nome'];
    _qtd = json['qtd'];
    _unidade = json['unidade'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identificacao'] = this._identificacao;
    data['data'] = this._data;
    data['tecnico'] = this._tecnico;
    data['codigo'] = this._codigo;
    data['nome'] = this._nome;
    data['qtd'] = this._qtd;
    data['unidade'] = this._unidade;
    return data;
  }

  String get unidade => _unidade;

  set unidade(String value) {
    _unidade = value;
  }

  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get codigo => _codigo;

  set codigo(String value) {
    _codigo = value;
  }

  String get tecnico => _tecnico;

  set tecnico(String value) {
    _tecnico = value;
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