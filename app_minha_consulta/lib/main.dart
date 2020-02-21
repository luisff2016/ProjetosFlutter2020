import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:app_minha_consulta/utils.dart' as utils;
import 'minha_consulta.dart';

=======
import 'view/tela_login.dart';
>>>>>>> b2f6fe57c842dd1eba604799eb7eb47e0761f622

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  print("##1 main(): FlutterBook Starting");
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(MaterialApp(home: MinhaConsulta()));
  }
  startMeUp();
}