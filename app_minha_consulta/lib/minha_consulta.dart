import 'package:flutter/material.dart';

import 'contato/Contatos.dart';
import 'medicamento/Medicamentos.dart';
import 'nota/Notas.dart';
import 'view/home_page.dart';

class MinhaConsulta extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##7 MinhaConsulta.build()");

    return MaterialApp(
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                    title: Text("Minha Consulta 2.0"),
                    bottom: TabBar(tabs: [
                      Tab(icon: Icon(Icons.date_range), text: "Anotações"),
                      Tab(icon: Icon(Icons.contacts), text: "Contatos"),
                      Tab(icon: Icon(Icons.note), text: "Alergias"),
                      Tab(
                          icon: Icon(Icons.assignment_turned_in),
                          text: "Medicações")
                    ] /* End TabBar.tabs. */
                        ) /* End TabBar. */
                    ),
                /* End AppBar. */
                body: TabBarView(children: [
                  //Teste(),
                  HomePage(),//Anotacoes(),
                  //Teste(),
                  Contatos(),
                  //Teste(),
                  Notas(),
                  //Teste(),
                  Medicamentos(),
                ] /* End TabBarView.children. */
                    ) /* End TabBarView. */
                ) /* End Scaffold. */
            ) /* End DefaultTabController. */
        ); /* End MaterialApp. */
  } /* End build(). */

} /* End class. */

/*//diretorio dos arquivos
  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}

// outros
ServicesBinding.instance.defaultBinaryMessenger;
 */
