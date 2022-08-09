// ignore_for_file: constant_identifier_names

/* ======================================================================================
 * Cadastro de grupos para filtros de registros
 * Versão 1.0.0
 * 
*/

const CREATE_TABLE = '''
CREATE TABLE grupo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT
);
''';

const TABLE_NAME = 'grupo';
