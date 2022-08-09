/* ======================================================================================
 * Cadastro de grupos para filtros de registros
 * Versão 1.0.0
 * 
*/
import 'dart:convert';

import 'registros.dart';
export 'registros.dart';

class Grupo {
  late int? id;
  final String nome;
  List<Registro> registros = [];

  // Construtor
  Grupo({
    this.id,
    required this.nome,
  });

  // Converte o grupo para mapa para uso pelo banco de dados
  // O nome das variáveis correspondem aos nomes das colunas no Banco de Dados
  Map<String, dynamic> toMap({bool withID = false}) {
    Map<String, dynamic> ret = {
      'nome': nome,
    };
    if (withID) {
      ret['id'] = id;
    }
    return ret;
  }

  factory Grupo.fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Grupo.fromJson(String source) => Grupo.fromMap(json.decode(source));

  // Substitui o metodo toString para uma visão mais apropriada
  @override
  String toString() {
    return 'Grupo {id: $id, nome: $nome, registros: ${registros.length}}';
  }
}
