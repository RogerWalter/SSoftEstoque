import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../util/Controller.dart';
import '../util/SemDados.dart';
import '../util/Util.dart';
class ColetarSeriais extends StatefulWidget {
  int _indice_coletar = 0;
  int _qtd_informada = 0;

  ColetarSeriais(this._indice_coletar, this._qtd_informada);

  @override
  State<ColetarSeriais> createState() => _ColetarSeriaisState();
}

class _ColetarSeriaisState extends State<ColetarSeriais> {
  TextEditingController _controller_codigo = TextEditingController();
  FocusNode _foco_codigo = FocusNode();

  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();

  TextEditingController _controller_qtd = TextEditingController();
  FocusNode _foco_qtd = FocusNode();

  TextEditingController _controller_unidade = TextEditingController();
  FocusNode _foco_unidade = FocusNode();

  Util cores = Util();
  Controller controller_mobx = Controller();

  List<String> lista_controla_serial = [];

  double altura_lista = 0;

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
  }
  @override
  Widget build(BuildContext context) {
    controller_mobx.baixa_buscar_item_lista_estoque(controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].codigo);
    _controller_codigo.text = controller_mobx.baixa_item_lista_estoque.codigo;
    _controller_nome.text = controller_mobx.baixa_item_lista_estoque.nome;
    _controller_qtd.text = widget._qtd_informada.toString();
    altura_lista = MediaQuery.of(context).size.height/4;
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
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        child: Text(
                          "Coleta de Serial",
                        ),
                      )
                  )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Observer(
                                    builder: (_){
                                      return Container(
                                          height: 25,
                                          child: Switch(
                                            value: controller_mobx.serial_parametro_camera,
                                            activeColor: cores.laranja_teccel,
                                            onChanged: (bool value){
                                              controller_mobx.serial_parametro_camera = value;
                                            },
                                          )
                                      );
                                    }
                                ),
                                Padding(padding: EdgeInsets.only(left: 2)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Abrir câmera automaticamente",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                        Padding(padding: EdgeInsets.only(left: 16)),
                        Observer(
                            builder: (_){
                              return Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    child: InkWell(
                                        splashColor: cores.laranja_teccel.withOpacity(0.25),
                                        hoverColor: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        onTap: (){
                                          //Abrimos a câmera para escanear
                                          scan_codigo();
                                          /*for(int i = 0; i < 3; i++){
                                            controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].adicionar_serial("ZTEGC00123" + i.toString());
                                          }*/
                                        },
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.camera_alt_rounded, color: cores.cor_app_bar)
                                        )
                                    ),
                                  )
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
                        Observer(
                            builder: (_){
                              return Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    enabled: false,
                                    controller: _controller_codigo,
                                    focusNode: _foco_codigo,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
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
                        Observer(
                            builder: (_){
                              return Expanded(
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    enabled: false,
                                    controller: _controller_nome,
                                    focusNode: _foco_nome,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
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
                    padding: EdgeInsets.only(top: 8, bottom: 16),
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
                                    enabled: false,
                                    controller: _controller_qtd,
                                    focusNode: _foco_qtd,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
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
                                      labelText: "Qtd de Seriais Esperada",
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
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.zero,
                    child: Observer(
                      builder: (_){
                        return Container(
                          height: altura_lista,
                          child: Column(
                            children: <Widget>[
                              if(controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].seriais_item.length > 0)
                                Expanded(
                                    child: ScrollConfiguration(
                                        behavior: ScrollBehavior(),
                                        child: GlowingOverscrollIndicator(
                                            axisDirection: AxisDirection.down,
                                            color: cores.laranja_teccel.withOpacity(0.20),
                                            child: ListView.builder(
                                              itemCount: controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].seriais_item.length,
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
                                                              child: Image.asset("images/barcode.png", height: 24,),
                                                          ),
                                                          title: Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                                            child: Center(
                                                                child: Text(
                                                                  controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].seriais_item[index],
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: (18),
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                            )
                                                          ),
                                                          trailing: IconButton(
                                                            splashColor: cores.laranja_teccel.withOpacity(0.25),
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
                          ),
                        );
                      },
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
                                      controller_mobx.serial_parametro_coleta_finalizada = false;
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
                                      finalizar_coleta_item_atual();
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
      ],
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
                            "Deseja realmente remover este serial?",
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
                                          controller_mobx.remover_serial_item_baixa(widget._indice_coletar, indice);
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
  Future<void> scan_codigo() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Cancelar', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Erro';
    }
    if (!mounted) return;
    salvar_item(barcodeScanRes);
  }
  salvar_item(String barcodeScanRes){
    controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].adicionar_serial(barcodeScanRes);
  }

  finalizar_coleta_item_atual(){
    if(controller_mobx.lista_seriais_itens_baixa[widget._indice_coletar].seriais_item.length != widget._qtd_informada){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Quantidade de seriais informada é divergente da quantidade de seriais esperada. Verifique se a quantidades escaneada e a quantide de equipamento que está saindo é a mesma e tente novamente',
        duration: Duration(seconds: 5),
      ).show(context);
    }
    else{
      mostrar_dialogo_confirmar_seriais_item();
    }
  }
  mostrar_dialogo_confirmar_seriais_item(){
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
                            "Confirmar Seriais?",
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
                            "Deseja realmente confirmar os seriais para este item?\nApós confirmado, não será possível alterar.",
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
                                            "Vou verificar!",
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
                                          controller_mobx.serial_parametro_coleta_finalizada = true;
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Sim, estão corretos!",
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
