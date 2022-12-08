import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssoft_estoque/model/DadosSeparacao.dart';
import 'package:ssoft_estoque/model/ItemSeparacao.dart';

import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/SemConexao.dart';
import '../util/Util.dart';
import '../util/WidgetProgress.dart';
import 'Main.dart';

class DialogoSepararItens extends StatefulWidget {
  const DialogoSepararItens({Key? key}) : super(key: key);

  @override
  State<DialogoSepararItens> createState() => _DialogoSepararItensState();
}

class _DialogoSepararItensState extends State<DialogoSepararItens> {

  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();

  Util cores = Util();
  Controller controller_mobx = Controller();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _foco_nome.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    controller_mobx.separacao_dialogo_visible = true;
    return Observer(
        builder: (_){
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: controller_mobx.separacao_dialogo_visible,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                            image: AssetImage('images/wallpaper.png'),
                            //colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.75), BlendMode.modulate,),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.assignment_rounded, color: cores.cor_app_bar, size: 50,),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Esta ação irá gerar uma pré-baixa, que poderá ser efetivada posteriormente. Se deseja continuar, informe o nome do técnico que solicitou estes materiais e confirme",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      child: TextField(
                                        controller: _controller_nome,
                                        focusNode: _foco_nome,
                                        keyboardType: TextInputType.name,
                                        textCapitalization: TextCapitalization.characters,
                                        textInputAction: TextInputAction.done,
                                        cursorColor: cores.cor_app_bar,
                                        style: TextStyle(
                                            color: cores.cor_app_bar,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),
                                        decoration: InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          counterText: "",
                                          labelText: "Técnico",
                                          labelStyle: TextStyle(color: cores.laranja_teccel, fontWeight: FontWeight.normal),
                                          fillColor: Colors.transparent,
                                          hoverColor: cores.cor_app_bar,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2, color: cores.cor_app_bar),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 2, color: cores.laranja_teccel),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        onSubmitted: (content){

                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          border: Border.all(
                                              color: cores.laranja_teccel,
                                              width: 2
                                          ),
                                        ),
                                        child: Material(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          child: InkWell(
                                              splashColor: cores.laranja_teccel.withOpacity(0.25),
                                              hoverColor: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              onTap: (){
                                                Navigator.of(context).pop();
                                              },
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14
                                                  ),
                                                ),
                                              )
                                          ),
                                        )
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 16)),
                                  Expanded(
                                    child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          border: Border.all(
                                              color: cores.laranja_teccel,
                                              width: 2
                                          ),
                                        ),
                                        child: Material(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          child: InkWell(
                                              splashColor: cores.laranja_teccel.withOpacity(0.25),
                                              hoverColor: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              onTap: (){
                                                //validamos e salvamos os dados
                                                salvar_nova_separacao();
                                              },
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Salvar",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14
                                                  ),
                                                ),
                                              )
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  salvar_nova_separacao() async{
    if(_controller_nome.text.isEmpty){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Existem dados obrigatórios não preenchidos. Verifique e tente novamente.',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    else{
      int conexao = await cores.verificar_conexao();
      if(conexao == 0){//sem conexão
        mostrar_sem_conexao();
      }
      else{
        controller_mobx.alterar_separacao_dialogo_visible(false);
        mostrar_progress();
        await salvar_separacao_firebase();
        await controller_mobx.preenche_lista_estoque_atual();
        controller_mobx.remover_todos_baixa();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller_mobx.alterar_separacao_dialogo_visible(true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Main()
            )
        );
      }
    }
  }
  salvar_separacao_firebase() async{
    DateTime now = DateTime.now();
    String data_formatada = DateFormat('dd/MM/yyyy').format(now);
    String data_nome_arquivo = DateFormat('yyyyMMdd-kkmmss').format(now);
    String id_registro = "SEP-" + data_nome_arquivo + "-" + _controller_nome.text.toUpperCase();
    //registramos todos os itens da lista de baixa
    List<ItemSeparacao> itens_separacao = [];
    for(Item item in controller_mobx.lista_itens_baixa){
      ItemSeparacao registro_saida = ItemSeparacao();
      registro_saida.codigo = item.codigo;
      registro_saida.nome = item.nome;
      registro_saida.qtd = item.qtd;
      registro_saida.unidade = item.unidade;
      registro_saida.controla_serial = item.controla_serial;
      if(item.controla_serial == 1){
        int indice = -1;
        indice = controller_mobx.lista_seriais_itens_baixa.indexWhere((element) => element.codigo == item.codigo);
        for(int i = 0; i < item.qtd; i++){
          String serial = controller_mobx.lista_seriais_itens_baixa[indice].seriais_item[i] + "-";
          registro_saida.seriais = registro_saida.seriais + serial;
        }
      }
      itens_separacao.add(registro_saida);
    }
    DadosSeparacao dados_separacao = DadosSeparacao();
    dados_separacao.identificacao = id_registro;
    dados_separacao.data = data_formatada;
    dados_separacao.tecnico = _controller_nome.text.toUpperCase();
    dados_separacao.itens = itens_separacao;
    DatabaseReference ref_dados_baixa = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("separacao").child(id_registro);
    final json = dados_separacao.toJson();
    await ref_dados_baixa.set(json);
  }

  mostrar_progress(){
    showDialog(
        barrierDismissible: false,
        barrierColor: Color(0x00ffffff),
        context: context,
        builder: (_){
          return WillPopScope(
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                    alignment: FractionalOffset.center,
                    height: 80.0,
                    padding: const EdgeInsets.all(20.0),
                    child:  Center(child: WidgetProgress(),)
                ),
              ),
              onWillPop: () async => false
          );
        }
    );
  }
  mostrar_sem_conexao(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_){
          return WillPopScope(
              child: Dialog(
                child: Wrap(
                    children:  [Center(child: SemConexao(),)]
                ),
              ),
              onWillPop: () async => false
          );
        });
  }
}
