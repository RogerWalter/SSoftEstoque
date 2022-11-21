import 'dart:io';
import 'dart:ui';

class Util{
  Color _laranja_teccel = Color(0xFFFD4A12);
  Color _cor_app_bar = Color(0xFF000000);
  Color _cor_accent = Color(0xFFFD1216);

  Color get laranja_teccel => _laranja_teccel;

  set laranja_teccel(Color value) {
    _laranja_teccel = value;
  }

  Color get cor_app_bar => _cor_app_bar;

  set cor_app_bar(Color value) {
    _cor_app_bar = value;
  }

  Color get cor_accent => _cor_accent;

  set cor_accent(Color value) {
    _cor_accent = value;
  }

  Future<int> verificar_conexao() async
  {
    int valor = 0;
    try{
      if(Platform.isAndroid || Platform.isIOS){
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            valor = 1;
          }
        } on SocketException catch (_) {
          valor = 0;
        }
      }
    } catch(e){
      valor = 1;
    }
    return valor;
  }


}