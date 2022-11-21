import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ssoft_estoque/tela/DialogoFinalizarEntrada.dart';
import 'package:ssoft_estoque/util/SemDados.dart';
import 'package:ssoft_estoque/util/Util.dart';
import 'package:flutter_animated_dialog/src/animated_dialog.dart';

import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/SemConexao.dart';
import 'DialogoEntrada.dart';

class Entrada extends StatefulWidget {
  const Entrada({Key? key}) : super(key: key);

  @override
  State<Entrada> createState() => _EntradaState();
}

class _EntradaState extends State<Entrada> {
  Controller controller_mobx = Controller();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }
  Util cores = Util();
  int _conexao = 1;
  @override
  Widget build(BuildContext context) {
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
          title: Text('Nova Entrada', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                    mostrar_dialogo_limpar_entrada();
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
                              mostrar_dialogo_entrada();
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
                            onTap: (){
                              /*for(Item item in controller_mobx.lista_estoque_atual){
                                  controller_mobx.adiciona_item_entrada(item);
                                }*/
                              /*for(int i = 0; i <20; i++){
                                controller_mobx.adiciona_item_entrada(controller_mobx.lista_estoque_atual[i]);
                              }*/
                              verificar_conexao();
                              controller_mobx.entrada_dialogo_visible = true;
                              mostrar_dialogo_finalizar_entrada();
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Finalizar Entrada",
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
                  if(controller_mobx.lista_itens_entrada.length > 0)
                    Expanded(
                        child: ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: cores.laranja_teccel.withOpacity(0.20),
                                child: ListView.builder(
                                  itemCount: controller_mobx.lista_itens_entrada.length,
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
                                                  controller_mobx.lista_itens_entrada[index].codigo,
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
                                                      controller_mobx.lista_itens_entrada[index].nome,
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
                                                      controller_mobx.lista_itens_entrada[index].qtd.toString() + " " + controller_mobx.lista_itens_entrada[index].unidade,
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
  mostrar_dialogo_entrada(){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: DialogoEntrada()
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }
  mostrar_dialogo_finalizar_entrada(){
    if(controller_mobx.lista_itens_entrada.length == 0){
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
            child: DialogoFinalizarEntrada()
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
                            "Deseja realmente remover este item desta entrada?",
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
                                          controller_mobx.remover_item_entrada(indice);
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

  mostrar_dialogo_limpar_entrada(){
    if(controller_mobx.lista_itens_entrada.length == 0){
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
                            "Deseja realmente remover todos os itens desta entrada?",
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
                                          controller_mobx.remover_todos_entrada();
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
}
