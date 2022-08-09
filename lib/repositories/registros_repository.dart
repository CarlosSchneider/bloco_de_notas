/* ======================================================================================
 * Classe com a relação dos registros que já notifica os widgets responsivos
 * Versão 1.0.0
 * 
*/
import '/database/db.dart';
import '/models/grupos.dart';

export '/models/registros.dart';

class RegistrosRepository {
  List<Registro> registros = [];
  Grupo? _grupo = Grupo(nome: '');

  RegistrosRepository({Grupo? grupo}) {
    if (grupo != null) {
      _grupo = grupo;
      registros = _grupo?.registros ?? [];
    }
  }

  // o ID do grupo é campo obrigatório então essa rotina faz o teste para
  // verficar se o ID do grupo é válido
  Registro _testGrupoId(Registro registro) {
    if ((registro.grupoId ?? 0) > 0) return registro;
    if (_grupo!.id! > 0) {
      registro.grupoId = _grupo?.id;
      return registro;
    }
    throw Exception('Falha: Falta o grupo para o registro!');
  }

  // o ID do registro é campo obrigatório para alterar ou excluir o registro
  // verficar se o ID do registro é válido
  bool _testId(Registro registro) {
    if ((registro.id ?? 0) > 0) {
      return true;
    }
    throw Exception('Falha: o ID do registro é obrigatório para comando!');
  }

  Future<void> add({required Registro registro}) async {
    var db = await DB.get();
    registro = _testGrupoId(registro);
    registro.setId = await db.insert(DB.tableName(TableName.registro), registro.toMap(withID: false));
    registros.add(registro);
  }

  Future<void> update({required Registro registro}) async {
    if (!_testId(registro)) return;
    var db = await DB.get();
    await db.update(
      DB.tableName(TableName.registro),
      registro.toMap(withID: false),
      where: 'id = ?',
      whereArgs: [registro.id],
    );
    registros[registros.indexWhere((item) => item.id == registro.id)] = registro;
  }

  Future<void> delete({required Registro registro}) async {
    if (!_testId(registro)) return;
    var db = await DB.get();
    await db.delete(
      DB.tableName(TableName.registro),
      where: 'id = ?',
      whereArgs: [registro.id],
    );
    registros.removeWhere((item) => item.id == registro.id);
  }

  Future<List<Registro>> loadByGroup(int grupoId) async {
    grupoId = grupoId > 0
        ? grupoId
        : _grupo!.id! > 0
            ? _grupo!.id!
            : 0;
    if (grupoId == 0) return [];

    var db = await DB.get();
    List records = await db.query(
      DB.tableName(TableName.registro),
      where: 'grupo_id = ?',
      whereArgs: [grupoId],
    );
    for (var record in records) {
      registros.add(Registro.fromMap(record));
    }
    return registros;
  }
}
