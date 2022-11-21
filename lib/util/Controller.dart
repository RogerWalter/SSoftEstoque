import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ssoft_estoque/model/Item.dart';
import 'package:ssoft_estoque/model/Serial.dart';
import 'package:ssoft_estoque/util/Util.dart';

import 'ItemController.dart';
part 'Controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store{

  @observable
  List<Item> lista_estoque_atual = [];

  @action
  preenche_lista_estoque_atual() async{
    Item itemEstoque = Item();
    lista_estoque_atual.clear();
    lista_estoque_atual = await itemEstoque.recuperar_itens_estoque();
  }

  //ENTRADA
  @observable
  ObservableList<Item> lista_itens_entrada = ObservableList();

  @action
  adiciona_item_entrada(Item item_add){
    lista_itens_entrada.add(item_add);
  }

  @action
  remover_item_entrada(int indice){
    lista_itens_entrada.removeAt(indice);
  }

  @action
  remover_todos_entrada(){
    lista_itens_entrada.clear();
  }

  //DIALOGO ENTRADA
  @observable
  String entrada_codigo_item = "";

  @observable
  String entrada_nome_item = "";

  @observable
  int entrada_qtd_item = 0;

  @observable
  String entrada_unidade_item = "";

  @observable
  int entrada_controla_serial_item = 0;

  @observable
  String entrada_retorno_scan = "";

  @observable
  Item entrada_item_lista_estoque = Item();

  @action
  buscar_item_lista_estoque(String codigo){
    int indice_busca = -1;
    indice_busca = lista_estoque_atual.indexWhere((element) => element.codigo == codigo);
    if(indice_busca > -1){//encontrado
      entrada_nome_item = lista_estoque_atual[indice_busca].nome;
      entrada_unidade_item = lista_estoque_atual[indice_busca].unidade;
      entrada_controla_serial_item = lista_estoque_atual[indice_busca].controla_serial;
      entrada_item_lista_estoque = lista_estoque_atual[indice_busca];
    }
    else{//não encontrado
      entrada_nome_item = "ITEM NÃO LOCALIZADO";
      entrada_unidade_item = "";
      entrada_controla_serial_item = 0;
    }
  }

  @observable
  bool parametro_camera = false;

  @observable
  bool entrada_dialogo_visible = true;

  //BAIXA
  @observable
  ObservableList<Item> lista_itens_baixa = ObservableList();

  @action
  adiciona_item_baixa(Item item_add){
    lista_itens_baixa.add(item_add);
  }

  @action
  remover_item_baixa(int indice){
    lista_itens_baixa.removeAt(indice);
  }

  @action
  remover_todos_baixa(){
    lista_itens_baixa.clear();
    lista_seriais_itens_baixa.clear();
  }

  @observable
  bool baixa_dialogo_visible = true;

  @observable
  bool baixa_parametro_camera = false;

  @observable
  Item baixa_item_lista_estoque = Item();

  @action
  baixa_buscar_item_lista_estoque(String codigo){
    int indice_busca = -1;
    indice_busca = lista_estoque_atual.indexWhere((element) => element.codigo == codigo);
    if(indice_busca > -1){//encontrado
      baixa_item_lista_estoque = lista_estoque_atual[indice_busca];
    }
    else{//não encontrado
      baixa_item_lista_estoque.nome = "ITEM NÃO LOCALIZADO";
      baixa_item_lista_estoque.unidade = "";
      baixa_item_lista_estoque.controla_serial = 0;
      baixa_item_lista_estoque.qtd = 0;
      baixa_item_lista_estoque.codigo = "";
    }
  }
  @observable
  String baixa_retorno_scan = "";

  @observable
  String baixa_texto_campo_imagem = "";

  @observable
  Color baixa_cor_texto_campo_imagem = Util().cor_accent;

  @action
  baixa_altera_cor_campo_imagem(bool parametro){
    if(parametro)
      baixa_cor_texto_campo_imagem = Colors.green;
    else
      baixa_cor_texto_campo_imagem = Util().cor_accent;
  }

  //COLETAR SERIAIS
  @observable
  bool serial_parametro_camera = false;

  @observable
  ObservableList<ItemController> lista_seriais_itens_baixa = ObservableList();

  @action
  remover_serial_item_baixa(int indice_lista_seriais, int indice_lista_interna_seriais){
    lista_seriais_itens_baixa[indice_lista_seriais].remover_serial(indice_lista_interna_seriais);
  }

  @observable
  bool serial_parametro_coleta_finalizada = false; //se o usuario cancelar a operação no meio, é setado para false para que o obrigue a finalizar a coleta ou excluir os itens


  //ESTOQUE ATUAL
  @observable
  ObservableList<Item> lista_estoque_filtrada = ObservableList();

  @observable
  bool estoque_parametro_filtro = false;

  @observable
  bool estoque_parametro_visibilidade_filtro = true;

  @action
  altera_parametro_filtro(bool novo_valor){
    estoque_parametro_filtro = novo_valor;
  }

  @action
  altera_parametro_visibilidade_filtro(bool novo_valor){
    estoque_parametro_visibilidade_filtro = novo_valor;
  }

  @action
  adiciona_item_lista_filtrada(Item item){
    lista_estoque_filtrada.add(item);
  }

  @observable
  ObservableList<Item> lista_estoque_pesquisa = ObservableList();

  @action
  adiciona_item_lista_pesquisa(Item item){
    lista_estoque_pesquisa.add(item);
  }

  @observable
  bool estoque_novo_item_serial = false;

  @action
  altera_checkbox_novo_item(bool novo_valor){
    estoque_novo_item_serial = novo_valor;
  }

  @observable
  bool estoque_novo_visibile = true;
}