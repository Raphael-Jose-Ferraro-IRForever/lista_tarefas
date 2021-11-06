import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_tarefas/helper/get.dart';
import 'package:lista_tarefas/view/home.dart';

class TarefaWidget extends StatelessWidget {
  int index;
  int id;
  String data;
  String nome;
  TarefaWidget({Key? key, required this.data, required this.id,required this.index, required this.nome}) : super(key: key);

  final ControllerGet controllerGet = Get.put(ControllerGet());
  List<String> meses = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  _removerTarefa(int id) async {
    await controllerGet.db.value.removerTarefa(id);
  }

  String formatarData(DateTime data){

    String dataFormatada;
    dataFormatada =(data.day.toString().length == 1 ? '0' + data.day.toString() : data.day.toString()) + ' ' + meses[data.month-1];
    print(dataFormatada);
    return dataFormatada;
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 8),
        alignment: Alignment.centerRight,
        color: Colors.red[800],
        child: const Icon(Icons.delete, color: Colors.white,),
      ),
      key: Key(
         DateTime.now().millisecondsSinceEpoch.toString()
      ),
      onDismissed: (direction){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Center(child: const Text('Aviso')),
                content: Text('Deseja realmente apagar a Tarefa!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => Home()), (route) => true),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.red),),
                  ),
                  TextButton(
                    onPressed: () async{
                      //deletar
                      await _removerTarefa(id);
                      controllerGet.listaTarefas.value.removeAt(index);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apagar'),
                  ),
                ],
              );}
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          children: [
            Card(
              elevation: 20,
                  child: SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * .94 ,
                          height: height * .1,
                          child: Center(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(nome, style: const TextStyle(
                                    fontSize: 24
                                ),),
                              ),
                              trailing: Text(formatarData(DateTime.parse(data)), style: const TextStyle(
                                  fontSize: 16
                              ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            ),
            Positioned(
              right: 4,
              top: height * .025,
              child: Container(
                color: Colors.blue,
                width: 3,
                height: height * .06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
