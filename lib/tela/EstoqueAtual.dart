import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:ssoft_estoque/tela/DialogoNovoItem.dart';

import '../model/Item.dart';
import '../util/Controller.dart';
import '../util/SemDados.dart';
import '../util/Util.dart';

class EstoqueAtual extends StatefulWidget {
  const EstoqueAtual({Key? key}) : super(key: key);

  @override
  State<EstoqueAtual> createState() => _EstoqueAtualState();
}

class _EstoqueAtualState extends State<EstoqueAtual> {
  Controller controller_mobx = Controller();
  TextEditingController _controller_pesquisa = TextEditingController();
  Util cores = Util();
  int _conexao = 1;
  List<Item> lista_filtrada = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller_mobx = Provider.of(context);
  }
  @override
  Widget build(BuildContext context) {
    controller_mobx.lista_estoque_filtrada.clear();
    controller_mobx.estoque_parametro_filtro = false;
    for(Item item in controller_mobx.lista_estoque_atual){
      if(item.qtd > 0)
        controller_mobx.adiciona_item_lista_filtrada(item);
    }
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
            title: Text('Estoque Atual', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                child: Observer(
                  builder: (_){
                    return Visibility(
                      visible: controller_mobx.estoque_parametro_visibilidade_filtro,
                      child: IconButton(
                          onPressed: (){
                            if(controller_mobx.estoque_parametro_filtro)
                              controller_mobx.altera_parametro_filtro(false);
                            else
                              controller_mobx.altera_parametro_filtro(true);
                          },
                          icon: Icon(!controller_mobx.estoque_parametro_filtro ? Icons.filter_list: Icons.filter_list_off_rounded, color: cores.laranja_teccel)
                      )
                    );
                  }
                )
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: (){
                      abrir_dialogo_novo_item();
                    },
                    icon: Icon(Icons.add, color: cores.laranja_teccel,)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: (){
                      mostrar_dialogo_exportar_pdf();
                    },
                    icon: Icon(Icons.share_rounded, color: cores.laranja_teccel,)
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
                                    controller: _controller_pesquisa,
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
                                      labelText: "Pesquisar Item",
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
                                      if(content.isNotEmpty){
                                        controller_mobx.lista_estoque_pesquisa.clear();
                                        for(int i = 0; i < controller_mobx.lista_estoque_atual.length; i++){
                                          if(controller_mobx.lista_estoque_atual[i].codigo.contains(content) || controller_mobx.lista_estoque_atual[i].nome.toLowerCase().contains(content.toLowerCase())){
                                            controller_mobx.adiciona_item_lista_pesquisa(controller_mobx.lista_estoque_atual[i]);
                                          }
                                        }
                                        controller_mobx.altera_parametro_visibilidade_filtro(false);
                                      }
                                      else{
                                        controller_mobx.altera_parametro_filtro(false);
                                        controller_mobx.lista_estoque_pesquisa.clear();
                                        controller_mobx.altera_parametro_visibilidade_filtro(true);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      if(controller_mobx.lista_estoque_atual.length > 0)
                        Observer(
                            builder: (_) {
                              return Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    Visibility(
                                        visible: controller_mobx.estoque_parametro_visibilidade_filtro,
                                        child: ScrollConfiguration(
                                            behavior: ScrollBehavior(),
                                            child: GlowingOverscrollIndicator(
                                                axisDirection: AxisDirection.down,
                                                color: cores.laranja_teccel.withOpacity(0.20),
                                                child: ListView.builder(
                                                  itemCount: !controller_mobx.estoque_parametro_filtro ? controller_mobx.lista_estoque_atual.length : controller_mobx.lista_estoque_filtrada.length,
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
                                                                !controller_mobx.estoque_parametro_filtro ? controller_mobx.lista_estoque_atual[index].codigo : controller_mobx.lista_estoque_filtrada[index].codigo,
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
                                                                    !controller_mobx.estoque_parametro_filtro ? controller_mobx.lista_estoque_atual[index].nome : controller_mobx.lista_estoque_filtrada[index].nome,
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
                                                                    !controller_mobx.estoque_parametro_filtro ? controller_mobx.lista_estoque_atual[index].qtd.toString() + " " + controller_mobx.lista_estoque_atual[index].unidade : controller_mobx.lista_estoque_filtrada[index].qtd.toString() + " " + controller_mobx.lista_estoque_filtrada[index].unidade,
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
                                                          ),
                                                        )
                                                    );
                                                  },
                                                )
                                            )
                                        )
                                    ),
                                    Visibility(
                                        visible: !controller_mobx.estoque_parametro_visibilidade_filtro,
                                        child: Observer(
                                          builder: (_){
                                            return ScrollConfiguration(
                                                behavior: ScrollBehavior(),
                                                child: GlowingOverscrollIndicator(
                                                    axisDirection: AxisDirection.down,
                                                    color: cores.laranja_teccel.withOpacity(0.20),
                                                    child: ListView.builder(
                                                      itemCount: controller_mobx.lista_estoque_pesquisa.length,
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
                                                                    controller_mobx.lista_estoque_pesquisa[index].codigo,
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
                                                                        controller_mobx.lista_estoque_pesquisa[index].nome,
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
                                                                        controller_mobx.lista_estoque_pesquisa[index].qtd.toString() + " " + controller_mobx.lista_estoque_pesquisa[index].unidade,
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
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    )
                                                )
                                            );
                                          },
                                        )
                                    ),
                                  ],
                                )
                              );
                            }
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
  abrir_dialogo_novo_item(){
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
            insetPadding: EdgeInsets.only(left: 8, right: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: DialogoNovoItem()
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.easeOutQuint,
      duration: Duration(milliseconds: 500),
    );
  }

  mostrar_dialogo_exportar_pdf(){
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
                            "Exportar PDF?",
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
                            "Deseja realmente exportar a listagem do estoque apresentada na tela?\nEsta ação exportará todos os itens apresentados na tela neste momento.",
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
                                          exportar_pdf();
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

  exportar_pdf() async{
    List<Item> lista_exportar = [];
    String titulo_relatorio = "";
    if(controller_mobx.estoque_parametro_filtro && controller_mobx.estoque_parametro_visibilidade_filtro){
      //O FILTRO DE ITENS COM SALDO DISPONIVEL ESTÁ APLICADO.
      //LOGO, EXPORTAREMOS SOMENTE ITENS COM SALDO DISPONÍVEL
      for(Item item in controller_mobx.lista_estoque_filtrada){
        lista_exportar.add(item);
      }
      titulo_relatorio = "Itens Disponíveis no Estoque";
    }
    if(controller_mobx.estoque_parametro_visibilidade_filtro == false){
      //O FILTRO NÃO ESTÁ VISIVEL. EXISTE UMA PESQUISA EM ANDAMENTO
      //LOGO, EXPORTAREMOS OS ITENS DA LISTA DE PESQUISA
      for(Item item in controller_mobx.lista_estoque_pesquisa){
        lista_exportar.add(item);
      }
      titulo_relatorio = "Itens do Estoque";
    }
    if(controller_mobx.estoque_parametro_filtro == false && controller_mobx.estoque_parametro_visibilidade_filtro){
      //NÃO HÁ NADA SENDO PESQUISADO E NÃO HÁ FILTRO APLICADO
      //LOGO, EXPORTAREMOS TODOS OS ITENS DO ESTOQUE
      for(Item item in controller_mobx.lista_estoque_atual){
        lista_exportar.add(item);
      }
      titulo_relatorio = "Estoque Atual Completo";
    }

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
                      child: pw.Text(titulo_relatorio, style: pw.TextStyle(font: font, fontSize: 28)),
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
                      child: pw.Text("Filial: " + controller_mobx.estoque_atual + "\nData: " + data_relatorio,
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
                        lista_exportar.length,
                            (index) => <dynamic>[ //lista_itens_baixa_pdf
                              lista_exportar[index].codigo,
                              lista_exportar[index].nome,
                              lista_exportar[index].qtd.toString(),
                              lista_exportar[index].unidade,
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
                  padding: pw.EdgeInsets.only(top: 8, bottom: 16),
                  child: pw.SizedBox(
                    child: pw.FittedBox(
                      child: pw.Text("Data: " + data_relatorio,
                          style: pw.TextStyle(font: font, fontSize: 18),
                          textAlign: pw.TextAlign.center
                      ),
                    ),
                  ),
                ),
              ),
            ]
        )
    );
    String data_formatada = DateFormat('dd-MM-yyyy-kk-mm-ss').format(now);
    String nome_pdf = "ESTOQUE-" + data_formatada;
    await Printing.sharePdf(bytes: await pdf.save(), filename: nome_pdf+'.pdf');
  }
}
