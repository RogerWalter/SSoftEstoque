import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:gsheets/gsheets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:ssoft_estoque/model/DadosEntrada.dart';
import 'package:ssoft_estoque/model/RegistroEntrada.dart';
import 'package:ssoft_estoque/tela/Main.dart';
import 'package:ssoft_estoque/util/WidgetProgress.dart';
import '../firebase_options.dart';
import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/Planilha.dart';
import '../util/Util.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DialogoFinalizarEntrada extends StatefulWidget {
  const DialogoFinalizarEntrada({Key? key}) : super(key: key);

  @override
  State<DialogoFinalizarEntrada> createState() => _DialogoFinalizarEntradaState();
}

class _DialogoFinalizarEntradaState extends State<DialogoFinalizarEntrada> {

  TextEditingController _controller_nome = TextEditingController();
  FocusNode _foco_nome = FocusNode();
  Planilha planilha = Planilha();
  Util cores = Util();
  Controller controller_mobx = Controller();
  Uint8List? _assinatura_gerada;
  var pdf_gerado;

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
    return Observer(
      builder: (_){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: controller_mobx.entrada_dialogo_visible,
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
                                      "Informe seu nome e assine abaixo para efetivar a entrada",
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
                                    textInputAction: TextInputAction.next,
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
                                            salvar_nova_entrada();
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
        );
      }
    );
  }
  salvar_nova_entrada()async{
    if(_controller_signature.isEmpty || _controller_nome.text.isEmpty){
      Flushbar(
        backgroundColor: cores.cor_accent,
        message: 'Existem dados obrigatórios não preenchidos. Verifique e tente novamente.',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    else{
      controller_mobx.entrada_dialogo_visible = false;
      mostrar_progress();
      await gerar_imagem_assinatura(context);
      await gerar_pdf();
      await salvar_entrada_firebase();
      await controller_mobx.preenche_lista_estoque_atual();
      controller_mobx.remover_todos_entrada();
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
                  child: pw.Text("Relatório de Entrada de Materiais", style: pw.TextStyle(font: font, fontSize: 28)),
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
                  child: pw.Text("Operador: " + _controller_nome.text + "\nData: " + data_relatorio,
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
                    controller_mobx.lista_itens_entrada.length,
                        (index) => <dynamic>[
                      controller_mobx.lista_itens_entrada[index].codigo,
                      controller_mobx.lista_itens_entrada[index].nome,
                      controller_mobx.lista_itens_entrada[index].qtd.toString(),
                      controller_mobx.lista_itens_entrada[index].unidade,
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
                  child: pw.Text("Declaro que realizei a entrada dos materiais listados neste documento.",
                      style: pw.TextStyle(font: font, fontSize: 14),
                      textAlign: pw.TextAlign.center
                  ),
                ),
              ),
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Padding(
              padding: pw.EdgeInsets.only(top: 8),
              child: pw.Container(
                  height: 50,
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

  salvar_entrada_firebase() async{
    DateTime now = DateTime.now();
    String data_formatada = DateFormat('dd/MM/yyyy').format(now);
    String data_nome_arquivo = DateFormat('yyyyMMdd-kkmmss').format(now);
    String nome_pdf = "ENT" + data_nome_arquivo + "-" + _controller_nome.text.toUpperCase();
    //recuperamos a ultima chave usada no registro de entradas
    int chave = await recupera_ultima_chave_entrada();
    int cont = 0;
    //registramos todos os itens da lista de entrada
    for(Item item in controller_mobx.lista_itens_entrada){
      RegistroEntrada registro_entrada = RegistroEntrada();
      registro_entrada.identificacao = nome_pdf;
      registro_entrada.operador = _controller_nome.text.toUpperCase();
      registro_entrada.data = data_formatada;
      registro_entrada.codigo = item.codigo;
      registro_entrada.nome = item.nome;
      registro_entrada.qtd = item.qtd;
      registro_entrada.unidade = item.unidade;
      String chave_salvar = (chave+1+cont).toString().padLeft(6, '0');
      await planilha_aba_item_baixa(registro_entrada, chave_salvar);
      //final json = registro_entrada.toJson();
      //DatabaseReference ref = FirebaseDatabase.instance.ref("entrada").child(chave_salvar);
      //await ref.set(json);
      cont++;
    }
    //atualizamos a chave de entrada
    int nova_chave = chave + controller_mobx.lista_itens_entrada.length;
    DatabaseReference ref = FirebaseDatabase.instance.ref("chave_entrada").child("001");
    await ref.set(nova_chave);
    //atualizamos as quantidades do estoque
    for(Item item in controller_mobx.lista_itens_entrada){
      controller_mobx.buscar_item_lista_estoque(item.codigo);
      int qtd_atual_item = controller_mobx.entrada_item_lista_estoque.qtd;
      int qtd_entrando_item = item.qtd;
      int nova_qtd_item = qtd_atual_item + qtd_entrando_item;
      DatabaseReference ref_estoque_qtd = FirebaseDatabase.instance.ref("estoque").child(item.codigo).child("qtd");
      await ref_estoque_qtd.set(nova_qtd_item);
      await planilha_estoque_entrada(item.codigo, nova_qtd_item);
    }
    //salvar pdf no storage
    String link_download = await fazer_upload_pdf(nome_pdf);
    //copiar link do pdf e salvar na listagem de entradas
    DadosEntrada dados_entrada = DadosEntrada();
    dados_entrada.identificacao = nome_pdf;
    dados_entrada.data = data_formatada;
    dados_entrada.operador = _controller_nome.text.toUpperCase();
    dados_entrada.link = link_download;
    await planilha_aba_entrada(dados_entrada);
    //DatabaseReference ref_dados_entrada = FirebaseDatabase.instance.ref("dados_entrada").child(nome_pdf);
    //final json = dados_entrada.toJson();
    //await ref_dados_entrada.set(json);
  }

  Future<int> recupera_ultima_chave_entrada() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int ultima_chave = 0;
    List<int> chaves = <int>[];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("chave_entrada").get();
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
    final entradaRef = storageRef.child("entrada/" + nome_arquivo);
    String link_download_pdf = "";
    try {
      await entradaRef.putFile(pdf_gerado);
      link_download_pdf = await entradaRef.getDownloadURL();
    }catch (e) {
      print("Erro no upload do pdf");
    }
    return link_download_pdf;
  }

  planilha_aba_item_baixa(RegistroEntrada item_add, String chave_salvar) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha.spreadsheetId);
    var sheet = ss.worksheetByTitle('Itens Entradas');
    await sheet!.values.appendRow([chave_salvar, item_add.data, item_add.identificacao, item_add.operador, item_add.codigo, item_add.nome, item_add.qtd, item_add.unidade]);
  }

  planilha_aba_entrada(DadosEntrada item_add) async{
    final gsheets = GSheets(planilha.credentials);
    final ss = await gsheets.spreadsheet(planilha.spreadsheetId);
    var sheet = ss.worksheetByTitle('Entradas');
    var ultima_linha = await sheet!.values.lastRow();
    var indice = await sheet!.values.rowIndexOf(ultima_linha![1], inColumn: 2);
    String chave = indice.toString().padLeft(6, '0');
    await sheet!.values.appendRow([chave, item_add.identificacao, item_add.data, item_add.operador, item_add.link]);
  }

  planilha_estoque_entrada(String codigo, int nova_qtd) async{
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
