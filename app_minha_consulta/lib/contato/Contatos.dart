import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "ContatosDB.dart";
import "ContatosList.dart";
import "ContatosForm.dart";
import "ContatosModel.dart" show ContatosModel, contatosModel;


/// ********************************************************************************************************************
/// The Contatos screen.
/// ********************************************************************************************************************
class Contatos extends StatelessWidget {


  /// Constructor.
  Contatos() {

    print("##95 Contacts.constructor");

    // Initial load of data.
    ContatosModel.loadData("contacts", ContatosDB.db);

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##96 Contacts.build()");

    return ScopedModel<ContatosModel>(
      model : ContatosModel,
      child : ScopedModelDescendant<ContatosModel>(
        builder : (BuildContext inContext, Widget inChild, ContatosModel inModel) {
          return IndexedStack(
            index : inModel.stackIndex,
            children : [
              ContatosList(),
              ContatosForm()
            ] /* End IndexedStack children. */
          ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
      ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


} /* End class. */
