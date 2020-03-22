import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ConsultasDB.dart";
import "ConsultasList.dart";
import "ConsultasForm.dart";
import "ConsultasModel.dart" show ConsultasModel, consultasModel;

/// ********************************************************************************************************************
/// The Consultas screen.
/// ********************************************************************************************************************
class Consultas extends StatelessWidget {
  /// Constructor.
  Consultas() {
    print("##140 Consultas.constructor");

    // Initial load of data.
    consultasModel.loadData("Consultas", ConsultasDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## Consultas.build()");

    return ScopedModel<ConsultasModel>(
        model: consultasModel,
        child: ScopedModelDescendant<ConsultasModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ConsultasModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ConsultasList(),
            ConsultasForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
