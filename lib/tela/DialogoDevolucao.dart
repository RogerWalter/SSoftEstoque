import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/ItemController.dart';
import '../util/Util.dart';
class DialogoDevolucao extends StatefulWidget {
  const DialogoDevolucao({Key? key}) : super(key: key);

  @override
  State<DialogoDevolucao> createState() => _DialogoDevolucaoState();
}

class _DialogoDevolucaoState extends State<DialogoDevolucao> {
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
    return SingleChildScrollView(
      child: Column(
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
                    child: Icon(Icons.add, color: cores.cor_app_bar, size: 50,),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Observer(
                              builder: (_){
                                return Container(
                                    height: 25,
                                    child: Switch(
                                      value: controller_mobx.devolucao_parametro_camera,
                                      activeColor: cores.laranja_teccel,
                                      onChanged: (bool value){
                                        controller_mobx.devolucao_parametro_camera = value;
                                      },
                                    )
                                );
                              }
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
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
                                onChanged: (content){
                                  if(content.length == 9){
                                    controller_mobx.devolucao_buscar_item_lista_estoque(content);
                                    _controller_nome.text = controller_mobx.devolucao_item_lista_estoque.nome;
                                    _controller_unidade.text = controller_mobx.devolucao_item_lista_estoque.unidade;
                                    if(_controller_unidade.text != ""){
                                      _foco_qtd.requestFocus();
                                    }
                                  }
                                },
                                onTap: (){
                                  _controller_nome.text = "";
                                  _controller_unidade.text = "";
                                  _controller_qtd.text = "";
                                },
                                onSubmitted: (content){
                                  if(content.length == 9){
                                    controller_mobx.devolucao_buscar_item_lista_estoque(content);
                                    _controller_nome.text = controller_mobx.devolucao_item_lista_estoque.nome;
                                    _controller_unidade.text = controller_mobx.devolucao_item_lista_estoque.unidade;
                                    if(_controller_unidade.text != ""){
                                      _foco_qtd.requestFocus();
                                    }
                                  }
                                },
                              ),
                            ),
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
                          Expanded(
                            child: Container(
                              height: 50,
                              child: TextField(
                                controller: _controller_qtd,
                                focusNode: _foco_qtd,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                maxLength: 6,
                                //enableInteractiveSelection: false,
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
                                  labelText: "Quantidade",
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
                                  salvar_item(context);
                                },
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 16)),
                          Observer(
                              builder: (_){
                                return Container(
                                  height: 50,
                                  width: 50,
                                  child: TextField(
                                    enabled: false,
                                    controller: _controller_unidade,
                                    focusNode: _foco_unidade,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
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
                                      labelText: "U.M.",
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
                                );
                              }
                          )
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
                                        salvar_item(context);
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
      ),
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
    if(barcodeScanRes == "-1")
      return;
    controller_mobx.devolucao_retorno_scan = await barcodeScanRes;
    _controller_codigo.text = await controller_mobx.devolucao_retorno_scan;
    if(_controller_codigo.text.length == 9){
      await controller_mobx.devolucao_buscar_item_lista_estoque(_controller_codigo.text);
      _controller_nome.text = controller_mobx.devolucao_item_lista_estoque.nome;
      _controller_unidade.text = controller_mobx.devolucao_item_lista_estoque.unidade;
      if(_controller_unidade.text != ""){
        _foco_qtd.requestFocus();
        _controller_qtd.text = "";
      }
    }
  }
  salvar_item(BuildContext thiscontext){
    if(_controller_codigo.text.isEmpty || _controller_codigo.text.length < 9
        || _controller_qtd.text.isEmpty || int.parse(_controller_qtd.text) <= 0
        || _controller_unidade.text.isEmpty){
      //preenchimento incorreto
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Preenchimento dos dados incorretos. Verifique e tente novamente.',
        duration: Duration(seconds: 2),
      ).show(context);
    }
    else{
      Item item_add = Item();
      item_add.nome = _controller_nome.text;
      item_add.codigo = _controller_codigo.text;
      item_add.qtd = int.parse(_controller_qtd.text);
      item_add.unidade = _controller_unidade.text;
      item_add.controla_serial = controller_mobx.devolucao_item_lista_estoque.controla_serial;
      if(item_add.controla_serial == 1){
        //adicionamos na lista de seriais para coletar o serial depois
        ItemController serial_add = ItemController();
        serial_add.codigo = item_add.codigo;
        serial_add.qtd_informada = item_add.qtd;
        controller_mobx.devolucao_lista_seriais_itens.add(serial_add);
      }
      controller_mobx.adiciona_item_devolucao(item_add);
      if(controller_mobx.devolucao_parametro_camera){
        scan_codigo();
      }
      else{
        Navigator.of(context).pop();
      }
    }
  }
}
