import 'dart:io';
import 'package:app_minha_consulta/view/tela_login.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_minha_consulta/utils.dart' as utils;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("## main(): Inicio do Minha Consulta 2.0");
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();

    utils.docsDir = docsDir;
    print("## main(): utils.docsDir = $docsDir !");
    runApp(MaterialApp(home: TelaLogin()));
  }

  startMeUp();
}
