import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/settings_controller.dart';

mixin HealthHintsMixin<T extends StatefulWidget> on State<T> {
  Timer? _toastTimer;
  int _intervaloHoras = 3; // Intervalo padrão (3 horas)

  final List<String> _dicasNutricionais = [
    "Beba água regularmente, mesmo sem sentir sede.",
    "Inclua frutas e vegetais de cores variadas no seu prato.",
    "Leia os rótulos antes de comprar alimentos embalados.",
    "Evite consumir açúcar em excesso, prefira alimentos naturais.",
    "Coma devagar e preste atenção ao sabor dos alimentos.",
    "Alimentos integrais são ricos em fibras, experimente incluí-los!",
    "Evite refeições muito pesadas à noite.",
    "A prática de mastigar bem os alimentos melhora a digestão."
  ];

  int get intervaloAtual => _intervaloHoras;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes(); // Carrega as configurações salvas
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  Future<void> carregarConfiguracoes() async {
    // Recupera as configurações salvas
    _intervaloHoras = await Get.find<SettingsController>().loadHintsInterval();
    // Inicia o Timer com as configurações carregadas
    _iniciarToastAutomatico();
  }

  void _iniciarToastAutomatico() {
    // Cancela qualquer timer anterior
    _toastTimer?.cancel();

    // Inicia um novo timer com o intervalo configurado
    _toastTimer = Timer.periodic(Duration(hours: _intervaloHoras), (timer) {
      _exibirDicaNutricional();
    });
  }

  void _exibirDicaNutricional() {
    final random = Random();
    final dica = _dicasNutricionais[random.nextInt(_dicasNutricionais.length)];

    Fluttertoast.showToast(
      msg: dica,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> ajustarIntervalo(BuildContext context, bool isPremium) async {
    if (!isPremium) {
      mostrarMensagem('Essa funcionalidade é exclusiva para usuários premium!');
      return;
    }

    final novoIntervalo = await _mostrarDialogoIntervalo(context);
    if (novoIntervalo != null) {
      setState(() {
        _intervaloHoras = novoIntervalo;
      });

      // Salva o novo intervalo
      Get.find<SettingsController>().saveHintsInterval(_intervaloHoras);

      _iniciarToastAutomatico();
    }
  }

  Future<int?> _mostrarDialogoIntervalo(BuildContext context) async {
    int? valorSelecionado;
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alterar Intervalo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecione o intervalo de horas entre as dicas:'),
              DropdownButton<int>(
                value: valorSelecionado ?? _intervaloHoras,
                items: [1, 2, 3, 4, 6, 12, 24]
                    .map((e) => DropdownMenuItem<int>(
                          value: e,
                          child: Text('$e horas'),
                        ))
                    .toList(),
                onChanged: (value) {
                  valorSelecionado = value;
                },
              ),
              ElevatedButton(
                onPressed: _exibirDicaNutricional,
                child: Text('Testar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, valorSelecionado),
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarMensagem(String mensagem) {
    Fluttertoast.showToast(
      msg: mensagem,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red[700],
      textColor: Colors.white,
    );
  }

  void exibirDicaNutricional() {
    final random = Random();
    final dica = _dicasNutricionais[random.nextInt(_dicasNutricionais.length)];

    Fluttertoast.showToast(
      msg: dica,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green[700],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
