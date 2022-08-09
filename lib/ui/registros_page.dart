// ignore_for_file: library_private_types_in_public_api

/* ======================================================================================
 * Formulário para listagem dos registros de um grupo selecionado na página principal
 * Versão 1.0.0
 * 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '/controllers/theme_controller.dart';
import '/repositories/grupos_repository.dart';
import 'registros_edit_page.dart';

class RegistrosPage extends StatefulWidget {
  final Grupo grupo;
  const RegistrosPage({required Key key, required this.grupo}) : super(key: key);

  @override
  _RegistrosPageState createState() => _RegistrosPageState();
}

class _RegistrosPageState extends State<RegistrosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grupo.nome),
      ),
      body: Consumer<GruposRepository>(builder: (context, repositorio, child) {
        return ListView.builder(
          itemCount: widget.grupo.registros.length,
          itemBuilder: (BuildContext contexto, int i) {
            final List<Registro> tabela = widget.grupo.registros;
            return _cardRegistro(context, tabela[i]);
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => EditRegistrosPage(
                grupo: widget.grupo,
                registro: Registro(grupoId: widget.grupo.id, nome: '', chave: ''),
              ));
        },
        tooltip: "Adicionar um novo registro ao grupo",
        elevation: 4.0,
        child: Container(margin: const EdgeInsets.all(15.0), child: const Icon(Icons.add)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(margin: const EdgeInsets.only(left: 12.0, right: 12.0), height: 35),
      ),
    );
  }

  // widget do cartão com a estrutra completa para apresentação do grupo
  Widget _cardRegistro(BuildContext context, Registro registro) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(6, 3, 3, 12),
          title: Text(registro.nome),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(registro.chave),
              Text(registro.complemento ?? ''),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDialogConfirmDelete(registro),
          ),
          onTap: () {
            Get.to(
              () => EditRegistrosPage(
                key: Key(registro.nome),
                grupo: widget.grupo,
                registro: registro,
              ),
            );
          }),
    );
  }

  // Dialog Popup para confirmar a exclusão de um registro
  Future<void> _showDialogConfirmDelete(Registro registro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exclusão de Registro!'),
          actionsAlignment: MainAxisAlignment.spaceAround,
          elevation: 28,
          content: const SingleChildScrollView(child: Text("O registro será excluido.\n\nConfirma a exclusão?")),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.backgroundCaution,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                elevation: 6,
              ),
              child: const Text('Excluir', style: TextStyle(color: AppTheme.foregroundText)),
              onPressed: () {
                Get.back();
                Provider.of<GruposRepository>(context, listen: false).deleteRegistro(
                  grupo: widget.grupo,
                  registro: registro,
                );

                Get.snackbar(
                  'Atenção!',
                  'O registro foi excluído!',
                  backgroundColor: AppTheme.backgroundAlert,
                  colorText: AppTheme.foregroundText,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.backgroundSuccess,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                elevation: 6,
              ),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.foregroundText)),
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Atenção!',
                  'Operação cancelada!',
                  backgroundColor: AppTheme.backgroundAlert,
                  colorText: AppTheme.foregroundText,
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
