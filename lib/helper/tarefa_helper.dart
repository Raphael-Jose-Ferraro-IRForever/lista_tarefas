import 'package:lista_tarefas/model/tarefa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TarefaHelper{
  static final String nomeTabela = 'tarefas';
  static final TarefaHelper _anotacaoHelper = TarefaHelper._internal();
  Database? _db;

  factory TarefaHelper(){
    return _anotacaoHelper;
  }
  TarefaHelper._internal(){}

  get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }
  _onCreate(Database db, int versao){
      String sql = 'CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, data VARCHAR)';
      db.execute(sql);
  }

  inicializarDB() async{
    final caminhoDB = await getDatabasesPath();
    final localDB = join(caminhoDB,'listaTarefa.db');

    var db = await openDatabase(localDB, version: 1,onCreate: _onCreate);
    return db;
  }

  Future<int> salvarTarefa(Tarefa tarefa) async{
    var banco = await db;
    int resultado = await banco.insert(nomeTabela,tarefa.toMap());
    return resultado;
  }

  recuperarTarefas() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC ";
    List tarefas = await bancoDados.rawQuery(sql);
    return tarefas;

  }

  Future<int> atualizarTarefa(Tarefa tarefa) async {

    var bancoDados = await db;
    return await bancoDados.update(
        nomeTabela,
        tarefa.toMap(),
        where: "id = ?",
        whereArgs: [tarefa.id]
    );

  }

  Future<int> removerTarefa( int id ) async {

    var bancoDados = await db;
    return await bancoDados.delete(
        nomeTabela,
        where: "id = ?",
        whereArgs: [id]
    );

  }

}