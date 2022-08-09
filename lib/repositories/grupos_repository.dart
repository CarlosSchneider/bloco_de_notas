/* ======================================================================================
 * Classe com a relação dos registros que já notifica os widgets responsivos
 * Versão 1.0.0
 * 
*/
import 'dart:collection';
import 'package:flutter/material.dart';

import '/database/db.dart';
import '/models/grupos.dart';
import 'registros_repository.dart';

export '/models/grupos.dart';

class GruposRepository extends ChangeNotifier {
  final List<Grupo> _grupos = [];
  final loading = ValueNotifier(false);

  UnmodifiableListView<Grupo> get grupos => UnmodifiableListView(_grupos);

  GruposRepository() {
    initRepository();
  }

  // função para buscar um grupo entre os carregados
  Grupo find({required int id}) {
    return _grupos.firstWhere((element) => element.id == id);
  }

  void addGrupo({required Grupo grupo}) async {
    var db = await DB.get();
    int id = await db.insert(DB.tableName(TableName.grupo), grupo.toMap(withID: false));
    grupo.id = id;
    _grupos.add(Grupo(nome: grupo.nome, id: grupo.id));
    notifyListeners();
  }

  void updateGrupo({required Grupo grupo}) async {
    var db = await DB.get();
    await db.update(
      DB.tableName(TableName.grupo),
      grupo.toMap(withID: false),
      where: 'id = ?',
      whereArgs: [grupo.id],
    );
    _grupos[_grupos.indexWhere((item) => item.id == grupo.id)] = grupo;
    notifyListeners();
  }

  void deleteGrupo({required Grupo grupo}) async {
    var db = await DB.get();
    await db.delete(
      DB.tableName(TableName.grupo),
      where: 'id = ?',
      whereArgs: [grupo.id],
    );
    _grupos.removeWhere((item) => item.id == grupo.id);
    notifyListeners();
  }

  showLoading(bool valor) {
    loading.value = valor;
    notifyListeners();
  }

  initRepository() async {
    showLoading(true);
    var db = await DB.get();
    List records = await db.query(DB.tableName(TableName.grupo));
    if (records.isNotEmpty) {
      _grupos.clear();
      for (var record in records) {
        var grupo = Grupo.fromMap(record);
        grupo.registros = await RegistrosRepository().loadByGroup(grupo.id ?? 0);
        _grupos.add(grupo);
      }
    }
    showLoading(false);
  }

  // reaproveitar os recursos do RegistrosRepository
  void addRegistro({required Grupo grupo, required Registro registro}) async {
    await RegistrosRepository(grupo: grupo).add(registro: registro);
    notifyListeners();
  }

  void updateRegistro({required Grupo grupo, required Registro registro}) async {
    await RegistrosRepository(grupo: grupo).update(registro: registro);
    notifyListeners();
  }

  void deleteRegistro({required Grupo grupo, required Registro registro}) async {
    await RegistrosRepository(grupo: grupo).delete(registro: registro);
    notifyListeners();
  }
}
