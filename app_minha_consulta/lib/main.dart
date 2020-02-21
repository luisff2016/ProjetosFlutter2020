import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:app_minha_consulta/utils.dart' as utils;
import 'minha_consulta.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print("##1 main(): FlutterBook Starting");
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(MaterialApp(home: MinhaConsulta()));
  }
  startMeUp();
}