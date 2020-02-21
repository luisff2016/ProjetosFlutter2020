import 'package:app_minha_consulta/anotacoes/Anotacoes.dart';
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "AnotacoesDB.dart";
import "AnotacoesModel.dart" show Anotacoes, AnotacoesModel, anotacoesModel;


/// ********************************************************************************************************************
/// The Anotacoess List sub-screen.
/// ********************************************************************************************************************
class AnotacoesList extends StatelessWidget {


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##97 AnotacoesList.build()");

    // The list of dates with anotacoess.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < anotacoesModel.entityList.length; i++) {
      Anotacoes anotacoes = anotacoesModel.entityList[i];
      List dateParts = anotacoes.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate, icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );
    }

    // Return widget.
    return ScopedModel<AnotacoesModel>(
      model : anotacoesModel,
      child : ScopedModelDescendant<AnotacoesModel>(
        builder : (inContext, inChild, inModel) {
          return Scaffold(
            // Add anotacoes.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                anotacoesModel.entityBeingEdited = Anotacoes();
                DateTime now = DateTime.now();
                anotacoesModel.entityBeingEdited.apptDate = "${now.year},${now.month},${now.day}";
                anotacoesModel.setChosenDate(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                anotacoesModel.setApptTime(null);
                anotacoesModel.setStackIndex(1);
              }
            ),
              body : Column(
              children : [
                Expanded(
                  child : Container(
                    margin : EdgeInsets.symmetric(horizontal : 10),
                    child : CalendarCarousel<Event>(
                      thisMonthDayBorderColor : Colors.grey,
                      daysHaveCircularBorder : false,
                      markedDatesMap : _markedDateMap,
                      onDayPressed : (DateTime inDate, List<Event> inEvents) {
                        _showAnotacoess(inDate, inContext);
                      }
                    ) /* End CalendarCarousel. */
                  ) /* End Container. */
                ) /* End Expanded. */
              ] /* End Column.children. */
            ) /* End Column. */
          ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
      ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


  /// Show a bottom sheet to see the anotacoess for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showAnotacoess(DateTime inDate, BuildContext inContext) async {

    print(
      "##98 AnotacoessList._showAnotacoess(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );

    print("##99 AnotacoessList._showAnotacoess(): anotacoesModel.entityList.length = "
      "${anotacoesModel.entityList.length}");
    print("##100 AnotacoessList._showAnotacoess(): anotacoesModel.entityList = "
      "${anotacoesModel.entityList}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext inContext) {
        return ScopedModel<AnotacoesModel>(
          model : anotacoesModel,
          child : ScopedModelDescendant<AnotacoesModel>(
            builder : (BuildContext inContext, Widget inChild, AnotacoesModel inModel) {
              return Scaffold(
                body : Container(
                  child : Padding(
                    padding : EdgeInsets.all(10),
                    child : GestureDetector(
                      child : Column(
                        children : [
                          Text(
                            DateFormat.yMMMMd("en_US").format(inDate.toLocal()),
                            textAlign : TextAlign.center,
                            style : TextStyle(color : Theme.of(inContext).accentColor, fontSize : 24)
                          ),
                          Divider(),
                          Expanded(
                            child : ListView.builder(
                              itemCount : anotacoesModel.entityList.length,
                              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                                Anotacoes anotacoes = anotacoesModel.entityList[inIndex];
                                print("##101 AnotacoessList._showAnotacoess().ListView.builder(): "
                                  "anotacoes = $anotacoes");
                                // Filter out any anotacoes that isn't for the specified date.
                                if (anotacoes.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height : 0);
                                }
                                print("##102 AnotacoessList._showAnotacoess().ListView.builder(): "
                                  "INCLUDING anotacoes = $anotacoes");
                                // If the anotacoes has a time, format it for display.
                                String apptTime = "";
                                if (anotacoes.apptTime != null) {
                                  List timeParts = anotacoes.apptTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                    hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                  );
                                  apptTime = " (${at.format(inContext)})";
                                }
                                // Return a widget for the anotacoes since it's for the correct date.
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                                  actionExtentRatio : .25,
                                  child : Container(
                                  margin : EdgeInsets.only(bottom : 8),
                                    color : Colors.grey.shade300,
                                    child : ListTile(
                                      title : Text("${anotacoes.title}$apptTime"),
                                      subtitle : anotacoes.description == null ?
                                        null : Text("${anotacoes.description}"),
                                      // Edit existing anotacoes.
                                      onTap : () async { _editAnotacoes(inContext, anotacoes); }
                                    )
                                  ),
                                  secondaryActions : [
                                    IconSlideAction(
                                      caption : "Delete",
                                      color : Colors.red,
                                      icon : Icons.delete,
                                      onTap : () => _deleteAnotacoes(inBuildContext, anotacoes)
                                    )
                                  ]
                                ); /* End Slidable. */
                              } /* End itemBuilder. */
                            ) /* End ListView.builder. */
                          ) /* End Expanded. */
                        ] /* End Column.children. */
                      ) /* End Column. */
                    ) /* End GestureDetector. */
                  ) /* End Padding. */
                ) /* End Container. */
              ); /* End Scaffold. */
            } /* End ScopedModel.builder. */
          ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel(). */
      } /* End dialog.builder. */
    ); /* End showModalBottomSheet(). */

  } /* End _showAnotacoess(). */


  /// Handle taps on an anotacoes to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inAnotacoes The Anotacoes being edited.
  void _editAnotacoes(BuildContext inContext, Anotacoes inAnotacoes) async {

    print("##103 AnotacoessList._editAnotacoes(): inAnotacoes = $inAnotacoes");

    // Get the data from the database and send to the edit view.
    anotacoesModel.entityBeingEdited = await AnotacoesDB.db.get(inAnotacoes.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (anotacoesModel.entityBeingEdited.apptDate == null) {
      anotacoesModel.setChosenDate(null);
    } else {
      List dateParts = anotacoesModel.entityBeingEdited.apptDate.split(",");
      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      anotacoesModel.setChosenDate(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }
    if (anotacoesModel.entityBeingEdited.apptTime == null) {
      anotacoesModel.setApptTime(null);
    } else {
      List timeParts = anotacoesModel.entityBeingEdited.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      anotacoesModel.setApptTime(apptTime.format(inContext));
    }
    anotacoesModel.setStackIndex(1);
    Navigator.pop(inContext);

  } /* End _editAnotacoes. */


  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inAnotacoes The anotacoes (potentially) being deleted.
  /// @return               Future.
  Future _deleteAnotacoes(BuildContext inContext, Anotacoes inAnotacoes) async {

    print("##104 AnotacoessList._deleteAnotacoes(): inAnotacoes = $inAnotacoes");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Anotacoes"),
          content : Text("Are you sure you want to delete ${inAnotacoes.title}?"),
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
                await AnotacoesDB.db.delete(inAnotacoes.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Anotacoes deleted")
                  )
                );
                // Reload data from database to update list.
                anotacoesModel.loadData("anotacoess", AnotacoesDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteAnotacoes(). */


} /* End class. */
