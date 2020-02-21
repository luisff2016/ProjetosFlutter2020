import "dart:io";
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:path/path.dart";
import "../utils.dart" as utils;
import "ContatosDB.dart";
import "ContatosModel.dart" show Contato, ContatosModel, contatosModel;


/// ********************************************************************************************************************
/// The Contatos List sub-screen.
/// ********************************************************************************************************************
class ContatosList extends StatelessWidget {


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##65 ContatosList.build()");

    // Return widget.
    return ScopedModel<ContatosModel>(
      model : contatosModel,
      child : ScopedModelDescendant<ContatosModel>(
        builder : (BuildContext inContext, Widget inChild, ContatosModel inModel) {
          return Scaffold(
            // Add Contato.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                // Delete avatar file if it exists (it shouldn't, but better safe than sorry!)
                File avatarFile = File(join(utils.docsDir.path, "avatar"));
                if (avatarFile.existsSync()) {
                  avatarFile.deleteSync();
                }
                contatosModel.entityBeingEdited = Contato();
                contatosModel.setChosenDate(null);
                contatosModel.setStackIndex(1);
              }
            ),
            body : ListView.builder(
              itemCount : contatosModel.entityList.length,
              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                Contato contato = contatosModel.entityList[inIndex];
                // Get reference to avatar file and see if it exists.
                File avatarFile = File(join(utils.docsDir.path, contato.id.toString()));
                bool avatarFileExists = avatarFile.existsSync();
                print("##66 ContatosList.build(): avatarFile: $avatarFile -- avatarFileExists=$avatarFileExists");
                return Column(
                  children : [
                    Slidable(
                      actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                      actionExtentRatio : .25,
                      child : ListTile(
                        leading : CircleAvatar(
                          backgroundColor : Colors.indigoAccent,
                          foregroundColor : Colors.white,
                          backgroundImage : avatarFileExists ? FileImage(avatarFile) : null,
                          child : avatarFileExists ? null : Text(contato.name.substring(0, 1).toUpperCase())
                        ),
                        title : Text("${contato.name}"),
                        subtitle : contato.phone == null ? null : Text("${contato.phone}"),
                        // Edit existing Contato.
                        onTap : () async {
                          // Delete avatar file if it exists (it shouldn't, but better safe than sorry!)
                          File avatarFile = File(join(utils.docsDir.path, "avatar"));
                          if (avatarFile.existsSync()) {
                            avatarFile.deleteSync();
                          }
                          // Get the data from the database and send to the edit view.
                          contatosModel.entityBeingEdited = await ContatosDB.db.get(contato.id);
                          // Parse out the  birthday, if any, and set it in the model for display.
                          if (contatosModel.entityBeingEdited.birthday == null) {
                            contatosModel.setChosenDate(null);
                          } else {
                            List dateParts = contatosModel.entityBeingEdited.birthday.split(",");
                            DateTime birthday = DateTime(
                              int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
                            );
                            contatosModel.setChosenDate(DateFormat.yMMMMd("en_US").format(birthday.toLocal()));
                          }
                          contatosModel.setStackIndex(1);
                        }
                      ),
                      secondaryActions : [
                        IconSlideAction(
                          caption : "Delete",
                          color : Colors.red,
                          icon : Icons.delete,
                          onTap : () => _deleteContato(inContext, contato)
                        )
                      ]
                    ),
                    Divider()
                  ]
                ); /* End Column. */
              } /* End itemBuilder. */
            ) /* End ListView.builder. */
          ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder. */
      ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext The parent build context.
  /// @param  inContato The Contato (potentially) being deleted.
  /// @return           Future.
  Future _deleteContato(BuildContext inContext, Contato inContato) async {

    print("##67 ContatosList._deleteContato(): inContato = $inContato");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Contato"),
          content : Text("Are you sure you want to delete ${inContato.name}?"),
          actions : [
            FlatButton(child : Text("Cancel"),
              onPressed: () {
                // Just hide dialog.
                Navigator.of(inAlertContext).pop();
              }
            ),
            FlatButton(child : Text("Delete"),
              onPressed : () async {
                // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                // Also, don't forget to delete the avatar file or else new Contatos created might wind up with an
                // ID of a file that's present from a previously deleted Contato!
                File avatarFile = File(join(utils.docsDir.path, inContato.id.toString()));
                if (avatarFile.existsSync()) {
                  avatarFile.deleteSync();
                }
                await ContatosDB.db.delete(inContato.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Contato deleted")
                  )
                );
                // Reload data from database to update list.
                contatosModel.loadData("Contatos", ContatosDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteContato(). */


} /* End class. */
