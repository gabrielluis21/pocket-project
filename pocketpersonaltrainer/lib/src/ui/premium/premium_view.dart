// views/premium_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/purchase_controller.dart';

class PremiumView extends StatelessWidget {
  PremiumView({super.key});

  final PurchaseController premiumController = Get.find(tag: 'purchase');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recursos Premium')),
      body: Obx(() {
        final isPremium = premiumController.isPremium.value;
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('Remoção de anúncios'),
              trailing: Icon(Icons.check, color: isPremium ? Colors.green : Colors.grey),
            ),
            ListTile(
              title: Text('Localização de academias próximas'),
              trailing: Icon(Icons.check, color: isPremium ? Colors.green : Colors.grey),
            ),
            ListTile(
              title: Text('Planejamento avançado de treinos(EM DESENVOLVIMENTO...)'),
              trailing: Icon(Icons.check, color: isPremium ? Colors.green : Colors.grey),
            ),
            ListTile(
              title: Text('Relatórios detalhados de progresso(EM DESENVOLVIMENTO...)'),
              trailing: Icon(Icons.check, color: isPremium ? Colors.green : Colors.grey),
            ),
            ListTile(
              title: Text.rich(TextSpan(text: 'Tudo por  apenas', children: [
                TextSpan(
                  text: ' R\$ 15,99 \n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: 'Ao adcionarmos mais recurso, o valor irá aumentar e TODOS os assinantes serão avisados por e-mail.',
                  style: TextStyle(fontSize: 12),
                )
              ])),
              subtitle: Text('Assine agora e aproveite todos os recursos premium!'),
            ),
            if (!isPremium)
              ElevatedButton(
                onPressed: () {
                  if (premiumController.availableProducts.isNotEmpty) {
                    premiumController.buyPremium();
                  }
                },
                child: Text('Ativar Premium'),
              ),
          ],
        );
      }),
    );
  }
}
