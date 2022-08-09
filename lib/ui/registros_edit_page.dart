// ignore_for_file: library_private_types_in_public_api

/* ======================================================================================
 * Formulário para edição de um registro
 * Versão 1.0.0
 * 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '/controllers/theme_controller.dart';
import '/repositories/grupos_repository.dart';

class EditRegistrosPage extends StatefulWidget {
  final Registro registro;
  final Grupo grupo;
  const EditRegistrosPage({Key? key, required this.registro, required this.grupo}) : super(key: key);

  @override
  _EditRegistrosPageState createState() => _EditRegistrosPageState();
}

class _EditRegistrosPageState extends State<EditRegistrosPage> {
  final _nome = TextEditingController();
  final _chave = TextEditingController();
  final _complemento = TextEditingController();
  final _observacoes = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nome.text = widget.registro.nome;
    _chave.text = widget.registro.chave;
    _complemento.text = widget.registro.complemento ?? '';
    _observacoes.text = widget.registro.observacoes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Registros')),
      body: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _nomeInput(),
                      _chaveInput(),
                      _complementoInput(),
                      _observacoesInput(),
                    ],
                  ),
                )),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottonButtonVoltar(),
            _bottonButtonSalvar(),
          ],
        ),
      ),
    );
  }

  Widget _nomeInput() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 12),
        child: TextFormField(
          controller: _nome,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nome do registro',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o bome para o registro!';
            }
            return null;
          },
        ),
      );

  Widget _chaveInput() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: TextFormField(
          controller: _chave,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Palavra chave para o registro',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o ano do titulo!';
            }
            return null;
          },
        ),
      );

  Widget _complementoInput() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: TextFormField(
          minLines: 3,
          maxLines: 10,
          controller: _complemento,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Complemento para identificação',
          ),
        ),
      );

  Widget _observacoesInput() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: TextFormField(
          minLines: 6,
          maxLines: 10,
          controller: _observacoes,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Observações',
          ),
        ),
      );

  Widget _bottonButtonSalvar() => Expanded(
        child: TextButton.icon(
          icon: const Icon(Icons.save, color: AppTheme.foregroundText),
          style: TextButton.styleFrom(
            backgroundColor: AppTheme.backgroundSuccess,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            elevation: 6,
          ),
          label: const Text('Salvar', style: TextStyle(color: AppTheme.foregroundText)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Get.back();
              widget.registro.nome = _nome.text;
              widget.registro.chave = _chave.text;
              widget.registro.complemento = _complemento.text;
              widget.registro.observacoes = _observacoes.text;
              if ((widget.registro.id ?? 0) > 0) {
                Provider.of<GruposRepository>(context, listen: false)
                    .updateRegistro(grupo: widget.grupo, registro: widget.registro);
              } else {
                Provider.of<GruposRepository>(context, listen: false)
                    .addRegistro(grupo: widget.grupo, registro: widget.registro);
              }
            }
          },
        ),
      );

  Widget _bottonButtonVoltar() => Expanded(
        child: TextButton.icon(
          icon: const Icon(Icons.arrow_back_sharp, color: AppTheme.foregroundText),
          style: TextButton.styleFrom(
            backgroundColor: AppTheme.backgroundAlert,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            elevation: 6,
          ),
          label: const Text('Voltar', style: TextStyle(color: AppTheme.foregroundText)),
          onPressed: () {
            Get.back();
          },
        ),
      );

// FIM
}
