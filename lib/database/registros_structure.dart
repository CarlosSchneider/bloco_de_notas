// ignore_for_file: constant_identifier_names

/* ======================================================================================
 * Cadastro de grupos para filtros de registros
 * Versão 1.0.0
 * 
*/

const CREATE_TABLE = '''
CREATE TABLE registros (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT,
  chave TEXT,
  complemento TEXT,
  observacoes TEXT,
  grupo_id INTEGER,
  FOREIGN KEY (grupo_id) REFERENCES grupos(id) ON DELETE CASCADE
);
''';

const TABLE_NAME = 'registros';
