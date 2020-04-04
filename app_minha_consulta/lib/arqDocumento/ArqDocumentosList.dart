import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ArqDocumentosDB.dart";
import "ArqDocumentosModel.dart" show ArqDocumento, ArqDocumentosModel, arqDocumentosModel;


/// ********************************************************************************************************************
/// The ArqDocumentos List sub-screen.
/// ********************************************************************************************************************
class ArqDocumentosList extends StatelessWidget {

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##97 ArqDocumentossList.build()");

    // The list of dates with arqDocumentos.
    EventList<Event> _markedDateMap = EventList();

    for (int i = 0; i < arqDocumentosModel.listaEntidades.length; i++) {
      ArqDocumento arqDocumento = arqDocumentosModel.listaEntidades[i];

      List dateParts = arqDocumento.apptDate.split(",");

      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate, icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );
    }

    // Return widget.
    return ScopedModel<ArqDocumentosModel>(
      model : arqDocumentosModel,
      child : ScopedModelDescendant<ArqDocumentosModel>(
        builder : (inContext, inChild, inModel) {
          return Scaffold(
            // Add arqDocumento.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                arqDocumentosModel.entidadeSendoEditada = ArqDocumento();
                DateTime now = DateTime.now();
                arqDocumentosModel.entidadeSendoEditada.apptDate = "${now.year},${now.month},${now.day}";
                arqDocumentosModel.definirDataEscolhida(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                arqDocumentosModel.setApptTime(null);
                arqDocumentosModel.definirIndicePilha(1);
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
                        _showArqDocumentos(inDate, inContext);
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

  /// Show a bottom sheet to see the arqDocumentos for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showArqDocumentos(DateTime inDate, BuildContext inContext) async {
    print(
      "##98 ArqDocumentosList._showArqDocumentos(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );

    print("##99 ArqDocumentosList._showArqDocumentos(): arqDocumentosModel.listaEntidades.length = "
      "${arqDocumentosModel.listaEntidades.length}");

    print("##100 ArqDocumentosList._showArqDocumentos(): arqDocumentosModel.listaEntidades = "
      "${arqDocumentosModel.listaEntidades}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext inContext) {
        return ScopedModel<ArqDocumentosModel>(
          model : arqDocumentosModel,
          child : ScopedModelDescendant<ArqDocumentosModel>(
            builder : (BuildContext inContext, Widget inChild, ArqDocumentosModel inModel) {
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
                              itemCount : arqDocumentosModel.listaEntidades.length,
                              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                                ArqDocumento arqDocumento = arqDocumentosModel.listaEntidades[inIndex];
                                print("##101 ArqDocumentosList._showArqDocumentos().ListView.builder(): "
                                  "arqDocumento = $arqDocumento");
                                // Filter out any arqDocumento that isn't for the specified date.
                                if (arqDocumento.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height : 0);
                                }
                                print("##102 ArqDocumentosList._showArqDocumentos().ListView.builder(): "
                                  "INCLUDING arqDocumento = $arqDocumento");
                                // If the arqDocumento has a time, format it for display.
                                String apptTime = "";
                                if (arqDocumento.apptTime != null) {
                                  List timeParts = arqDocumento.apptTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                    hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                  );
                                  apptTime = " (${at.format(inContext)})";
                                }
                                // Return a widget for the arqDocumento since it's for the correct date.
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                                  actionExtentRatio : .25,
                                  child : Container(
                                  margin : EdgeInsets.only(bottom : 8),
                                    color : Colors.grey.shade300,
                                    child : ListTile(
                                      title : Text("${arqDocumento.title}$apptTime"),
                                      subtitle : arqDocumento.description == null ?
                                        null : Text("${arqDocumento.description}"),
                                      // Edit existing arqDocumento.
                                      onTap : () async { _editArqDocumento(inContext, arqDocumento); }
                                    )
                                  ),
                                  secondaryActions : [
                                    IconSlideAction(
                                      caption : "Delete",
                                      color : Colors.red,
                                      icon : Icons.delete,
                                      onTap : () => _deleteArqDocumento(inBuildContext, arqDocumento)
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

  } /* End _showArqDocumentos(). */

  /// Handle taps on an arqDocumento to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inArqDocumento The ArqDocumento being edited.
  void _editArqDocumento(BuildContext inContext, ArqDocumento inArqDocumento) async {
    print("##103 ArqDocumentosList._editArqDocumento(): inArqDocumento = $inArqDocumento");

    // Get the data from the database and send to the edit view.
    arqDocumentosModel.entidadeSendoEditada = await ArqDocumentosDB.db.get(inArqDocumento.id);

    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (arqDocumentosModel.entidadeSendoEditada.apptDate == null) {
      arqDocumentosModel.definirDataEscolhida(null);
    } else {
      List dateParts = arqDocumentosModel.entidadeSendoEditada.apptDate.split(",");

      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );

      arqDocumentosModel.definirDataEscolhida(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }

    if (arqDocumentosModel.entidadeSendoEditada.apptTime == null) {
      arqDocumentosModel.setApptTime(null);
    } else {
      List timeParts = arqDocumentosModel.entidadeSendoEditada.apptTime.split(",");

      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );

      arqDocumentosModel.setApptTime(apptTime.format(inContext));
    }

    arqDocumentosModel.definirIndicePilha(1);

    Navigator.pop(inContext);

  } /* End _editArqDocumento. */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inArqDocumento The arqDocumento (potentially) being deleted.
  /// @return               Future.
  Future _deleteArqDocumento(BuildContext inContext, ArqDocumento inArqDocumento) async {
    print("##104 ArqDocumentosList._deleteArqDocumento(): inArqDocumento = $inArqDocumento");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete ArqDocumento"),
          content : Text("Are you sure you want to delete ${inArqDocumento.title}?"),
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
                await ArqDocumentosDB.db.delete(inArqDocumento.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("ArqDocumento deleted")
                  )
                );
                // Reload data from database to update list.
                arqDocumentosModel.loadData("arqDocumentos", ArqDocumentosDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteArqDocumento(). */

} /* End class. */