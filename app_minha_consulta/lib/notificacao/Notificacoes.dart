import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "NotificacoesDB.dart";
import "NotificacoesList.dart";
import "NotificacoesForm.dart";
import "NotificacoesModel.dart" show NotificacoesModel, notificacoesModel;

/// ********************************************************************************************************************
/// The Notificacoes screen.
/// ********************************************************************************************************************
class Notificacoes extends StatelessWidget {
  /// Constructor.
  Notificacoes() {
    print("##  notificacao Notificacoes.constructor");

    // Initial load of data.
    notificacoesModel.loadData("notificacoes", NotificacoesDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## notificacao Notificacoes.build()");

    return ScopedModel<NotificacoesModel>(
        model: notificacoesModel,
        child: ScopedModelDescendant<NotificacoesModel>(builder:
                (BuildContext inContext, Widget inChild,
                    NotificacoesModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            NotificacoesList(),
            NotificacoesForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
