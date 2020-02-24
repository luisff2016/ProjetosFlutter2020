import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "AlergiasDB.dart";
import "AlergiasModel.dart" show Alergia, AlergiasModel, alergiasModel;


/// ****************************************************************************
/// The Alergias List sub-screen.
/// ****************************************************************************
class AlergiasList extends StatelessWidget {


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##38 AlergiasList.build()");

    // Return widget.
    return ScopedModel<AlergiasModel>(
      model :alergiasModel,
      child : ScopedModelDescendant<AlergiasModel>(
        builder : (BuildContext inContext, Widget inChild, AlergiasModel inModel) {
          return Scaffold(
            // Add Alergia.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                alergiasModel.entityBeingEdited = Alergia();
                alergiasModel.setColor(null);
                alergiasModel.setStackIndex(1);
              }
            ),
            body : ListView.builder(
              itemCount : alergiasModel.entityList.length,
              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                Alergia alergia = alergiasModel.entityList[inIndex];
                // Determine Alergia background color (default to white if none was selected).
                Color color = Colors.white;
                switch (alergia.color) {
                  case "red" : color = Colors.red; break;
                  case "green" : color = Colors.green; break;
                  case "blue" : color = Colors.blue; break;
                  case "yellow" : color = Colors.yellow; break;
                  case "grey" : color = Colors.grey; break;
                  case "purple" : color = Colors.purple; break;
                }
                return Container(
                  padding : EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child : Slidable(
                    actionPane : SlidableBehindActionPane(),//SlidableDrawerDelegate(),
                    actionExtentRatio : .25,
                    secondaryActions : [
                      IconSlideAction(
                        caption : "Delete",
                        color : Colors.red,
                        icon : Icons.delete,
                        onTap : () => _deleteAlergia(inContext, alergia)
                      )
                    ],
                    child : Card(
                      elevation : 8,
                      color : color,
                      child : ListTile(
                        title : Text("${alergia.title}"),
                        subtitle : Text("${alergia.content}"),
                        // Edit existing Alergia.
                        onTap : () async {
                          // Get the data from the database and send to the edit view.
                          alergiasModel.entityBeingEdited = await AlergiasDB.db.get(alergia.id);
                          alergiasModel.setColor(alergiasModel.entityBeingEdited.color);
                          alergiasModel.setStackIndex(1);
                        }
                      )
                    ) /* End Card. */
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
  /// @param  inAlergia    The Alergia (potentially) being deleted.
  /// @return           Future.
  Future _deleteAlergia(BuildContext inContext, Alergia inAlergia) async {

    print("##39 AlergiastList._deleteAlergia(): inAlergia = $inAlergia");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Alergia"),
          content : Text("Are you sure you want to delete ${inAlergia.title}?"),
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
                await AlergiasDB.db.delete(inAlergia.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Alergia deleted")
                  )
                );
                // Reload data from database to update list.
                alergiasModel.loadData("alergias", AlergiasDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteAlergia(). */


} /* End class. */
