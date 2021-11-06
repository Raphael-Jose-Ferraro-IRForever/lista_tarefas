import 'package:get/get.dart';
import 'package:lista_tarefas/helper/tarefa_helper.dart';
import 'package:lista_tarefas/model/tarefa.dart';

class ControllerGet extends GetxController{
  var db = TarefaHelper().obs;
  var idTarefa = 0.obs;
  var listaTarefas = <Tarefa>[].obs;

}
