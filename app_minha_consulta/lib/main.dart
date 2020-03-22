import 'dart:io';
import 'package:app_minha_consulta/teste/teste.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_minha_consulta/utils.dart' as utils;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("## main(): Inicio do Minha Consulta 2.0");

  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();

    utils.docsDir = docsDir;

    print("## main(): utils.docsDir = $docsDir !");
    print("## main(): realizar entrada de dados para teste!");
    runApp(MaterialApp(home: Teste()));
  }

  startMeUp();
}
