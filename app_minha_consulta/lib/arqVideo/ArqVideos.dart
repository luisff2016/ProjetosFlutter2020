import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ArqVideosDB.dart";
import "ArqVideosList.dart";
import "ArqVideosForm.dart";
import "ArqVideosModel.dart" show ArqVideosModel, arqVideosModel;

/// ********************************************************************************************************************
/// The ArqVideos screen.
/// ********************************************************************************************************************
class ArqVideos extends StatelessWidget {
  /// Constructor.
  ArqVideos() {
    print("##140 ArqVideos.constructor");

    // Initial load of data.
    arqVideosModel.loadData("arqVideos", ArqVideosDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##141 ArqVideos.build()");

    return ScopedModel<ArqVideosModel>(
        model: arqVideosModel,
        child: ScopedModelDescendant<ArqVideosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ArqVideosModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            ArqVideosList(),
            ArqVideosForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
