import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ArqAudiosDB.dart";
import "ArqAudiosList.dart";
import "ArqAudiosForm.dart";
import "ArqAudiosModel.dart" show ArqAudiosModel, arqAudiosModel;

/// ********************************************************************************************************************
/// The AArqAudios screen.
/// ********************************************************************************************************************
class ArqAudios extends StatelessWidget {
  /// Constructor.
  ArqAudios() {
    print("##140 ArqAudios.constructor");

    // Initial load of data.
    arqAudiosModel.loadData("arqAudios", ArqAudiosDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##141 ArqAudios.build()");

    return ScopedModel<ArqAudiosModel>(
        model: arqAudiosModel,
        child: ScopedModelDescendant<ArqAudiosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ArqAudiosModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ArqAudiosList(),
            ArqAudiosForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
