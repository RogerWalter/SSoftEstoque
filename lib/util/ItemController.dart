import 'package:mobx/mobx.dart';
part 'ItemController.g.dart';
class ItemController = ItemControllerBase with _$ItemController;

abstract class ItemControllerBase with Store{

  @observable
  String codigo = "";

  @observable
  ObservableList<String> seriais_item = ObservableList();

  @observable
  int qtd_informada = 0;

  @action
  adicionar_serial(String add){
    seriais_item.add(add);
  }

  @action
  remover_serial(int indice){
    seriais_item.removeAt(indice);
  }
}