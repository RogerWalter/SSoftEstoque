class ItemSeparacao{
  String _codigo = "";
  String _nome = "";
  int _qtd = 0;
  String _unidade = "";
  int _controla_serial = 0;
  String _seriais = "";

  ItemSeparacao.fromJson(Map <dynamic, dynamic> json)
  {
    _codigo = json['codigo'];
    _nome = json['nome'];
    _qtd = json['qtd'];
    _unidade = json['unidade'];
    _controla_serial = json['controla_serial'];
    _seriais = json['seriais'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this._codigo;
    data['nome'] = this._nome;
    data['qtd'] = this._qtd;
    data['unidade'] = this._unidade;
    data['controla_serial'] = this._controla_serial;
    data['seriais'] = this._seriais;
    return data;
  }

  int get controla_serial => _controla_serial;

  set controla_serial(int value) {
    _controla_serial = value;
  }

  ItemSeparacao();

  String get seriais => _seriais;

  set seriais(String value) {
    _seriais = value;
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
}