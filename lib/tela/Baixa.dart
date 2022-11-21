import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ssoft_estoque/model/Serial.dart';
import 'package:ssoft_estoque/tela/ColetarSeriais.dart';

import '../util/Controller.dart';
import '../util/SemConexao.dart';
import '../util/SemDados.dart';
import '../util/Util.dart';
import 'DialogoBaixa.dart';
import 'DialogoFinalizarBaixa.dart';

class Baixa extends StatefulWidget {
  const Baixa({Key? key}) : super(key: key);

  @override
  State<Baixa> createState() => _BaixaState();
}

class _BaixaState extends State<Baixa> {
  Controller controller_mobx = Controller();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }

  Util cores = Util();
  int _conexao = 1;
  double largura_dialogo = 0;
  @override
  Widget build(BuildContext context) {
    largura_dialogo = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/wallpaper.png'),
              //colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.75), BlendMode.modulate,),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Nova Baixa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            backgroundColor: cores.cor_app_bar,
            automaticallyImplyLeading: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: (){
                      mostrar_dialogo_limpar_baixa();
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: cores.cor_accent,)
                ),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
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
                                mostrar_dialogo_baixa();
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Adicionar Item",
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
                          onTap: () async{
                            verificar_conexao();
                            if(controller_mobx.lista_seriais_itens_baixa.length > 0){
                              for(int i=0; i<controller_mobx.lista_seriais_itens_baixa.length; i++){
                                await showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Dialog(
                                          insetPadding: EdgeInsets.only(left: 2, right: 2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                          child: ColetarSeriais(i, controller_mobx.lista_seriais_itens_baixa[i].qtd_informada)
                                      );
                                  },
                                  animationType: DialogTransitionType.fadeScale,
                                  curve: Curves.easeOutQuint,
                                  duration: Duration(milliseconds: 500),
                                );
                                if(!controller_mobx.serial_parametro_coleta_finalizada){
                                  break;
                                }
                              }
                              if(controller_mobx.serial_parametro_coleta_finalizada){
                                controller_mobx.baixa_dialogo_visible = true;
                                mostrar_dialogo_finalizar_baixa();
                              }
                            }
                            else{
                              controller_mobx.baixa_dialogo_visible = true;
                              mostrar_dialogo_finalizar_baixa();
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Finalizar Baixa",
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
          body: Padding(
              padding: EdgeInsets.all(8),
              child: Observer(
                builder: (_){
                  return Column(
                    children: <Widget>[
                      if(controller_mobx.lista_itens_baixa.length > 0)
                        Expanded(
                            child: ScrollConfiguration(
                                behavior: ScrollBehavior(),
                                child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: cores.laranja_teccel.withOpacity(0.20),
                                    child: ListView.builder(
                                      itemCount: controller_mobx.lista_itens_baixa.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (_, index){
                                        return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: InkWell(
                                              splashColor: cores.laranja_teccel.withOpacity(0.25),
                                              hoverColor: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              onTap: (){

                                              },
                                              child: ListTile(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  tileColor: Colors.white,
                                                  leading:  CircleAvatar(
                                                      backgroundColor: Colors.black,
                                                      child: Icon(Icons.check, color: Colors.white,)
                                                  ),
                                                  title: Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                                    child: Text(
                                                      controller_mobx.lista_itens_baixa[index].codigo,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: (14),
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                        child: Text(
                                                          controller_mobx.lista_itens_baixa[index].nome,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            color: Colors.black54,
                                                            fontSize: (12),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(0, 2, 0, 4),
                                                        child: Text(
                                                          controller_mobx.lista_itens_baixa[index].qtd.toString() + " " + controller_mobx.lista_itens_baixa[index].unidade,
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: (14),
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red,),
                                                    onPressed: () {
                                                      mostrar_dialogo_remover_item(index);
                                                    },
                                                  )
                                              ),
                                            )
                                        );
                                      },
                                    )
                                )
                            )
                        )
                      else
                        Expanded(child: SemDados())
                    ],
                  );
                },
              )
          )
      ),
    );
  }
  mostrar_dialogo_limpar_baixa(){
    if(controller_mobx.lista_itens_baixa.length == 0){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Não há dados para excluir',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: Wrap(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8,8,8,4),
                          child: Text(
                            "Apagar todos os itens",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cores.cor_app_bar
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8,4,8,4),
                          child: Text(
                            "Deseja realmente remover todos os itens desta baixa?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: cores.cor_app_bar
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(8,4,8,8),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Não",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: cores.laranja_teccel,
                                            ),
                                            textAlign: TextAlign.center
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child: TextButton(
                                        onPressed: (){
                                          controller_mobx.remover_todos_baixa();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Sim",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: cores.laranja_teccel
                                            ),
                                            textAlign: TextAlign.center
                                        ),
                                      )
                                  )
                                ]
                            )
                        ),
                      )
                    ]
                )
              ],
            )
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }
  mostrar_dialogo_baixa(){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: DialogoBaixa()
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }
  verificar_conexao() async{
    Util verif = Util();
    _conexao = await  verif.verificar_conexao();
    if(_conexao == 0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SemConexao()
          )
      );
    }
    else{
      return;
    }
  }
  mostrar_dialogo_finalizar_baixa(){
    if(controller_mobx.lista_itens_baixa.length == 0){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Não há dados inseridos',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
            insetPadding: EdgeInsets.only(left: 2, right: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: DialogoFinalizarBaixa()
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }
  mostrar_dialogo_remover_item(int indice){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: Wrap(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8,8,8,4),
                          child: Text(
                            "Remover Item",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cores.cor_app_bar
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8,4,8,4),
                          child: Text(
                            "Deseja realmente remover este item desta baixa?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: cores.cor_app_bar
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(8,4,8,8),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Não",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: cores.laranja_teccel,
                                            ),
                                            textAlign: TextAlign.center
                                        ),
                                      )
                                  ),
                                  Expanded(
                                      child: TextButton(
                                        onPressed: (){
                                          controller_mobx.remover_item_baixa(indice);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Sim",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: cores.laranja_teccel
                                            ),
                                            textAlign: TextAlign.center
                                        ),
                                      )
                                  )
                                ]
                            )
                        ),
                      )
                    ]
                )
              ],
            )
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }
}
