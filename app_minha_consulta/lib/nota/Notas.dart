import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'NotasForm.dart';
import 'NotasDB.dart';
import 'NotasList.dart';
import "NotasModel.dart" show NotasModel, notasModel;


/// ********************************************************************************************************************
/// Tela de Notas.
/// ********************************************************************************************************************
class Notas extends StatelessWidget {
  /// Constructor.
  Notas() {

    print("## nota Notas.constructor");

    // Carregamento inicial dos dados.
    notasModel.loadData("notas", NotasDB);

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("## nota Notes.build()");

    return ScopedModel<NotasModel>(
      model : notasModel,
      child : ScopedModelDescendant<NotasModel>(
        builder : (BuildContext inContext, Widget inChild, NotasModel inModel) {
          return IndexedStack(
            index : inModel.indicePilha,
            children : [
              NotasList(),
              NotasForm()
            ] /* End IndexedStack children. */
          ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
      ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


} /* End class. */
