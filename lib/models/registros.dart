/* ======================================================================================
 * Cadastro dos registros
 * Versão 1.0.0
 * 
*/

import 'dart:convert';

class Registro {
  int? id;
  String nome;
  String chave;
  String? complemento;
  String? observacoes;
  int? grupoId;

  Registro({
    this.id,
    required this.nome,
    required this.chave,
    this.complemento,
    this.observacoes,
    this.grupoId,
  });

  // Converte o registro para mapa.
  // O nome das variáveis correspondem aos nomes das colunas no Banco de Dados
  Map<String, dynamic> toMap({bool withID = true}) {
    Map<String, dynamic> ret = {
      'nome': nome,
      'chave': chave,
      'complemento': complemento,
      'observacoes': observacoes,
      'grupo_id': grupoId,
    };
    if (withID) {
      ret['id'] = id;
    }
    return ret;
  }

  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      nome: map['nome'],
      chave: map['chave'],
      complemento: map['complemento'],
      observacoes: map['observacoes'],
      grupoId: map['grupo_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Registro.fromJson(String source) => Registro.fromMap(json.decode(source));

  // Substitui o metodo toString para uma visão mais apropriada
  @override
  String toString() {
    return 'Registro {id: $id, nome: $nome, chave: $chave, complemento: $complemento, observacoes: $observacoes, grupoId: $grupoId}';
  }

  set setId(int id) {
    if ((id > 0) & (this.id == null)) {
      this.id = id;
    }
  }
}
