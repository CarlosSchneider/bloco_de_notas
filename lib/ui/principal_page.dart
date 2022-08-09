// ignore_for_file: library_private_types_in_public_api

/* ======================================================================================
 * Formulário principal da aplicação
 * Versão 1.0.0
 * 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '/controllers/theme_controller.dart';
import '/repositories/grupos_repository.dart';
import 'registros_page.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  var themeController = MyThemeController.to;
  final _grupoNome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros particulares'),
        actions: <Widget>[
          IconButton(
            iconSize: 18,
            alignment: Alignment.topRight,
            icon: Obx(() => themeController.icon),
            onPressed: () => themeController.changeTheme(),
            tooltip: 'Muda o thema do aplicativo',
          ),
        ],
      ),
      body: Consumer<GruposRepository>(builder: (context, repositorio, child) {
        return ListView.builder(
          itemCount: repositorio.grupos.length,
          itemBuilder: (BuildContext contexto, int i) {
            final List<Grupo> tabela = repositorio.grupos;
            return _cardGrupo(context, tabela[i]);
          },
          padding: const EdgeInsets.all(3),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addGrupo(),
        tooltip: "Adicionar um novo grupo",
        elevation: 4.0,
        child: Container(margin: const EdgeInsets.all(15.0), child: const Icon(Icons.add)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(margin: const EdgeInsets.only(left: 12.0, right: 12.0), height: 35),
      ),
    );
  }

  // função para salvar um novo grupo
  void _addGrupo() async {
    await _showDialogGrupoAdd(context);
    if (_grupoNome.text == '') {
      Get.snackbar(
        'Falha!',
        'Operação cancelada!',
        backgroundColor: AppTheme.backgroundAlert,
        colorText: AppTheme.foregroundText,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final Grupo grupo = Grupo(nome: _grupoNome.text);
      // ignore: use_build_context_synchronously
      Provider.of<GruposRepository>(context, listen: false).addGrupo(grupo: grupo);
      _grupoNome.text = '';
      Get.snackbar(
        'Sucesso!',
        'Novo grupo criado!',
        backgroundColor: AppTheme.backgroundSuccess,
        colorText: AppTheme.foregroundText,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // função para excluir um grupo
  void _delGrupo({required Grupo grupo}) {
    String nome = grupo.nome;
    Provider.of<GruposRepository>(context, listen: false).deleteGrupo(grupo: grupo);

    Get.snackbar(
      'Atenção!',
      'Grupo $nome foi excluído!',
      backgroundColor: AppTheme.backgroundAlert,
      colorText: AppTheme.foregroundText,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // widget do cartão com a estrutra completa para apresentação do grupo
  Widget _cardGrupo(BuildContext context, Grupo grupo) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 12),
        title: Text(
          grupo.nome,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          alignment: Alignment.bottomRight,
          onPressed: () => _showDialogConfirmDelete(grupo),
        ),
        onTap: () {
          Get.to(
            () => RegistrosPage(
              key: Key(grupo.nome),
              grupo: grupo,
            ),
          );
        },
      ),
    );
  }

  // Dialog Popup para solicitar o nome de um novo grupo
  Future<void> _showDialogGrupoAdd(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Qual é o nome do novo grupo?'),
          actionsAlignment: MainAxisAlignment.spaceAround,
          elevation: 20,
          content: TextField(
            controller: _grupoNome,
            decoration: const InputDecoration(hintText: "Nome para o grupo"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.backgroundCaution,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                elevation: 6,
              ),
              child: const Text('CANCELAR', style: TextStyle(color: AppTheme.foregroundText)),
              onPressed: () {
                _grupoNome.text = '';
                Get.back();
              },
            ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppTheme.backgroundSuccess,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  elevation: 6,
                ),
                child: const Text('SALVAR', style: TextStyle(color: AppTheme.foregroundText)),
                onPressed: () => Get.back()),
          ],
        );
      },
    );
  }

  // Dialog Popup para confirmar a exclusão de um grupo
  Future<void> _showDialogConfirmDelete(Grupo grupo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exclusão de Grupo!'),
          actionsAlignment: MainAxisAlignment.spaceAround,
          elevation: 28,
          content: const SingleChildScrollView(
              child: Text(
                  'Ao excluir o grupo, todos os registros vinculados também serão excluido.\n\nConfirma a exclusão?')),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                elevation: 6,
              ),
              child: const Text('Excluir', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Get.back();
                _delGrupo(grupo: grupo);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                elevation: 6,
              ),
              child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Atenção!',
                  'Operação cancelada!',
                  backgroundColor: Colors.grey[800],
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
