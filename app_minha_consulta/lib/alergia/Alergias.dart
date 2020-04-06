import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "AlergiasModel.dart" show AlergiasModel, alergiasModel;
import 'AlergiasDB.dart';
import 'AlergiasList.dart';

/// ********************************************************************************************************************
/// The Alergias screen.
/// ********************************************************************************************************************
class Alergia extends StatelessWidget {
  /// Constructor.
  Alergia() {
    print("## alergia Alergias.constructor");
    // Initial load of data.
    alergiasModel.loadData("alergia", AlergiasDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## 63 alergia Alergias.build()");
    return ScopedModel<AlergiasModel>(
        model: alergiasModel,
        child: ScopedModelDescendant<AlergiasModel>(builder:
                (BuildContext inContext, Widget inChild,
                    AlergiasModel inModel) {
          return Scaffold(
              // Add arqDocumento.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {}),
              body: Column(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: AlergiasList()) /* End Container. */
                    ) /* End Expanded. */
              ] /* End Column.children. */
                  ) /* End Column. */
              );
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
