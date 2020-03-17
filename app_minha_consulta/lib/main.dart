//import 'package:app_minha_consulta/teste.dart';
import 'package:app_minha_consulta/view/tela_login.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:app_minha_consulta/utils.dart' as utils;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("##001 main(): FlutterBook Starting");
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    print("##002 main(): $docsDir !");
    runApp(MaterialApp(home: TelaLogin()));
  }

  startMeUp();
}
