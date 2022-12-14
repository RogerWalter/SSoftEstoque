import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase_options.dart';

class Item{
  String _codigo = "";
  String _nome = "";
  int _qtd = 0;
  String _unidade = "";
  int _controla_serial = 0; //0 - NÃO | 1 - SIM

  Item.fromJson(Map <dynamic, dynamic> json)
  {
    _codigo = json['codigo'];
    _nome = json['nome'];
    _qtd = json['qtd'];
    _unidade = json['unidade'];
    _controla_serial = json['controla_serial'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this._codigo;
    data['nome'] = this._nome;
    data['qtd'] = this._qtd;
    data['unidade'] = this._unidade;
    data['controla_serial'] = this._controla_serial;
    return data;
  }

  Item();

  String get codigo => _codigo;

  set codigo(String value) {
    _codigo = value;
  }

  String get nome => _nome;

  int get controla_serial => _controla_serial;

  set controla_serial(int value) {
    _controla_serial = value;
  }

  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  set nome(String value) {
    _nome = value;
  }

  String get unidade => _unidade;

  set unidade(String value) {
    _unidade = value;
  }

  recuperar_itens_estoque(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    List<Item> _listaItens = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("estoque").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        Item _itemLista = Item();
        final json = ds.value as Map<dynamic, dynamic>;
        _itemLista = Item.fromJson(json);
        _listaItens.add(_itemLista);
      }
    }
    return _listaItens;
  }

  recuperar_itens_devolucao(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    List<Item> _listaItens = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("item_devolucao").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        Item _itemLista = Item();
        final json = ds.value as Map<dynamic, dynamic>;
        _itemLista = Item.fromJson(json);
        _listaItens.add(_itemLista);
      }
    }
    return _listaItens;
  }

  Future<int> recupera_ultima_chave_baixa(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int ultima_chave = 0;
    List<int> chaves = <int>[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("chave_saida").get();
    if (snapshot.exists) {
      for(DataSnapshot ds in snapshot.children){
        int chave_ds = int.parse(ds.value.toString());
        ultima_chave = chave_ds;
        chaves.add(chave_ds);
      }
    } else {
      print('No data available.');
    }
    return ultima_chave;
  }

  Future<int> recupera_ultima_chave_entrada(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int ultima_chave = 0;
    List<int> chaves = <int>[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("chave_entrada").get();
    if (snapshot.exists) {
      for(DataSnapshot ds in snapshot.children){
        int chave_ds = int.parse(ds.value.toString());
        ultima_chave = chave_ds;
        chaves.add(chave_ds);
      }
    } else {
      print('No data available.');
    }
    return ultima_chave;
  }

  Future<int> recupera_ultima_chave_devolucao(String filial) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int ultima_chave = 0;
    List<int> chaves = <int>[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(filial).child("chave_devolucao").get();
    if (snapshot.exists) {
      for(DataSnapshot ds in snapshot.children){
        int chave_ds = int.parse(ds.value.toString());
        ultima_chave = chave_ds;
        chaves.add(chave_ds);
      }
    } else {
      print('No data available.');
    }
    return ultima_chave;
  }
}