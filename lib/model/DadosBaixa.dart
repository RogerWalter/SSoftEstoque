class DadosBaixa{
  String _identificacao = "";
  String _data = "";
  String _tecnico = "";
  String _link = "";

  DadosBaixa();

  DadosBaixa.fromJson(Map <dynamic, dynamic> json)
  {
    _identificacao = json['identificacao'];
    _data = json['data'];
    _tecnico = json['tecnico'];
    _link = json['link'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identificacao'] = this._identificacao;
    data['data'] = this._data;
    data['tecnico'] = this._tecnico;
    data['link'] = this._link;
    return data;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
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