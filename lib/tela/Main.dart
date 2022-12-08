import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ssoft_estoque/tela/Baixa.dart';
import 'package:ssoft_estoque/tela/Entrada.dart';
import 'package:ssoft_estoque/tela/Separacao.dart';
import 'package:ssoft_estoque/util/Controller.dart';
import 'package:ssoft_estoque/util/Util.dart';
import '../firebase_options.dart';
import '../model/Item.dart';
import '../util/SemConexao.dart';
import 'Devolucao.dart';
import 'EstoqueAtual.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
      MultiProvider(
        providers: [
          Provider<Controller>(
            create: (_) => Controller(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black
          ),
          home: Main(),
        ),
      )
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Controller controller_mobx = Controller();
  int _conexao = 0; // 0 - SEM CONEXAO | 1 - CONECTADO
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Util cores = Util();
    verificar_conexao();
    double altura_imagem =MediaQuery.of(context).size.height/5;
    controller_mobx.preenche_lista_estoque_atual();
    controller_mobx.preenche_lista_separacoes();
    FlutterNativeSplash.remove();
    //_popular_firebase();
    //_popular_devolucao();
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: altura_imagem,
              child: Image.asset("images/logo.png"),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Align(
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      child: Text(
                        "Bem-Vindo!",
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Align(
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      child: Text(
                        "O que deseja fazer hoje?",
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Container(
                    height: 50,
                    width: double.infinity,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EstoqueAtual()
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.warehouse_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Estoque Atual",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.warehouse_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                    height: 50,
                    width: double.infinity,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Entrada()
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.archive_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Nova Entrada",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.archive_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                    height: 50,
                    width: double.infinity,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Baixa()
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.unarchive_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Nova Baixa",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.unarchive_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                    height: 50,
                    width: double.infinity,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Separacao()
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.assignment_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Separações",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.assignment_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                    height: 50,
                    width: double.infinity,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Devolucao()
                                )
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.recycling_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Nova Devolução",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.recycling_rounded,
                                  color: cores.cor_app_bar,
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                )
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  width: double.infinity,
                  child: Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        child: Text(
                          "Filial: " + controller_mobx.estoque_atual,
                        ),
                      )
                  ),
                )
            ),
          ],
        ),
      )
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

  _popular_firebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int cont = 1;
    Item item = Item();
    var json = item.toJson();
    DatabaseReference ref = FirebaseDatabase.instance.ref("estoque");
    item = Item(); item.codigo = "101000004"; item.nome = "GRAMPO FIXACAO MIGUELAO N.6 - BRANCO"; item.qtd = 500; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("101000004"); await ref.set(json);
    item = Item(); item.codigo = "101000020"; item.nome = "PARAFUSO SEXTAVADO 1/4X50"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("101000020"); await ref.set(json);
    item = Item(); item.codigo = "101000055"; item.nome = "BUCHA NYLON FULL 8MM"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("101000055"); await ref.set(json);
    item = Item(); item.codigo = "101000056"; item.nome = "BUCHA NYLON FULL 10MM"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("101000056"); await ref.set(json);
    item = Item(); item.codigo = "101000087"; item.nome = "BUCHA NYLON FULL 6MM"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("101000087"); await ref.set(json);
    item = Item(); item.codigo = "103000004"; item.nome = "CINTA BAP-02 1,5MM GF"; item.qtd = 10; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000004"); await ref.set(json);
    item = Item(); item.codigo = "103000005"; item.nome = "CINTA BAP-03 1,5MM GF"; item.qtd = 10; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000005"); await ref.set(json);
    item = Item(); item.codigo = "103000006"; item.nome = "SUPORTE BAP PRENSA FIO - SFFR PF1 GF"; item.qtd = 32; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000006"); await ref.set(json);
    item = Item(); item.codigo = "103000009"; item.nome = "OLHAL RETO C/ ROSCA GF"; item.qtd = 32; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000009"); await ref.set(json);
    item = Item(); item.codigo = "103000010"; item.nome = "FECHO DE ACO INOX DENTADO 3/4"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000010"); await ref.set(json);
    item = Item(); item.codigo = "103000011"; item.nome = "ARAME ESPINAR GALV. POLIETILENO 105M"; item.qtd = 2; item.unidade = "RL"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000011"); await ref.set(json);
    item = Item(); item.codigo = "103000014"; item.nome = "ALCA PREFORMADA P/ DROP OPTICO 2525-H / APDR-0190-1"; item.qtd = 60; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000014"); await ref.set(json);
    item = Item(); item.codigo = "103000016"; item.nome = "PARAFUSO PCA M.12 X 35 3.6 GF"; item.qtd = 32; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000016"); await ref.set(json);
    item = Item(); item.codigo = "103000028"; item.nome = "SPIRAL TUBE 1/2 AMARELO UV"; item.qtd = 60; item.unidade = "MT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000028"); await ref.set(json);
    item = Item(); item.codigo = "103000041"; item.nome = "ADAPTADOR SM SC/UPC"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000041"); await ref.set(json);
    item = Item(); item.codigo = "103000089"; item.nome = "FITA ACO INOX 430 3/4X0,5X25"; item.qtd = 3; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000089"); await ref.set(json);
    item = Item(); item.codigo = "103000106"; item.nome = "ADAPTADOR SM SC/APC"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000106"); await ref.set(json);
    item = Item(); item.codigo = "103000114"; item.nome = "ALCA PREFORMADA P/ CORDOALHA DIELETRICA 1/4 (6,4MM) (PT)"; item.qtd = 20; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000114"); await ref.set(json);
    item = Item(); item.codigo = "103000248"; item.nome = "CORDOALHA DIELETRICA 1/4 (6,40MM)"; item.qtd = 500; item.unidade = "MT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000248"); await ref.set(json);
    item = Item(); item.codigo = "103000250"; item.nome = "ISOLADOR OLHAL ROSCA 71X54X38MM SOBERBA 5/16"; item.qtd = 65; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000250"); await ref.set(json);
    item = Item(); item.codigo = "103000273"; item.nome = "PLACA IDENTIFICACAO CABO OPTICO 90X40MM UV ANTI-CHAMA - UNIFIQUE"; item.qtd = 165; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000273"); await ref.set(json);
    item = Item(); item.codigo = "103000282"; item.nome = "SPIRAL TUBE 1/4 AMARELO UV"; item.qtd = 0; item.unidade = "MT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000282"); await ref.set(json);
    item = Item(); item.codigo = "103000341"; item.nome = "FAST CONNECTOR TIPO ROSCA SC/UPC"; item.qtd = 70; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000341"); await ref.set(json);
    item = Item(); item.codigo = "103000342"; item.nome = "CABO DE FIBRA DROP INDOOR CFOI-BLI-A/B-CM-01-BA-LSZH - FURUKAWA"; item.qtd = 0; item.unidade = "MT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000342"); await ref.set(json);
    item = Item(); item.codigo = "103000343"; item.nome = "FAST CONNECTOR TIPO ROSCA SC/APC"; item.qtd = 60; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000343"); await ref.set(json);
    item = Item(); item.codigo = "103000344"; item.nome = "CABO DE FIBRA DROP FLAT G657 A2 METALICO 1000M"; item.qtd = 15000; item.unidade = "MT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000344"); await ref.set(json);
    item = Item(); item.codigo = "103000392"; item.nome = "ROLDANA PLASTICA 8 VIAS"; item.qtd = 140; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000392"); await ref.set(json);
    item = Item(); item.codigo = "103000425"; item.nome = "SUPORTE PRENSA DROP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("103000425"); await ref.set(json);
    item = Item(); item.codigo = "105000003"; item.nome = "FITA ISOLANTE 18X20MT"; item.qtd = 16; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000003"); await ref.set(json);
    item = Item(); item.codigo = "105000042"; item.nome = "ABRACADEIRA DE NYLON 100MM PRETA/BRANCA - HELLERM"; item.qtd = 0; item.unidade = "CT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000042"); await ref.set(json);
    item = Item(); item.codigo = "105000043"; item.nome = "ABRACADEIRA DE NYLON 200MM PRETA/BRANCA - HELLERM"; item.qtd = 6; item.unidade = "CT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000043"); await ref.set(json);
    item = Item(); item.codigo = "105000044"; item.nome = "ABRACADEIRA DE NYLON 400MM PRETA/BRANCA - HELLERM"; item.qtd = 2; item.unidade = "CT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000044"); await ref.set(json);
    item = Item(); item.codigo = "105000283"; item.nome = "CANALETA PVC SISTEMA X 20X10X2,10MT C/ ADESIVO"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000283"); await ref.set(json);
    item = Item(); item.codigo = "105000602"; item.nome = "FONTE CHAVEADA 12V DC 3.5A (UMG) - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105000602"); await ref.set(json);
    item = Item(); item.codigo = "105001096"; item.nome = "FITA ALTA TENSAO 19X10M - PRYSMIAN"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("105001096"); await ref.set(json);
    item = Item(); item.codigo = "106000016"; item.nome = "INJETOR POE GIGABIT SIMPLES MIKROTIK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("106000016"); await ref.set(json);
    item = Item(); item.codigo = "106000077"; item.nome = "SUPORTE NANO L60"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("106000077"); await ref.set(json);
    item = Item(); item.codigo = "108000012"; item.nome = "VASELINA SOLIDA BRANCA 900G"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000012"); await ref.set(json);
    item = Item(); item.codigo = "108000059"; item.nome = "FITA DUPLA FACE VHB-4910 15X33- 3M"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000059"); await ref.set(json);
    item = Item(); item.codigo = "108000067"; item.nome = "CABO DE REDE U/UTP CAT5E 4PX24AWG"; item.qtd = 0; item.unidade = "CX"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000067"); await ref.set(json);
    item = Item(); item.codigo = "108000068"; item.nome = "CONECTOR RJ45 MACHO CAT5E"; item.qtd = 120; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000068"); await ref.set(json);
    item = Item(); item.codigo = "108000071"; item.nome = "PILHA ALCALINA AAA C/ 2UNID"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000071"); await ref.set(json);
    item = Item(); item.codigo = "108000083"; item.nome = "ANILHA DE IDENTIFICACAO N1 MR (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000083"); await ref.set(json);
    item = Item(); item.codigo = "108000084"; item.nome = "ANILHA DE IDENTIFICACAO N9 BR (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000084"); await ref.set(json);
    item = Item(); item.codigo = "108000088"; item.nome = "PILHA ALCALINA AA C/ 2UNID"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000088"); await ref.set(json);
    item = Item(); item.codigo = "108000090"; item.nome = "ANILHA DE IDENTIFICACAO N3 LA (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000090"); await ref.set(json);
    item = Item(); item.codigo = "108000091"; item.nome = "ANILHA DE IDENTIFICACAO N4 AM (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000091"); await ref.set(json);
    item = Item(); item.codigo = "108000095"; item.nome = "ANILHA DE IDENTIFICACAO N2 VM (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000095"); await ref.set(json);
    item = Item(); item.codigo = "108000098"; item.nome = "ANILHA DE IDENTIFICACAO N6 AZ (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000098"); await ref.set(json);
    item = Item(); item.codigo = "108000099"; item.nome = "ANILHA DE IDENTIFICACAO N8 CZ (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000099"); await ref.set(json);
    item = Item(); item.codigo = "108000100"; item.nome = "ANILHA DE IDENTIFICACAO N0 PT (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000100"); await ref.set(json);
    item = Item(); item.codigo = "108000101"; item.nome = "ANILHA DE IDENTIFICACAO N5 VD (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000101"); await ref.set(json);
    item = Item(); item.codigo = "108000102"; item.nome = "ANILHA DE IDENTIFICACAO N7 VI (CABO REDE)"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000102"); await ref.set(json);
    item = Item(); item.codigo = "108000133"; item.nome = "EMENDA RJ45 CAT5E"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000133"); await ref.set(json);
    item = Item(); item.codigo = "108000143"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 0 (CABO DROP) - HELL"; item.qtd = 200; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000143"); await ref.set(json);
    item = Item(); item.codigo = "108000144"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 1 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000144"); await ref.set(json);
    item = Item(); item.codigo = "108000145"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 2 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000145"); await ref.set(json);
    item = Item(); item.codigo = "108000146"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 3 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000146"); await ref.set(json);
    item = Item(); item.codigo = "108000147"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 4 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000147"); await ref.set(json);
    item = Item(); item.codigo = "108000148"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 5 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000148"); await ref.set(json);
    item = Item(); item.codigo = "108000149"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 6 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000149"); await ref.set(json);
    item = Item(); item.codigo = "108000150"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 7 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000150"); await ref.set(json);
    item = Item(); item.codigo = "108000151"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 8 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000151"); await ref.set(json);
    item = Item(); item.codigo = "108000152"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 9 (CABO DROP) - HELL"; item.qtd = 100; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000152"); await ref.set(json);
    item = Item(); item.codigo = "108000194"; item.nome = "ALCOOL ISOPROPANOL 250ML"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000194"); await ref.set(json);
    item = Item(); item.codigo = "108000009"; item.nome = "ALCOOL ISOPROPANOL ALCISOPROP - QUIMIDROL 5 LTS"; item.qtd = 0; item.unidade = "LT"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000009"); await ref.set(json);
    item = Item(); item.codigo = "108000196"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 A (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000196"); await ref.set(json);
    item = Item(); item.codigo = "108000197"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 B (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000197"); await ref.set(json);
    item = Item(); item.codigo = "108000198"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 C (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000198"); await ref.set(json);
    item = Item(); item.codigo = "108000199"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 F (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000199"); await ref.set(json);
    item = Item(); item.codigo = "108000200"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 L (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000200"); await ref.set(json);
    item = Item(); item.codigo = "108000202"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 S (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000202"); await ref.set(json);
    item = Item(); item.codigo = "108000203"; item.nome = "ANILHA DE IDENTIFICACAO MHG 1/3 N (CABO DROP) - HELL"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("108000203"); await ref.set(json);
    item = Item(); item.codigo = "109000245"; item.nome = "CONTROLE REMOTO SET TOP BOX GIU6770"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("109000245"); await ref.set(json);
    item = Item(); item.codigo = "204000225"; item.nome = "ETIQUETA ADESIVA UNIFIQUE WIFI 180GR 4X0 TAM 87X38MM LAMINACAO FOSCO"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("204000225"); await ref.set(json);
    item = Item(); item.codigo = "206000077"; item.nome = "CABO P2 PARA 3 RCA USO TV"; item.qtd = 1; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("206000077"); await ref.set(json);
    item = Item(); item.codigo = "502000001"; item.nome = "NANO STATION M5 - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000001"); await ref.set(json);
    item = Item(); item.codigo = "502000004"; item.nome = "POWER BEAM M5 22DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000004"); await ref.set(json);
    item = Item(); item.codigo = "502000007"; item.nome = "ATA SPA112 - CISCO"; item.qtd = 2; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000007"); await ref.set(json);
    item = Item(); item.codigo = "502000008"; item.nome = "ATA SPA122 - CISCO"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000008"); await ref.set(json);
    item = Item(); item.codigo = "502000043"; item.nome = "POWER BEAM M5 25DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000043"); await ref.set(json);
    item = Item(); item.codigo = "502000206"; item.nome = "ONU GPON F660 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000206"); await ref.set(json);
    item = Item(); item.codigo = "502000211"; item.nome = "ROUTERBOARD 750R2 HEX LITE - MIKROTIK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000211"); await ref.set(json);
    item = Item(); item.codigo = "502000228"; item.nome = "ONU EPON FK-ONU-E200B - FURUKAWA"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000228"); await ref.set(json);
    item = Item(); item.codigo = "502000253"; item.nome = "ROUTERBOARD 750GR3 HEX LITE - MIKROTIK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000253"); await ref.set(json);
    item = Item(); item.codigo = "502000357"; item.nome = "GATEWAY UMG 100 1E1 - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000357"); await ref.set(json);
    item = Item(); item.codigo = "502000371"; item.nome = "ONU GPON F601 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000371"); await ref.set(json);
    item = Item(); item.codigo = "502000459"; item.nome = "LITE BEAM M5 23DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000459"); await ref.set(json);
    item = Item(); item.codigo = "502000461"; item.nome = "ATA KAP 302 - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000461"); await ref.set(json);
    item = Item(); item.codigo = "502000462"; item.nome = "ATA KAP 208 8P - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000462"); await ref.set(json);
    item = Item(); item.codigo = "502000554"; item.nome = "SWITCH 5P TL-SG105 GIGABIT - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000554"); await ref.set(json);
    item = Item(); item.codigo = "502000596"; item.nome = "SET TOP BOX GK.MP1113 - YOU CAST"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000596"); await ref.set(json);
    item = Item(); item.codigo = "502000732"; item.nome = "ROTEADOR DUAL BAND GIGA ARCHER C5W PRESET - TP-LINK"; item.qtd = 4; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000732"); await ref.set(json);
    item = Item(); item.codigo = "502000787"; item.nome = "ONU GPON F670L AC 1200 - ZTE"; item.qtd = 94; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000787"); await ref.set(json);
    item = Item(); item.codigo = "502000917"; item.nome = "ROTEADOR WS5200 - HUAWEI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000917"); await ref.set(json);
    item = Item(); item.codigo = "502000919"; item.nome = "ROTEADOR MESH H198A AC 1200 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000919"); await ref.set(json);
    item = Item(); item.codigo = "502000926"; item.nome = "SWITCH 08P TL-LS1008G 10/100/1000 - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000926"); await ref.set(json);
    item = Item(); item.codigo = "502000929"; item.nome = "SET TOP BOX GIU6770 - YOU CAST"; item.qtd = 21; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000929"); await ref.set(json);
    item = Item(); item.codigo = "502000968"; item.nome = "ONU GPON F680 AC 2000 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000968"); await ref.set(json);
    item = Item(); item.codigo = "502000980"; item.nome = "ROTEADOR DUAL BAND GIGA EC220-G5 - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502000980"); await ref.set(json);
    item = Item(); item.codigo = "502001035"; item.nome = "ONU XGS-PON F2866S - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502001035"); await ref.set(json);
    item = Item(); item.codigo = "502001044"; item.nome = "ROTEADOR MESH H199A AC 1200 - ZTE"; item.qtd = 2; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502001044"); await ref.set(json);
    item = Item(); item.codigo = "502001134"; item.nome = "ONU GPON F6600 AX18 WIFI 6 – ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref("estoque").child("502001134"); await ref.set(json);

  }

  _popular_devolucao()async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    int cont = 1;
    Item item = Item();
    var json = item.toJson();
    DatabaseReference ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao");
    item = Item(); item.codigo = "502000001"; item.nome = "NANO STATION M5 - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000001"); await ref.set(json);
    item = Item(); item.codigo = "502000004"; item.nome = "POWER BEAM M5 22DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000004"); await ref.set(json);
    item = Item(); item.codigo = "502000007"; item.nome = "ATA SPA112 - CISCO"; item.qtd = 2; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000007"); await ref.set(json);
    item = Item(); item.codigo = "502000008"; item.nome = "ATA SPA122 - CISCO"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000008"); await ref.set(json);
    item = Item(); item.codigo = "502000043"; item.nome = "POWER BEAM M5 25DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000043"); await ref.set(json);
    item = Item(); item.codigo = "502000206"; item.nome = "ONU GPON F660 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000206"); await ref.set(json);
    item = Item(); item.codigo = "502000211"; item.nome = "ROUTERBOARD 750R2 HEX LITE - MIKROTIK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000211"); await ref.set(json);
    item = Item(); item.codigo = "502000228"; item.nome = "ONU EPON FK-ONU-E200B - FURUKAWA"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000228"); await ref.set(json);
    item = Item(); item.codigo = "502000253"; item.nome = "ROUTERBOARD 750GR3 HEX LITE - MIKROTIK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000253"); await ref.set(json);
    item = Item(); item.codigo = "502000357"; item.nome = "GATEWAY UMG 100 1E1 - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000357"); await ref.set(json);
    item = Item(); item.codigo = "502000371"; item.nome = "ONU GPON F601 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000371"); await ref.set(json);
    item = Item(); item.codigo = "502000459"; item.nome = "LITE BEAM M5 23DBI - UBIQUITI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000459"); await ref.set(json);
    item = Item(); item.codigo = "502000461"; item.nome = "ATA KAP 302 - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000461"); await ref.set(json);
    item = Item(); item.codigo = "502000462"; item.nome = "ATA KAP 208 8P - KHOMP"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000462"); await ref.set(json);
    item = Item(); item.codigo = "502000554"; item.nome = "SWITCH 5P TL-SG105 GIGABIT - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000554"); await ref.set(json);
    item = Item(); item.codigo = "502000596"; item.nome = "SET TOP BOX GK.MP1113 - YOU CAST"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000596"); await ref.set(json);
    item = Item(); item.codigo = "502000732"; item.nome = "ROTEADOR DUAL BAND GIGA ARCHER C5W PRESET - TP-LINK"; item.qtd = 4; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000732"); await ref.set(json);
    item = Item(); item.codigo = "502000787"; item.nome = "ONU GPON F670L AC 1200 - ZTE"; item.qtd = 94; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000787"); await ref.set(json);
    item = Item(); item.codigo = "502000917"; item.nome = "ROTEADOR WS5200 - HUAWEI"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000917"); await ref.set(json);
    item = Item(); item.codigo = "502000919"; item.nome = "ROTEADOR MESH H198A AC 1200 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000919"); await ref.set(json);
    item = Item(); item.codigo = "502000926"; item.nome = "SWITCH 08P TL-LS1008G 10/100/1000 - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000926"); await ref.set(json);
    item = Item(); item.codigo = "502000929"; item.nome = "SET TOP BOX GIU6770 - YOU CAST"; item.qtd = 21; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000929"); await ref.set(json);
    item = Item(); item.codigo = "502000968"; item.nome = "ONU GPON F680 AC 2000 - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000968"); await ref.set(json);
    item = Item(); item.codigo = "502000980"; item.nome = "ROTEADOR DUAL BAND GIGA EC220-G5 - TP-LINK"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 0; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502000980"); await ref.set(json);
    item = Item(); item.codigo = "502001035"; item.nome = "ONU XGS-PON F2866S - ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502001035"); await ref.set(json);
    item = Item(); item.codigo = "502001044"; item.nome = "ROTEADOR MESH H199A AC 1200 - ZTE"; item.qtd = 2; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502001044"); await ref.set(json);
    item = Item(); item.codigo = "502001134"; item.nome = "ONU GPON F6600 AX18 WIFI 6 – ZTE"; item.qtd = 0; item.unidade = "UN"; item.controla_serial = 1; json = item.toJson(); ref = FirebaseDatabase.instance.ref(controller_mobx.estoque_atual).child("item_devolucao").child("502001134"); await ref.set(json);

  }
}
