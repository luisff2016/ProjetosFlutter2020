import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ArqFotosDB.dart";
import "ArqFotosList.dart";
import "ArqFotosForm.dart";
import "ArqFotosModel.dart" show ArqFotosModel, arqFotosModel;


/// ********************************************************************************************************************
/// The ArqFotos screen.
/// ********************************************************************************************************************

class ArqFotos extends StatelessWidget {
  /// Constructor.
  ArqFotos() {

    print("##140 arqFoto ArqFotos.constructor");
    // Initial load of data.
    arqFotosModel.loadData("arqFotos", ArqFotosDB.db);

  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##141 arqFoto ArqFotos.build()");

    return ScopedModel<ArqFotosModel>(
        model: arqFotosModel,
        child: ScopedModelDescendant<ArqFotosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ArqFotosModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ArqFotosList(),
            ArqFotosForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */

  } /* End build(). */

} /* End class. */