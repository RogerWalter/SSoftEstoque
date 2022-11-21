// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ItemController.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItemController on ItemControllerBase, Store {
  late final _$codigoAtom =
      Atom(name: 'ItemControllerBase.codigo', context: context);

  @override
  String get codigo {
    _$codigoAtom.reportRead();
    return super.codigo;
  }

  @override
  set codigo(String value) {
    _$codigoAtom.reportWrite(value, super.codigo, () {
      super.codigo = value;
    });
  }

  late final _$seriais_itemAtom =
      Atom(name: 'ItemControllerBase.seriais_item', context: context);

  @override
  ObservableList<String> get seriais_item {
    _$seriais_itemAtom.reportRead();
    return super.seriais_item;
  }

  @override
  set seriais_item(ObservableList<String> value) {
    _$seriais_itemAtom.reportWrite(value, super.seriais_item, () {
      super.seriais_item = value;
    });
  }

  late final _$qtd_informadaAtom =
      Atom(name: 'ItemControllerBase.qtd_informada', context: context);

  @override
  int get qtd_informada {
    _$qtd_informadaAtom.reportRead();
    return super.qtd_informada;
  }

  @override
  set qtd_informada(int value) {
    _$qtd_informadaAtom.reportWrite(value, super.qtd_informada, () {
      super.qtd_informada = value;
    });
  }

  late final _$ItemControllerBaseActionController =
      ActionController(name: 'ItemControllerBase', context: context);

  @override
  dynamic adicionar_serial(String add) {
    final _$actionInfo = _$ItemControllerBaseActionController.startAction(
        name: 'ItemControllerBase.adicionar_serial');
    try {
      return super.adicionar_serial(add);
    } finally {
      _$ItemControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic remover_serial(int indice) {
    final _$actionInfo = _$ItemControllerBaseActionController.startAction(
        name: 'ItemControllerBase.remover_serial');
    try {
      return super.remover_serial(indice);
    } finally {
      _$ItemControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
codigo: ${codigo},
seriais_item: ${seriais_item},
qtd_informada: ${qtd_informada}
    ''';
  }
}
