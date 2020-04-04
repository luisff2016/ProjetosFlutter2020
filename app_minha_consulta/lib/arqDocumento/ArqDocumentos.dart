import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ArqDocumentosDB.dart";
import "ArqDocumentosList.dart";
import "ArqDocumentosForm.dart";
import "ArqDocumentosModel.dart" show ArqDocumentosModel, arqDocumentosModel;

/// ********************************************************************************************************************
/// The ArqDocumentos screen.
/// ********************************************************************************************************************
class ArqDocumentos extends StatelessWidget {
  
  /// Constructor.
  ArqDocumentos() {
    print("##140 ArqDocumentos.constructor");

    // Initial load of data.
    arqDocumentosModel.loadData("arqDocumentos", ArqDocumentosDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##141 ArqDocumentos.build()");

    return ScopedModel<ArqDocumentosModel>(
        model: arqDocumentosModel,
        child: ScopedModelDescendant<ArqDocumentosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ArqDocumentosModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ArqDocumentosList(),
            ArqDocumentosForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  
  } /* End build(). */

} /* End class. */