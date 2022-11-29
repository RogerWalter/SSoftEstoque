import 'package:flutter/material.dart';
import 'package:ssoft_estoque/util/Util.dart';
class SemConexao extends StatefulWidget {
  const SemConexao({Key? key}) : super(key: key);

  @override
  State<SemConexao> createState() => _SemConexaoState();
}

class _SemConexaoState extends State<SemConexao> {
  @override
  Widget build(BuildContext context) {
    Util cores = Util();
    double altura_imagem =MediaQuery.of(context).size.height/8;
    return WillPopScope(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: altura_imagem,
                  child: Image.asset("images/sem_conexao.png"),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  child: Text(
                    "Sem Conexão com a Internet",
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
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
                                verifica_conexao();
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Recarregar",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14
                                  ),
                                ),
                              )
                          ),
                        )
                    )
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
  verifica_conexao() async {
    Util verif = Util();
    int retorno = await verif.verificar_conexao();
    if(retorno == 0){
      return;
    }
    else{
      Navigator.of(context).pop();
    }
  }
}
