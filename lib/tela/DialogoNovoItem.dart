import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/SemConexao.dart';
import '../util/Util.dart';
import '../util/WidgetProgress.dart';
class DialogoNovoItem extends StatefulWidget {
  const DialogoNovoItem({Key? key}) : super(key: key);

  @override
  State<DialogoNovoItem> createState() => _DialogoNovoItemState();
}

class _DialogoNovoItemState extends State<DialogoNovoItem> {
  TextEditingController _controller_codigo = TextEditingController();
  FocusNode _foco_codigo = FocusNode();

  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();

  TextEditingController _controller_unidade = TextEditingController();
  FocusNode _foco_unidade = FocusNode();

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
    _foco_codigo.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    controller_mobx.estoque_novo_visibile = true;
    controller_mobx.estoque_novo_item_serial = false;
    return Observer(
      builder: (_){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: AssetImage('images/wallpaper.png'),
                      //colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.75), BlendMode.modulate,),
                      fit: BoxFit.cover
                  )
              ),
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: controller_mobx.estoque_novo_visibile,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.create_rounded, color: cores.cor_app_bar, size: 50,),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    controller: _controller_codigo,
                                    focusNode: _foco_codigo,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    maxLength: 9,
                                    enableInteractiveSelection: false,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    cursorColor: cores.cor_app_bar,
                                    style: TextStyle(
                                        color: cores.cor_app_bar,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      counterText: "",
                                      labelText: "Código do Item",
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
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Observer(
                                  builder: (_){
                                    return Expanded(
                                      child: Container(
                                        height: 50,
                                        child: TextField(
                                          controller: _controller_nome,
                                          focusNode: _foco_nome,
                                          maxLines: 1,
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.characters,
                                          textInputAction: TextInputAction.next,
                                          cursorColor: cores.cor_app_bar,
                                          style: TextStyle(
                                              color: cores.cor_app_bar,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            counterText: "",
                                            labelText: "Descrição do Item",
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
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2, color: cores.cor_app_bar),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
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
                                    controller: _controller_unidade,
                                    focusNode: _foco_unidade,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    maxLength: 2,
                                    cursorColor: cores.cor_app_bar,
                                    style: TextStyle(
                                        color: cores.cor_app_bar,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      counterText: "",
                                      labelText: "Unidade de Medida",
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
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 16),
                          child:Observer(
                              builder: (_){
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        child: InputDecorator(
                                            decoration: InputDecoration(
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              counterText: "",
                                              labelText: "Controle de Serial",
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.all<Color>(cores.laranja_teccel),
                                                      value: controller_mobx.estoque_novo_item_serial,
                                                      onChanged: (bool? value){
                                                        controller_mobx.altera_checkbox_novo_item(value!);
                                                      }
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Este item controla serial?",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                      )
                                    )
                                  ],
                                );
                              }
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
                                            salvar_item();
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
              )
            )
          ],
        );
      }
    );
  }
  salvar_item() async{
    if(_controller_codigo.text.isEmpty || _controller_codigo.text.length < 9
        || _controller_nome.text.isEmpty || _controller_unidade.text.length < 2
        || _controller_unidade.text.isEmpty){
      //preenchimento incorreto
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Preenchimento dos dados incorretos. Verifique e tente novamente.',
        duration: Duration(seconds: 2),
      ).show(context);
    }
    else{
      int conexao = await cores.verificar_conexao();
      if(conexao == 0){//sem conexão
        mostrar_sem_conexao();
      }
      else{
        mostrar_dialogo_confirmar_novo_item();
      }
    }
  }

  inserir_item_firebase()async{
    controller_mobx.estoque_novo_visibile = false;
    mostrar_progress();
    Item item_add = Item();
    item_add.nome = _controller_nome.text;
    item_add.codigo = _controller_codigo.text;
    item_add.qtd = 0;
    item_add.unidade = _controller_unidade.text;
    if(controller_mobx.estoque_novo_item_serial)
      item_add.controla_serial = 1;
    else
      item_add.controla_serial = 0;
    final json = item_add.toJson();
    DatabaseReference ref = FirebaseDatabase.instance.ref("estoque").child(item_add.codigo);
    await ref.set(json);
    await controller_mobx.preenche_lista_estoque_atual();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    controller_mobx.estoque_novo_visibile = true;
  }

  mostrar_dialogo_confirmar_novo_item(){
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
                            "Confirmar Item?",
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
                            "Deseja realmente confirmar a inclusão do item abaixo?\n\n" + _controller_codigo.text + " - " + _controller_nome.text + " - " + _controller_unidade.text +"\n\nApós confirmado, não será possível alterar.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: cores.cor_app_bar,
                            ),
                            textAlign: TextAlign.center,
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
                                          inserir_item_firebase();
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

  mostrar_progress(){
    showDialog(
        barrierColor: Color(0x00ffffff),
        context: context,
        builder: (_) => new Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: new Container(
              alignment: FractionalOffset.center,
              height: 80.0,
              padding: const EdgeInsets.all(20.0),
              child:  Center(child: WidgetProgress(),)
          ),
        ));
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
