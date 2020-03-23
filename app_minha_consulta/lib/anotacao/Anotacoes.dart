import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "AnotacoesDB.dart";
import "AnotacoesList.dart";
import "AnotacoesForm.dart";
import "AnotacoesModel.dart" show AnotacoesModel, anotacoesModel;

/// ********************************************************************************************************************
/// The Anotacoes screen.
/// ********************************************************************************************************************
class Anotacoes extends StatelessWidget {
  /// Constructor.
  Anotacoes() {
    print("##140 Anotacoes.constructor");

    // Initial load of data.
    anotacoesModel.loadData("anotacao", AnotacoesDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##141 Anotacoes.build()");

    return ScopedModel<AnotacoesModel>(
        model: anotacoesModel,
        child: ScopedModelDescendant<AnotacoesModel>(builder:
                (BuildContext inContext, Widget inChild,
                    AnotacoesModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            AnotacoesList(),
            AnotacoesForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
