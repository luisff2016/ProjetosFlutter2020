import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'UsuariosForm.dart';
import 'UsuariosDB.dart';
import 'UsuariosList.dart';
import "UsuariosModel.dart" show UsuariosModel, usuariosModel;


/// ********************************************************************************************************************
/// Tela de Usuarios.
/// ********************************************************************************************************************
class Usuarios extends StatelessWidget {
  /// Constructor.
  Usuarios() {

    print("## usuario Usuarios.constructor");

    // Carregamento inicial dos dados.
    usuariosModel.loadData("usuarios", UsuariosDB.db);

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("## usuario Usuarios.build()");

    return ScopedModel<UsuariosModel>(
      model : usuariosModel,
      child : ScopedModelDescendant<UsuariosModel>(
        builder : (BuildContext inContext, Widget inChild, UsuariosModel inModel) {
          return IndexedStack(
            index : inModel.stackIndex,
            children : [
              UsuariosList(),
              UsuariosForm()
            ] /* End IndexedStack children. */
          ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
      ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


} /* End class. */
