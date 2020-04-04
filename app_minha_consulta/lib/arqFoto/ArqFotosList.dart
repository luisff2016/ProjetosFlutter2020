import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ArqFotosDB.dart";
import "ArqFotosModel.dart" show ArqFoto, ArqFotosModel, arqFotosModel;


/// ********************************************************************************************************************
/// The ArqFotos List sub-screen.
/// ********************************************************************************************************************

class ArqFotosList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##97 arqFoto ArqFotossList.build()");
    // The list of dates with arqFotos.
    EventList<Event> _markedDateMap = EventList();

    for (int i = 0; i < arqFotosModel.listaEntidades.length; i++) {

      ArqFoto arqFoto = arqFotosModel.listaEntidades[i];
    
      List dateParts = arqFoto.apptDate.split(",");
      
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate, icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );

    }
    // Return widget.
    return ScopedModel<ArqFotosModel>(
      model : arqFotosModel,
      child : ScopedModelDescendant<ArqFotosModel>(
        builder : (inContext, inChild, inModel) {
          return Scaffold(
            // Add arqFoto.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                arqFotosModel.entidadeSendoEditada = ArqFoto();
                DateTime now = DateTime.now();
                arqFotosModel.entidadeSendoEditada.apptDate = "${now.year},${now.month},${now.day}";
                arqFotosModel.definirDataEscolhida(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                arqFotosModel.setApptTime(null);
                arqFotosModel.definirIndicePilha(1);
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
                        _showArqFotos(inDate, inContext);
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

  /// Show a bottom sheet to see the arqFotos for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showArqFotos(DateTime inDate, BuildContext inContext) async {

    print(
      "##98 ArqFotosList._showArqFotos(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );

    print("##99 ArqFotosList._showArqFotos(): arqFotosModel.listaEntidades.length = "
      "${arqFotosModel.listaEntidades.length}");
    
    print("##100 ArqFotosList._showArqFotos(): arqFotosModel.listaEntidades = "
      "${arqFotosModel.listaEntidades}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext inContext) {
        return ScopedModel<ArqFotosModel>(
          model : arqFotosModel,
          child : ScopedModelDescendant<ArqFotosModel>(
            builder : (BuildContext inContext, Widget inChild, ArqFotosModel inModel) {
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
                              itemCount : arqFotosModel.listaEntidades.length,
                              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                                ArqFoto arqFoto = arqFotosModel.listaEntidades[inIndex];
                                print("##101 ArqFotosList._showArqFotos().ListView.builder(): "
                                  "arqFoto = $arqFoto");
                                // Filter out any arqFoto that isn't for the specified date.
                                if (arqFoto.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height : 0);
                                }
                                print("##102 ArqFotosList._showArqFotos().ListView.builder(): "
                                  "INCLUDING arqFoto = $arqFoto");
                                // If the arqFoto has a time, format it for display.
                                String apptTime = "";
                                if (arqFoto.apptTime != null) {
                                  List timeParts = arqFoto.apptTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                    hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                  );
                                  apptTime = " (${at.format(inContext)})";
                                }
                                // Return a widget for the arqFoto since it's for the correct date.
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                                  actionExtentRatio : .25,
                                  child : Container(
                                  margin : EdgeInsets.only(bottom : 8),
                                    color : Colors.grey.shade300,
                                    child : ListTile(
                                      title : Text("${arqFoto.title}$apptTime"),
                                      subtitle : arqFoto.description == null ?
                                        null : Text("${arqFoto.description}"),
                                      // Edit existing arqFoto.
                                      onTap : () async { _editArqFoto(inContext, arqFoto); }
                                    )
                                  ),
                                  secondaryActions : [
                                    IconSlideAction(
                                      caption : "Delete",
                                      color : Colors.red,
                                      icon : Icons.delete,
                                      onTap : () => _deleteArqFoto(inBuildContext, arqFoto)
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

  } /* End _showArqFotos(). */

  /// Handle taps on an arqFoto to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inArqFoto The ArqFoto being edited.
  void _editArqFoto(BuildContext inContext, ArqFoto inArqFoto) async {

    print("##103 ArqFotosList._editArqFoto(): inArqFoto = $inArqFoto");

    // Get the data from the database and send to the edit view.
    arqFotosModel.entidadeSendoEditada = await ArqFotosDB.db.get(inArqFoto.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (arqFotosModel.entidadeSendoEditada.apptDate == null) {
      arqFotosModel.definirDataEscolhida(null);
    } else {
      List dateParts = arqFotosModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      arqFotosModel.definirDataEscolhida(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }
    if (arqFotosModel.entidadeSendoEditada.apptTime == null) {
      arqFotosModel.setApptTime(null);
    } else {
      List timeParts = arqFotosModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      arqFotosModel.setApptTime(apptTime.format(inContext));
    }
    arqFotosModel.definirIndicePilha(1);
    Navigator.pop(inContext);

  } /* End _editArqFoto. */


  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inArqFoto The arqFoto (potentially) being deleted.
  /// @return               Future.
  Future _deleteArqFoto(BuildContext inContext, ArqFoto inArqFoto) async {

    print("##104 ArqFotosList._deleteArqFoto(): inArqFoto = $inArqFoto");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete ArqFoto"),
          content : Text("Are you sure you want to delete ${inArqFoto.title}?"),
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
                await ArqFotosDB.db.delete(inArqFoto.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("ArqFoto deleted")
                  )
                );
                // Reload data from database to update list.
                arqFotosModel.loadData("arqFotos", ArqFotosDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteArqFoto(). */


} /* End class. */
