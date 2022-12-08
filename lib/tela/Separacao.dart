import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../util/Controller.dart';
import '../util/SemConexao.dart';
import '../util/SemDados.dart';
import '../util/Util.dart';
import 'Baixa.dart';

class Separacao extends StatefulWidget {
  const Separacao({Key? key}) : super(key: key);

  @override
  State<Separacao> createState() => _SeparacaoState();
}

class _SeparacaoState extends State<Separacao> {
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
            title: Text('Separações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                      mostrar_dialogo_limpar_separacoes();
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: cores.cor_accent,)
                ),
              )
            ],
          ),
          body: Padding(
              padding: EdgeInsets.all(8),
              child: Observer(
                builder: (_){
                  return Column(
                    children: <Widget>[
                      if(controller_mobx.lista_separacoes.length > 0)
                        Expanded(
                            child: ScrollConfiguration(
                                behavior: ScrollBehavior(),
                                child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: cores.laranja_teccel.withOpacity(0.20),
                                    child: ListView.builder(
                                      itemCount: controller_mobx.lista_separacoes.length,
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
                                                mostrar_dialogo_efetivar_separacao(index);
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
                                                      controller_mobx.lista_separacoes[index].tecnico,
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
                                                          controller_mobx.lista_separacoes[index].data,
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
                                                          (controller_mobx.lista_separacoes[index].itens.length > 1) ? controller_mobx.lista_separacoes[index].itens.length.toString() + " itens" : controller_mobx.lista_separacoes[index].itens.length.toString() + " item",
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
  mostrar_dialogo_limpar_separacoes(){
    if(controller_mobx.lista_separacoes.length == 0){
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
                            "Apagar todas as separações",
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
                            "Deseja realmente remover todas as separações realizadas?",
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
                                        onPressed: () async{
                                          int conexao = await cores.verificar_conexao();
                                          if(conexao == 0){//sem conexão
                                            mostrar_sem_conexao();
                                          }
                                          else{
                                            controller_mobx.remover_todas_separacoes();
                                            Navigator.of(context).pop();
                                          }
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
                            "Remover Separação",
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
                            "Deseja realmente remover esta separação?",
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
                                        onPressed: () async{
                                          int conexao = await cores.verificar_conexao();
                                          if(conexao == 0){//sem conexão
                                            mostrar_sem_conexao();
                                          }
                                          else{
                                            controller_mobx.remover_item_separacao(indice);
                                            Navigator.of(context).pop();
                                          }
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
  mostrar_dialogo_efetivar_separacao(int indice){
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
                            "Efetivar Separação",
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
                            "Ao confirmar, você estará gerando uma baixa a partir dos itens desta separação. Deseja continuar?",
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
                                        onPressed: () async{
                                          int conexao = await cores.verificar_conexao();
                                          if(conexao == 0){//sem conexão
                                            mostrar_sem_conexao();
                                          }
                                          else{
                                            controller_mobx.efetivar_separacao(indice);
                                            controller_mobx.alterar_parametro_origem(true);
                                            controller_mobx.alterar_arametro_houve_alteracao(false);
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Baixa()
                                                )
                                            );
                                          }
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
