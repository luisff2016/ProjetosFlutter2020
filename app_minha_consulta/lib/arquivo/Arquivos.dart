import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ArquivosDB.dart";
import "ArquivosList.dart";
import "ArquivosForm.dart";
import "ArquivosModel.dart" show ArquivosModel, arquivosModel;

/// ********************************************************************************************************************
/// The Arquivos screen.
/// ********************************************************************************************************************
class Arquivos extends StatelessWidget {
  /// Constructor.
  Arquivos() {
    print("##140 Arquivos.constructor");

    // Initial load of data.
    arquivosModel.loadData("arquivos", ArquivosDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##141 Arquivos.build()");

    return ScopedModel<ArquivosModel>(
        model: arquivosModel,
        child: ScopedModelDescendant<ArquivosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ArquivosModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ArquivosList(),
            ArquivosForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
