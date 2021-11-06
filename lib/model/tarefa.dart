class Tarefa{

  int? _id;
  String? _nome;
  String? _data;

  Tarefa();

  Tarefa.fromMap(Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.data = map["data"];
  }

  Map toMap(){
    Map<String,dynamic> map = {
      'nome': this.nome,
      'data' : this.data

    };
    if(this.id != null){
      map['id'] = this.id;
    }
    return map;
  }

  String? get data => _data;

  set data(String? value) {
    _data = value;
  }

  String? get nome => _nome;

  set nome(String? value) {
    _nome = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }
}