/* ======================================================================================
 * Modulo de acesso ao banco de dados usando o SQFLite
 * Versão 1.0.0
 * 
*/
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'grupos_structure.dart' as db_grupo;
import 'registros_structure.dart' as db_registro;

enum TableName { grupo, registro }

class DB {
  DB._();
  static final DB instance = DB._();
  static late Database _database;

  // Houve algumas falhas na inicialização do banco de dados devido a isso foi adicionado
  // os testes "absurdos" abaixo
  Future<Database> get database async {
    try {
      if (!_database.isOpen) _database = await initDatabase();
    } catch (e) {
      _database = await initDatabase();
    }
    return _database;
  }

  static tableName(TableName tabela) {
    return tabela == TableName.grupo ? db_grupo.TABLE_NAME : db_registro.TABLE_NAME;
  }

  static get() async {
    return await DB.instance.database;
  }

  initDatabase() async {
    var diretorio = await getDatabasesPath();
    return await openDatabase(
      '$diretorio/registros.db',
      version: 1,
      onCreate: (db, versao) async {
        await db.execute(db_grupo.CREATE_TABLE);
        await db.execute(db_registro.CREATE_TABLE);
      },
    );
  }
}
