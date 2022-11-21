import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ssoft_estoque/model/DadosBaixa.dart';
import 'package:ssoft_estoque/model/RegistroBaixa.dart';

import '../firebase_options.dart';
import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/Planilha.dart';
import '../util/Util.dart';
import '../util/WidgetProgress.dart';
import 'Main.dart';
class DialogoFinalizarBaixa extends StatefulWidget {
  const DialogoFinalizarBaixa({Key? key}) : super(key: key);

  @override
  State<DialogoFinalizarBaixa> createState() => _DialogoFinalizarBaixaState();
}

class _DialogoFinalizarBaixaState extends State<DialogoFinalizarBaixa> {

  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();

  TextEditingController _controller_foto = TextEditingController();
  FocusNode _foco_foto = FocusNode();
  Planilha planilha = Planilha();
  Util cores = Util();
  Controller controller_mobx = Controller();
  Uint8List? _assinatura_gerada;
  var pdf_gerado;
  var imagem_relatorio;
  bool parametro_foto = false; //True = foto registrada e válida | false = precisa tirar a foto

  final SignatureController _controller_signature = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  @override
  void dispose() {
    _controller_signature.dispose();
    super.dispose();
  }

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
    _controller_foto.text = "Não";
    controller_mobx.baixa_altera_cor_campo_imagem(false);
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
                  visible: controller_mobx.baixa_dialogo_visible,
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
                            child: Icon(Icons.check, color: cores.cor_app_bar, size: 50,),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Preenche os campos abaixo para salvar",
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
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Observer(
                                        builder: (_){
                                          return Container(
                                            height: 50,
                                            child: TextField(
                                              enabled: false,
                                              controller: _controller_foto,
                                              focusNode: _foco_foto,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              maxLength: 9,
                                              cursorColor: cores.cor_app_bar,
                                              style: TextStyle(
                                                  color: controller_mobx.baixa_cor_texto_campo_imagem,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              decoration: InputDecoration(
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                counterText: "",
                                                labelText: "Foto Registrada?",
                                                labelStyle: TextStyle(color: cores.laranja_teccel, fontWeight: FontWeight.normal),
                                                fillColor: Colors.transparent,
                                                hoverColor: cores.cor_app_bar,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 2, color: cores.cor_app_bar),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 2, color: cores.cor_app_bar),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 2, color: cores.laranja_teccel),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
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
                                                    mostrar_dialogo_fonte_imagem();
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
                              padding: EdgeInsets.only(top: 8, bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Observer(
                                      builder: (_){
                                        return Expanded(
                                          child: Stack(
                                            children: <Widget>[
                                              InputDecorator(
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    counterText: "",
                                                    labelText: "Assinatura",
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
                                                  child: ClipRRect(
                                                    child: Signature(
                                                      key: const Key('signature'),
                                                      controller: _controller_signature,
                                                      height: 200,
                                                      backgroundColor: Colors.transparent,
                                                    ),
                                                  )
                                              ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 4),
                                                    child: IconButton(
                                                      icon: Icon(Icons.undo_rounded, color: cores.laranja_teccel,),
                                                      onPressed: (){
                                                        _controller_signature.undo();
                                                      },
                                                    ),
                                                  )
                                              ),
                                            ],
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
                                                salvar_nova_baixa();
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
  mostrar_dialogo_fonte_imagem(){
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
                            "Inserir Imagem",
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
                            "Como deseja inserir a imagem no relatório?",
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
                                          selecionar_foto();
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.image_search_rounded, color: cores.laranja_teccel,),
                                            Text(
                                                "Galeria",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: cores.laranja_teccel,
                                                ),
                                                textAlign: TextAlign.center
                                            ),
                                          ],
                                        )
                                      )
                                  ),
                                  Expanded(
                                      child: TextButton(
                                        onPressed: (){
                                          tirar_foto();
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.camera_alt_rounded, color: cores.laranja_teccel,),
                                            Text(
                                                "Câmera",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: cores.laranja_teccel,
                                                ),
                                                textAlign: TextAlign.center
                                            ),
                                          ],
                                        )
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
  tirar_foto() async{
    imagem_relatorio = null;
    parametro_foto = false;
    controller_mobx.baixa_texto_campo_imagem = "Não";
    _controller_foto.text = controller_mobx.baixa_texto_campo_imagem;
    controller_mobx.baixa_altera_cor_campo_imagem(false);
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 25
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imagem_relatorio = imageFile;
      parametro_foto = true;
      controller_mobx.baixa_texto_campo_imagem = "Sim";
      _controller_foto.text = controller_mobx.baixa_texto_campo_imagem;
      controller_mobx.baixa_altera_cor_campo_imagem(true);
    }
  }
  selecionar_foto() async{
    imagem_relatorio = null;
    parametro_foto = false;
    controller_mobx.baixa_texto_campo_imagem = "Não";
    _controller_foto.text = controller_mobx.baixa_texto_campo_imagem;
    controller_mobx.baixa_altera_cor_campo_imagem(false);
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 25
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imagem_relatorio = imageFile;
      parametro_foto = true;
      controller_mobx.baixa_texto_campo_imagem = "Sim";
      _controller_foto.text = controller_mobx.baixa_texto_campo_imagem;
      controller_mobx.baixa_altera_cor_campo_imagem(true);
    }
  }

  salvar_nova_baixa()async{
    if(_controller_signature.isEmpty || _controller_nome.text.isEmpty || imagem_relatorio == null || _controller_foto.text == "Não"){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Existem dados obrigatórios não preenchidos. Verifique e tente novamente.',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    else{
      controller_mobx.baixa_dialogo_visible = false;
      mostrar_progress();
      await gerar_imagem_assinatura(context);
      await gerar_pdf();
      await salvar_baixa_firebase();
      await controller_mobx.preenche_lista_estoque_atual();
      controller_mobx.remover_todos_baixa();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Main()
          )
      );
    }
  }
  Future<void> gerar_imagem_assinatura(BuildContext context) async {
    final Uint8List? data =
    await _controller_signature.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }
    if (!mounted) return;
    _assinatura_gerada = data;
  }

  Future<void> gerar_pdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final image = await imageFromAssetBundle('images/logo.png');
    DateTime now = DateTime.now();
    String data_relatorio = DateFormat('dd/MM/yyyy kk:mm:ss').format(now);
    const tableHeaders = ['CÓDIGO', 'DESCRIÇÃO', 'QTD', 'U.M.'];

    //ajusta a lista da baixa inserindo os seriais se houver
    List<Item> lista_itens_baixa_pdf = [];
    for(Item item in controller_mobx.lista_itens_baixa){
      if(item.controla_serial == 1){
        lista_itens_baixa_pdf.add(item);
        int indice = -1;
        indice = controller_mobx.lista_seriais_itens_baixa.indexWhere((element) => element.codigo == item.codigo);
        for(int i = 0; i < item.qtd; i++){
          Item serial = Item();
          serial.codigo = "";
          serial.nome = controller_mobx.lista_seriais_itens_baixa[indice].seriais_item[i];
          serial.qtd = 1;
          serial.unidade = item.unidade;
          serial.controla_serial = 0;
          lista_itens_baixa_pdf.add(serial);
        }
      }
      else{
        lista_itens_baixa_pdf.add(item);
      }
    }

    pdf.addPage(
        pw.MultiPage(
            maxPages: 10000,
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(8),
            build: (context) => [
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Container(
                  width: double.infinity,
                  height: 70,
                  child: pw.Image(image, fit: pw.BoxFit.scaleDown),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(top: 16, bottom: 8),
                  child: pw.Container(
                    child: pw.FittedBox(
                      child: pw.Text("Relatório de Entrega de Materiais", style: pw.TextStyle(font: font, fontSize: 28)),
                    ),
                  ),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(top: 8, bottom: 8),
                  child: pw.SizedBox(
                    child: pw.FittedBox(
                      child: pw.Text("Técnico: " + _controller_nome.text + "\nData: " + data_relatorio,
                          style: pw.TextStyle(font: font, fontSize: 18),
                          textAlign: pw.TextAlign.center
                      ),
                    ),
                  ),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Padding(
                    padding: pw.EdgeInsets.only(top: 8, bottom: 8),
                    child: pw.Table.fromTextArray(
                      border: null,
                      columnWidths: {
                        0: const pw.FractionColumnWidth(0.15),
                        1: const pw.FractionColumnWidth(0.69),
                        2: const pw.FractionColumnWidth(0.09),
                        3: const pw.FractionColumnWidth(0.07),
                      },
                      headers: tableHeaders,
                      headerAlignment: pw.Alignment.centerLeft,
                      data: List<List<dynamic>>.generate(
                        lista_itens_baixa_pdf.length,
                            (index) => <dynamic>[ //lista_itens_baixa_pdf
                              lista_itens_baixa_pdf[index].codigo,
                              lista_itens_baixa_pdf[index].nome,
                              lista_itens_baixa_pdf[index].qtd.toString(),
                              lista_itens_baixa_pdf[index].unidade,
                        ],
                      ),
                      cellStyle: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                      headerStyle: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.black,
                      ),
                      rowDecoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.black,
                            width: .5,
                          ),
                        ),
                      ),
                      cellAlignment: pw.Alignment.centerLeft,
                      cellAlignments: {0: pw.Alignment.centerLeft},
                    )
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topCenter,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(top: 8, bottom: 8),
                  child: pw.Container(
                    child: pw.FittedBox(
                      child: pw.Text("Declaro que recebi os materiais listados neste documento.",
                          style: pw.TextStyle(font: font, fontSize: 14),
                          textAlign: pw.TextAlign.center
                      ),
                    ),
                  ),
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Expanded(
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Align(
                              alignment: pw.Alignment.topCenter,
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(top: 8),
                                child: pw.Container(
                                    height: 100,
                                    child: pw.Image(pw.MemoryImage(_assinatura_gerada!), fit: pw.BoxFit.cover)
                                ),
                              ),
                            ),
                            pw.Align(
                              alignment: pw.Alignment.topCenter,
                              child: pw.Padding(
                                padding: pw.EdgeInsets.only(top: 2, bottom: 16),
                                child: pw.Container(
                                  width: 150,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border(
                                        top: pw.BorderSide(
                                            color: PdfColor.fromHex("#000000"),
                                            width: 1.0
                                        )
                                    ),
                                  ),
                                  child: pw.Text(_controller_nome.text,
                                      style: pw.TextStyle(font: font, fontSize: 14),
                                      textAlign: pw.TextAlign.center
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Align(
                            alignment: pw.Alignment.topCenter,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(top: 8),
                              child: pw.Container(
                                  height: 100,
                                  child: pw.Image(pw.MemoryImage(imagem_relatorio.readAsBytesSync()), fit: pw.BoxFit.scaleDown)
                              ),
                            ),
                          ),
                          pw.Align(
                            alignment: pw.Alignment.topCenter,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(top: 2, bottom: 16),
                              child: pw.Container(
                                child: pw.Text("Imagem do Técnico",
                                    style: pw.TextStyle(font: font, fontSize: 14),
                                    textAlign: pw.TextAlign.center
                                ),
                              ),
                            ),
                          ),
                        ]
                    )
                  )
                ]
              )
            ]
        )
    );
    String data_formatada = DateFormat('yyyyMMdd-kkmmss').format(now);
    String nome_pdf = "ENT" + data_formatada + "-" + _controller_nome.text.toUpperCase();
    await Printing.sharePdf(bytes: await pdf.save(), filename: nome_pdf+'.pdf');
    //pdf_gerado = File.fromRawPath(await pdf.save());

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/' + nome_pdf);
    pdf_gerado = await file.writeAsBytes(await pdf.save());

  }

  salvar_baixa_firebase() async{
    DateTime now = DateTime.now();
    String data_formatada = DateFormat('dd/MM/yyyy').format(now);
    String data_nome_arquivo = DateFormat('yyyyMMdd-kkmmss').format(now);
    String nome_pdf = "SAI" + data_nome_arquivo + "-" + _controller_nome.text.toUpperCase();
    //recuperamos a ultima chave usada no registro de baixas
    int chave = await recupera_ultima_chave_baixa();
    int cont = 0;
    //registramos todos os itens da lista de baixa
    for(Item item in controller_mobx.lista_itens_baixa){
      RegistroBaixa registro_saida = RegistroBaixa();
      registro_saida.identificacao = nome_pdf;
      registro_saida.tecnico = _controller_nome.text.toUpperCase();
      registro_saida.data = data_formatada;
      registro_saida.codigo = item.codigo;
      registro_saida.nome = item.nome;
      registro_saida.qtd = item.qtd;
      registro_saida.unidade = item.unidade;
      String chave_salvar = (chave+1+cont).toString().padLeft(6, '0');
      await planilha_aba_item_baixa(registro_saida, chave_salvar);
      //final json = registro_saida.toJson();
      //DatabaseReference ref = FirebaseDatabase.instance.ref("saida").child(chave_salvar);
      //await ref.set(json);
      cont++;
    }
    //atualizamos a chave de saida
    int nova_chave = chave + controller_mobx.lista_itens_baixa.length;
    DatabaseReference ref = FirebaseDatabase.instance.ref("chave_saida").child("001");
    await ref.set(nova_chave);
    //atualizamos as quantidades do estoque
    for(Item item in controller_mobx.lista_itens_baixa){
      controller_mobx.baixa_buscar_item_lista_estoque(item.codigo);
      int qtd_atual_item = controller_mobx.baixa_item_lista_estoque.qtd;
      int qtd_saindo_item = item.qtd;
      int nova_qtd_item = qtd_atual_item - qtd_saindo_item;
      DatabaseReference ref_estoque_qtd = FirebaseDatabase.instance.ref("estoque").child(item.codigo).child("qtd");
      await ref_estoque_qtd.set(nova_qtd_item);
      await planilha_estoque_baixa(item.codigo, nova_qtd_item);
    }
    //salvar pdf no storage
    String link_download = await fazer_upload_pdf(nome_pdf);
    //copiar link do pdf e salvar na listagem de baixas
    DadosBaixa dados_baixa = DadosBaixa();
    dados_baixa.identificacao = nome_pdf;
    dados_baixa.data = data_formatada;
    dados_baixa.tecnico = _controller_nome.text.toUpperCase();
    dados_baixa.link = link_download;
    await planilha_aba_baixa(dados_baixa);
    //DatabaseReference ref_dados_baixa = FirebaseDatabase.instance.ref("dados_baixa").child(nome_pdf);
    //final json = dados_baixa.toJson();
    //await ref_dados_baixa.set(json);
  }

  Future<int> recupera_ultima_chave_baixa() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int ultima_chave = 0;
    List<int> chaves = <int>[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("chave_saida").get();
    if (snapshot.exists) {
      for(DataSnapshot ds in snapshot.children){
        int chave_ds = int.parse(ds.value.toString());
        ultima_chave = chave_ds;
        chaves.add(chave_ds);
      }
    } else {
      print('No data available.');
    }
    return ultima_chave;
  }

  Future<String> fazer_upload_pdf(String nome_arquivo) async{
    final storageRef = FirebaseStorage.instance.ref();
    final saidaRef = storageRef.child("saida/" + nome_arquivo);
    String link_download_pdf = "";
    try {
      await saidaRef.putFile(pdf_gerado);
      link_download_pdf = await saidaRef.getDownloadURL();
    }catch (e) {
      print("Erro no upload do pdf");
    }
    return link_download_pdf;
  }

  planilha_aba_item_baixa(RegistroBaixa item_add, String chave_salvar) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha.spreadsheetId);
    var sheet = ss.worksheetByTitle('Itens Baixas');
    await sheet!.values.appendRow([chave_salvar, item_add.data, item_add.identificacao, item_add.tecnico, item_add.codigo, item_add.nome, item_add.qtd, item_add.unidade]);
  }

  planilha_aba_baixa(DadosBaixa item_add) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha.spreadsheetId);
    var sheet = ss.worksheetByTitle('Baixas');
    var ultima_linha = await sheet!.values.lastRow();
    var indice = await sheet!.values.rowIndexOf(ultima_linha![1], inColumn: 2);
    String chave = indice.toString().padLeft(6, '0');
    await sheet!.values.appendRow([chave, item_add.identificacao, item_add.data, item_add.tecnico, item_add.link]);
  }

  planilha_estoque_baixa(String codigo, int nova_qtd) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha.spreadsheetId);
    var sheet = ss.worksheetByTitle('Estoque Atual');
    var indice = await sheet!.values.rowIndexOf(codigo, inColumn: 1);
    await sheet.values.insertValue(nova_qtd, column: 3, row: indice);
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
}
