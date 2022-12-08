import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ssoft_estoque/model/Item.dart';
import 'package:ssoft_estoque/model/ItemSeparacao.dart';
import 'package:ssoft_estoque/model/Serial.dart';
import 'package:ssoft_estoque/util/Util.dart';

import '../model/DadosSeparacao.dart';
import 'ItemController.dart';
part 'Controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store{

  @observable
  String estoque_atual = "SBS";

  @observable
  List<Item> lista_estoque_atual = [];

  @observable
  int ultima_chave_entrada = 0;
  @action
  alterar_ultima_chave_entrada(int valor){
    ultima_chave_entrada = valor;
  }

  @observable
  int ultima_chave_baixa = 0;
  @action
  alterar_ultima_chave_baixa (int valor){
    ultima_chave_baixa = valor;
  }

  @observable
  int ultima_chave_devolucao = 0;
  @action
  alterar_ultima_chave_devolucao(int valor){
    ultima_chave_devolucao = valor;
  }

  @action
  preenche_lista_estoque_atual() async{
    Item itemEstoque = Item();
    lista_estoque_atual.clear();
    lista_estoque_atual = await itemEstoque.recuperar_itens_estoque(estoque_atual);
    lista_estoque_itens_devolucao = await itemEstoque.recuperar_itens_devolucao(estoque_atual);
    ultima_chave_entrada = await itemEstoque.recupera_ultima_chave_entrada(estoque_atual);
    ultima_chave_baixa = await itemEstoque.recupera_ultima_chave_baixa(estoque_atual);
    ultima_chave_devolucao = await itemEstoque.recupera_ultima_chave_devolucao(estoque_atual);
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
  bool parametro_origem = false; //usado para verificar se ao abrir a tela, viemos do menu ou da tela de separações

  @action
  alterar_parametro_origem(bool valor){
    parametro_origem = valor;
  }

  @observable
  ObservableList<Item> lista_itens_baixa = ObservableList();

  @action
  adiciona_item_baixa(Item item_add){
    lista_itens_baixa.add(item_add);
  }

  @action
  remover_item_baixa(int indice, int indice_seriais){
    lista_itens_baixa.removeAt(indice);
    if(indice_seriais != -1)
      lista_seriais_itens_baixa.removeAt(indice_seriais);
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

  //DEVOLUCAO
  @observable
  List<Item> lista_estoque_itens_devolucao = [];

  @observable
  ObservableList<Item> lista_itens_devolucao = ObservableList();

  @action
  adiciona_item_devolucao(Item item_add){
    lista_itens_devolucao.add(item_add);
  }

  @action
  remover_item_devolucao(int indice, int indice_seriais){
    lista_itens_devolucao.removeAt(indice);
    devolucao_lista_seriais_itens.removeAt(indice_seriais);
  }

  @action
  remover_todos_devolucao(){
    lista_itens_devolucao.clear();
    devolucao_lista_seriais_itens.clear();
  }

  @observable
  bool devolucao_serial_parametro_camera = false;

  @observable
  ObservableList<ItemController> devolucao_lista_seriais_itens = ObservableList();

  @action
  devolucao_remover_serial(int indice_lista_seriais, int indice_lista_interna_seriais){
    devolucao_lista_seriais_itens[indice_lista_seriais].remover_serial(indice_lista_interna_seriais);
  }

  @observable
  bool devolucao_serial_parametro_coleta_finalizada = false; //se o usuario cancelar a operação no meio, é setado para false para que o obrigue a finalizar a coleta ou excluir os itens

  @observable
  bool devolucao_dialogo_visible = true;

  @observable
  bool devolucao_parametro_camera = false;

  @observable
  String devolucao_retorno_scan = "";

  @observable
  Item devolucao_item_lista_estoque = Item();

  @action
  devolucao_buscar_item_lista_estoque(String codigo){
    int indice_busca = -1;
    indice_busca = lista_estoque_itens_devolucao.indexWhere((element) => element.codigo == codigo);
    if(indice_busca > -1){//encontrado
      devolucao_item_lista_estoque = lista_estoque_itens_devolucao[indice_busca];
    }
    else{//não encontrado
      devolucao_item_lista_estoque.nome = "ITEM NÃO LOCALIZADO";
      devolucao_item_lista_estoque.unidade = "";
      devolucao_item_lista_estoque.controla_serial = 0;
      devolucao_item_lista_estoque.qtd = 0;
      devolucao_item_lista_estoque.codigo = "";
    }
  }

  //SEPARAÇÃO DE ITENS
  @observable
  ObservableList<DadosSeparacao> lista_separacoes = ObservableList();

  @observable
  bool separacao_dialogo_visible = true;

  @action
  alterar_separacao_dialogo_visible(bool valor){
    separacao_dialogo_visible = valor;
  }

  @observable
  ObservableList<Item> lista_itens_separacao = ObservableList();

  @observable
  ObservableList<ItemController> lista_seriais_itens_separacao = ObservableList();

  @observable
  String separacao_tecnico = "";

  @action
  altera_tecnico_separacao(String valor){
    separacao_tecnico = valor;
  }

  @observable
  String separacao_identificacao = "";

  @action
  altera_identificacao_separacao(String valor){
    separacao_identificacao = valor;
  }

  @action
  preenche_lista_separacoes() async{
    DadosSeparacao item = DadosSeparacao();
    lista_separacoes.clear();
    lista_separacoes = await item.recuperar_separacoes(estoque_atual);
  }

  @action
  remover_todas_separacoes() async{
    DadosSeparacao item = DadosSeparacao();
    await item.remover_todas_separacoes(estoque_atual);
    lista_separacoes.clear();
  }

  @action
  remover_item_separacao(int indice) async{
    DadosSeparacao item = DadosSeparacao();
    String identificacao = lista_separacoes[indice].identificacao;
    await item.remover_separacao(estoque_atual, identificacao);
    lista_separacoes.removeAt(indice);
  }

  @action
  efetivar_separacao(int indice) async{
    alterar_parametro_origem(true);
    DadosSeparacao separacao_atual = DadosSeparacao();
    separacao_atual = lista_separacoes[indice];
    lista_itens_baixa.clear();
    lista_seriais_itens_baixa.clear();
    separacao_identificacao = separacao_atual.identificacao;
    separacao_tecnico = separacao_atual.tecnico;
    for(int i = 0; i < separacao_atual.itens.length; i++){
      Item adicionar = Item();
      adicionar.codigo = separacao_atual.itens[i].codigo;
      adicionar.nome = separacao_atual.itens[i].nome;
      adicionar.qtd = separacao_atual.itens[i].qtd;
      adicionar.unidade = separacao_atual.itens[i].unidade;
      adicionar.controla_serial = separacao_atual.itens[i].controla_serial;
      adiciona_item_baixa(adicionar);
      if(separacao_atual.itens[i].controla_serial == 1){
        ItemController serial_add = ItemController();
        serial_add.codigo = separacao_atual.itens[i].codigo;
        serial_add.qtd_informada = separacao_atual.itens[i].qtd;
        lista_seriais_itens_baixa.add(serial_add);
        int indice_busca = -1;
        indice_busca = lista_seriais_itens_baixa.indexWhere((element) => element.codigo == serial_add.codigo);
        List <String> serial = [];
        serial = separacao_atual.itens[i].seriais.split("-");
        for(String serial_split in serial){
          if(serial_split.isNotEmpty && serial_split != "")
            lista_seriais_itens_baixa[indice_busca].seriais_item.add(serial_split);
        }
      }
    }
  }

  @observable
  bool parametro_houve_alteracao = false; //se não houve alteração, não é preciso validar novamente os seriais vindos da tela de separação
                                          //se houver alteração nos itens, será necessário abrir a tela para conferencia de seriais novamente.
  @action
  alterar_arametro_houve_alteracao(bool valor){
    parametro_houve_alteracao = valor;
  }


}