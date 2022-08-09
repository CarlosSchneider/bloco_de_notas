// arquivo de inicialização do sistema

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'ui/principal_page.dart';
import 'controllers/theme_controller.dart';
import 'repositories/grupos_repository.dart';

void main() {
  Get.lazyPut<MyThemeController>(() => MyThemeController());

  runApp(
    ChangeNotifierProvider(
      create: (context) => GruposRepository(),
      child: const AppInicial(),
    ),
  );
}

class AppInicial extends StatelessWidget {
  const AppInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyThemeController.to.loadThemeMode();
    return GetMaterialApp(
      title: 'Registros particulares',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const PrincipalPage(),
    );
  }
}
