import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "UsuariosDB.dart";
import "UsuariosModel.dart" show Usuario, UsuariosModel, usuariosModel;

/// ****************************************************************************
/// Lista de Usuarios - tela secundaria.
/// ****************************************************************************
class UsuariosList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## usuario UsuariosList.build()");

    // Return widget.
    return ScopedModel<UsuariosModel>(
        model: usuariosModel,
        child: ScopedModelDescendant<UsuariosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    UsuariosModel inModel) {
          return Scaffold(
              // Add Usuario.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    usuariosModel.entityBeingEdited = Usuario();
                    usuariosModel.setColor(null);
                    usuariosModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: usuariosModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Usuario usuario = usuariosModel.entityList[inIndex];
                    // Determine Usuario.ckground color (default to white if none was selected).
                    Color color = Colors.white;
                    switch (usuario.color) {
                      case "red":
                        color = Colors.red;
                        break;
                      case "green":
                        color = Colors.green;
                        break;
                      case "blue":
                        color = Colors.blue;
                        break;
                      case "yellow":
                        color = Colors.yellow;
                        break;
                      case "grey":
                        color = Colors.grey;
                        break;
                      case "purple":
                        color = Colors.purple;
                        break;
                    }
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            //SlidableDrawerDelegate(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      _deleteUsuario(inContext, usuario))
                            ],
                            actionPane: null,
                            child: Card(
                                elevation: 8,
                                color: color,
                                child: ListTile(
                                    title: Text("${usuario.protocolo}"),
                                    subtitle: Text("${usuario.cpf}"),
                                    // Edit existing Usuario.
                                    onTap: () async {
                                      // Get the data from the database and send to the edit view.
                                      usuariosModel.entityBeingEdited =
                                          await UsuariosDB.db.get(usuario.id);
                                      usuariosModel.setColor(usuariosModel
                                          .entityBeingEdited.color);
                                      usuariosModel.setStackIndex(1);
                                    })) /* End Card. */
                            ) /* End Slidable. */
                        ); /* End Container. */
                  } /* End itemBuilder. */
                  ) /* End End ListView.builder. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder. */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext The BuildContext of the parent Widget.
  /// @param  inUsuario. The Usuario.otentially) being deleted.
  /// @return           Future.
  Future _deleteUsuario(BuildContext inContext, Usuario inUsuario) async {
    print("## usuario UsuariosList._deleteUsuario. inUsuario.$inUsuario");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Deletar Usuario"),
              content: Text(
                  "Are you sure you want to delete ${inUsuario.protocolo}?"),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }),
                FlatButton(
                    child: Text("Deletar"),
                    onPressed: () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await UsuariosDB.db.delete(inUsuario.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Usuario deletada")));
                      // Reload data from database to update list.
                      usuariosModel.loadData("usuarios", UsuariosDB.db);
                    })
              ]);
        });
  } /* End _deleteUsuario. */

} /* End class. */
