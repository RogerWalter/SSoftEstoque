import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

import '../firebase_options.dart';
import 'ItemSeparacao.dart';

class DadosSeparacao{
  String _identificacao = "";
  String _data = "";
  String _tecnico = "";
  List<ItemSeparacao> _itens = [];

  DadosSeparacao();

  DadosSeparacao.fromJson(Map <dynamic, dynamic> json)
  {
    _identificacao = json['identificacao'];
    _data = json['data'];
    _tecnico = json['tecnico'];
    //_itens = json['itens'].cast<ItemSeparacao>();
    var list = json['itens'] as List;
    List<ItemSeparacao> itens = list.map((i) => ItemSeparacao.fromJson(i)).toList();
    _itens = itens;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identificacao'] = this._identificacao;
    data['data'] = this._data;
    data['tecnico'] = this._tecnico;
    data['itens'] = this._itens.map((item) => item.toJson()).toList();
    return data;
  }

  List<ItemSeparacao> get itens => _itens;

  set itens(List<ItemSeparacao> value) {
    _itens = value;
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

  recuperar_separacoes(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ObservableList<DadosSeparacao> _listaItens = ObservableList();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("separacao").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        DadosSeparacao _itemLista = DadosSeparacao();
        final json = ds.value as Map<dynamic, dynamic>;
        _itemLista = DadosSeparacao.fromJson(json);
        _listaItens.add(_itemLista);
      }
    }
    return _listaItens;
  }

  remover_todas_separacoes(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DatabaseReference ref_separacao = FirebaseDatabase.instance.ref(filial).child("separacao");
    await ref_separacao.remove();
  }

  remover_separacao(String filial, String identificacao) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DatabaseReference ref_separacao = FirebaseDatabase.instance.ref(filial).child("separacao").child(identificacao);
    await ref_separacao.remove();
  }
}