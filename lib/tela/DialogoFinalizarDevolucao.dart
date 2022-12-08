import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../firebase_options.dart';
import '../model/DadosBaixa.dart';
import '../model/Item.dart';
import '../model/RegistroBaixa.dart';
import '../util/Controller.dart';
import '../util/Planilha.dart';
import '../util/SemConexao.dart';
import '../util/Util.dart';
import '../util/WidgetProgress.dart';
import 'Main.dart';
class DialogoFinalizarDevolucao extends StatefulWidget {
  const DialogoFinalizarDevolucao({Key? key}) : super(key: key);

  @override
  State<DialogoFinalizarDevolucao> createState() => _DialogoFinalizarDevolucaoState();
}

class _DialogoFinalizarDevolucaoState extends State<DialogoFinalizarDevolucao> {
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
  var planilha_salvar;

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
    if(controller_mobx.estoque_atual == "SBS")
      planilha_salvar = planilha.spreadsheetId_sbs;
    if(controller_mobx.estoque_atual == "JVE")
      planilha_salvar = planilha.spreadsheetId_jve;
    if(controller_mobx.estoque_atual == "UVA")
      planilha_salvar = planilha.spreadsheetId_uva;
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
                  visible: controller_mobx.devolucao_dialogo_visible,
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
                                          "Preencha os campos abaixo para salvar",
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
                                          labelText: "Operador",
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
                                                salvar_nova_devolucao();
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
  salvar_nova_devolucao()async{
    if(_controller_signature.isEmpty || _controller_nome.text.isEmpty){
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
        controller_mobx.devolucao_dialogo_visible = false;
        mostrar_progress();
        await gerar_imagem_assinatura(context);
        await gerar_pdf();
        await salvar_baixa_firebase();
        await controller_mobx.preenche_lista_estoque_atual();
        controller_mobx.remover_todos_devolucao();
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
  }
  Future<void> gerar_imagem_assinatura(BuildContext context) async {
    final Uint8List? data =
    await _controller_signature.toPngBytes();
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
    List<Item> lista_itens_devolucao_pdf = [];
    for(Item item in controller_mobx.lista_itens_devolucao){
      if(item.controla_serial == 1){
        lista_itens_devolucao_pdf.add(item);
        int indice = -1;
        indice = controller_mobx.devolucao_lista_seriais_itens.indexWhere((element) => element.codigo == item.codigo);
        for(int i = 0; i < item.qtd; i++){
          Item serial = Item();
          serial.codigo = "";
          serial.nome = controller_mobx.devolucao_lista_seriais_itens[indice].seriais_item[i];
          serial.qtd = 1;
          serial.unidade = item.unidade;
          serial.controla_serial = 0;
          lista_itens_devolucao_pdf.add(serial);
        }
      }
      else{
        lista_itens_devolucao_pdf.add(item);
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
                      child: pw.Text("Relatório de Devolução de Equipamentos", style: pw.TextStyle(font: font, fontSize: 28)),
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
                      child: pw.Text("Filial: " + controller_mobx.estoque_atual + "\nOperador: " + _controller_nome.text + "\nData: " + data_relatorio,
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
                        lista_itens_devolucao_pdf.length,
                          (index) => <dynamic>[ //lista_itens_baixa_pdf
                            lista_itens_devolucao_pdf[index].codigo,
                            lista_itens_devolucao_pdf[index].nome,
                            lista_itens_devolucao_pdf[index].qtd.toString(),
                            lista_itens_devolucao_pdf[index].unidade,
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
                      child: pw.Text("Declaro que os equipamentos listados neste documento foram entregues ao estoque da Unifique.",
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
                                    child: pw.Image(pw.MemoryImage(_assinatura_gerada!), fit: pw.BoxFit.scaleDown)
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
                                    child: pw.Container()
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
                                  child: pw.Text("Estoque Unifique",
                                      style: pw.TextStyle(font: font, fontSize: 14),
                                      textAlign: pw.TextAlign.center
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ]
              )
            ]
        )
    );
    String data_formatada = DateFormat('yyyyMMdd-kkmmss').format(now);
    String nome_pdf = "DEV" + data_formatada + "-" + _controller_nome.text.toUpperCase();
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
    String nome_pdf = "DEV" + data_nome_arquivo + "-" + _controller_nome.text.toUpperCase();
    //recuperamos a ultima chave usada no registro de baixas
    int chave = controller_mobx.ultima_chave_devolucao;
    int cont = 0;
    List<List<dynamic>> lista_linhas_itens = [];
    //registramos todos os itens da lista de baixa
    for(Item item in controller_mobx.lista_itens_devolucao){
      RegistroBaixa registro_saida = RegistroBaixa();
      registro_saida.identificacao = nome_pdf;
      registro_saida.tecnico = _controller_nome.text.toUpperCase();
      registro_saida.data = data_formatada;
      registro_saida.codigo = item.codigo;
      registro_saida.nome = item.nome;
      registro_saida.qtd = item.qtd;
      registro_saida.unidade = item.unidade;
      String chave_salvar = (chave+1+cont).toString().padLeft(6, '0');
      List<dynamic> item_linha = [chave_salvar, registro_saida.data, registro_saida.identificacao, registro_saida.tecnico, registro_saida.codigo, registro_saida.nome, registro_saida.qtd, registro_saida.unidade];
      lista_linhas_itens.add(item_linha);
      cont++;
    }
    //insere os seriais na planilha de seriais devolvidos
    List<List<dynamic>> lista_seriais_itens = [];
    if(controller_mobx.lista_itens_devolucao.length > 0){
      for(Item item in controller_mobx.lista_itens_devolucao){
        if(item.controla_serial == 1){
          int indice = -1;
          indice = controller_mobx.devolucao_lista_seriais_itens.indexWhere((element) => element.codigo == item.codigo);
          for(int i = 0; i < item.qtd; i++){
            String serial = controller_mobx.devolucao_lista_seriais_itens[indice].seriais_item[i];
            List<dynamic> item_linha = [data_formatada, _controller_nome.text, item.codigo, item.nome, serial, "1", item.unidade];
            lista_seriais_itens.add(item_linha);
          }
        }
      }
    }
    //atualizamos a chave de devolucao
    int nova_chave = chave + controller_mobx.lista_itens_devolucao.length;
    DatabaseReference ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("chave_devolucao").child("001");
    await ref.set(nova_chave);
    controller_mobx.alterar_ultima_chave_devolucao(nova_chave);
    //salvar pdf no storage
    String link_download = await fazer_upload_pdf(nome_pdf);
    //copiar link do pdf e salvar na listagem de baixas
    DadosBaixa dados_baixa = DadosBaixa();
    dados_baixa.identificacao = nome_pdf;
    dados_baixa.data = data_formatada;
    dados_baixa.tecnico = _controller_nome.text.toUpperCase();
    dados_baixa.link = link_download;
    await salvar_planilha(lista_linhas_itens, lista_seriais_itens, dados_baixa);
  }

  Future<String> fazer_upload_pdf(String nome_arquivo) async{
    final storageRef = FirebaseStorage.instance.ref();
    final saidaRef = storageRef.child(controller_mobx.estoque_atual).child("devolucao/" + nome_arquivo);
    String link_download_pdf = "";
    try {
      await saidaRef.putFile(pdf_gerado);
      link_download_pdf = await saidaRef.getDownloadURL();
    }catch (e) {
      print("Erro no upload do pdf");
    }
    return link_download_pdf;
  }

  salvar_planilha(List<List<dynamic>> linhas_itens_baixa, List<List<dynamic>> linhas_seriais_baixa, DadosBaixa item_add) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha_salvar);
    var sheet_itens = ss.worksheetByTitle('Itens Devolução');
    var sheet_seriais = ss.worksheetByTitle('Devolução Seriais');
    var sheet_devolucoes = ss.worksheetByTitle('Devoluções');
    await sheet_itens!.values.appendRows(linhas_itens_baixa);
    if(linhas_seriais_baixa.length > 0)
      await sheet_seriais!.values.appendRows(linhas_seriais_baixa);
    var ultima_linha = await sheet_devolucoes!.values.lastRow();
    var indice = await sheet_devolucoes!.values.rowIndexOf(ultima_linha![1], inColumn: 2);
    String chave = indice.toString().padLeft(6, '0');
    await sheet_devolucoes!.values.appendRow([chave, item_add.identificacao, item_add.data, item_add.tecnico, item_add.link]);
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
