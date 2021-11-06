import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_tarefas/helper/get.dart';
import 'package:lista_tarefas/model/tarefa.dart';
import 'package:lista_tarefas/widget/widget_tarefa.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  TextEditingController _controllerNome = TextEditingController();
  late String _dataEscolhida = DateTime.now().toString();


  _salvarAtualizarTarefa( {Tarefa? tarefaSelecionada} ) async {

    String nome =  _controllerNome.text;

    //salvando
    if( tarefaSelecionada == null ){
      Tarefa tarefa = Tarefa();
      tarefa.nome = nome;
      tarefa.data = _dataEscolhida;

      int resultado = await controllerGet.db.value.salvarTarefa(tarefa);
      print(resultado);

      Navigator.of(context).pop();
      Flushbar(
        title: 'Item salvo com sucesso!',
        message: 'Sua tarefa foi salva!',
        duration: const Duration(seconds: 3),
      ).show(context);
    }
    //atualizando
    else{
      tarefaSelecionada.nome = nome;
      tarefaSelecionada.data = _dataEscolhida;
      print('asdasdasd '+tarefaSelecionada.id.toString());
      int resultado = await controllerGet.db.value.atualizarTarefa(tarefaSelecionada);
      print(resultado);

      Navigator.of(context).pop();

      Flushbar(
        title: 'Item atualizado com sucesso!',
        message: 'Sua tarefa foi atualizada!',
        duration: const Duration(seconds: 3),
      ).show(context);
    }

    _controllerNome.clear();
    _dataEscolhida = DateTime.now().toString();
    _recuperarTarefas();

  }


  _recuperarTarefas() async {

    List? tarefasRecuperadas = await controllerGet.db.value.recuperarTarefas();
    List<Tarefa> listaTemporaria = <Tarefa>[];
    print(tarefasRecuperadas);
    if(tarefasRecuperadas != null) {
      for (var item in tarefasRecuperadas) {
        Tarefa tarefa = Tarefa.fromMap(item);
        tarefa.data = tarefa.data!;
        listaTemporaria.add(tarefa);
      }

      setState(() {
        controllerGet.listaTarefas.value = listaTemporaria;
      });
      listaTemporaria = <Tarefa>[];
      }
  }

  _criarTarefa({Tarefa? tarefa, int? index}){

    if(tarefa != null){
      _controllerNome.text = tarefa.nome!;
      _dataEscolhida = tarefa.data!;
      controllerGet.idTarefa.value = tarefa.id!;
    }
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: const Center(child: Text('Adicionar Tarefa')),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Descreva a Tarefa',
                      ),
                      controller: _controllerNome,
                      textCapitalization: TextCapitalization.words,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        height: 300,
                        width: 400,
                        child: CalendarDatePicker(
                            initialDate: DateTime.parse(_dataEscolhida),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050,12,31),
                            onDateChanged: (date){
                              setState(() {
                                _dataEscolhida =  date.toString();
                                print(_dataEscolhida);
                              });
                            }),
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red),),
                ),
                TextButton(
                  onPressed: () async{
                    if(_controllerNome.text.isEmpty){
                      Flushbar(
                        title: 'Encontramos um problema!',
                        message: 'Confira se preencheu a Tarefa e escolheu a data do evento!',
                        duration: const Duration(seconds: 5),
                      ).show(context);
                    } else {
                      if (tarefa == null) {
                        await _salvarAtualizarTarefa();
                      } else {
                        Tarefa tarefa = Tarefa();
                        tarefa.id = controllerGet.idTarefa.value;
                        tarefa.nome = _controllerNome.text;
                        tarefa.data = _dataEscolhida;
                        controllerGet.listaTarefas.value.removeAt(index!);
                        await _salvarAtualizarTarefa(tarefaSelecionada: tarefa);

                      }
                    }
                    },
                  child: const Text('Salvar'),
                ),
              ],
            );}
          );
  }

  @override
  void initState() {
    // TODO: implement initState
    _recuperarTarefas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _criarTarefa,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Lista de Tarefas',
            style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: controllerGet.listaTarefas.value == null ? const Center(
          child: Text('Você não adicionou nenhuma tarefa ainda!'),
        ) : Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8.0),
          child: SizedBox(
            width: width,
            height: height - 60,
            child: ListView.builder(
              itemCount: controllerGet.listaTarefas.value.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                     _criarTarefa(tarefa: controllerGet.listaTarefas.value[index], index: index);
                    },
                    child: TarefaWidget(
                      index: index,
                      id: controllerGet.listaTarefas.value[index].id!,
                      data: controllerGet.listaTarefas.value[index].data!,
                      nome: controllerGet.listaTarefas.value[index].nome!,
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
