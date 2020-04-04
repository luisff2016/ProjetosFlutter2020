import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ArqVideosDB.dart";
import "ArqVideosModel.dart" show ArqVideo, ArqVideosModel, arqVideosModel;


/// ********************************************************************************************************************
/// The ArqVideos List sub-screen.
/// ********************************************************************************************************************
class ArqVideosList extends StatelessWidget {


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##97 ArqVideossList.build()");

    // The list of dates with arqVideos.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < arqVideosModel.listaEntidades.length; i++) {
      ArqVideo arqVideo = arqVideosModel.listaEntidades[i];
      List dateParts = arqVideo.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate, icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );
    }

    // Return widget.
    return ScopedModel<ArqVideosModel>(
      model : arqVideosModel,
      child : ScopedModelDescendant<ArqVideosModel>(
        builder : (inContext, inChild, inModel) {
          return Scaffold(
            // Add arqVideo.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                arqVideosModel.entidadeSendoEditada = ArqVideo();
                DateTime now = DateTime.now();
                arqVideosModel.entidadeSendoEditada.apptDate = "${now.year},${now.month},${now.day}";
                arqVideosModel.definirDataEscolhida(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                arqVideosModel.setApptTime(null);
                arqVideosModel.definirIndicePilha(1);
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
                        _showArqVideos(inDate, inContext);
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


  /// Show a bottom sheet to see the arqVideos for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showArqVideos(DateTime inDate, BuildContext inContext) async {

    print(
      "##98 ArqVideosList._showArqVideos(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );

    print("##99 ArqVideosList._showArqVideos(): arqVideosModel.listaEntidades.length = "
      "${arqVideosModel.listaEntidades.length}");
    print("##100 ArqVideosList._showArqVideos(): arqVideosModel.listaEntidades = "
      "${arqVideosModel.listaEntidades}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext inContext) {
        return ScopedModel<ArqVideosModel>(
          model : arqVideosModel,
          child : ScopedModelDescendant<ArqVideosModel>(
            builder : (BuildContext inContext, Widget inChild, ArqVideosModel inModel) {
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
                              itemCount : arqVideosModel.listaEntidades.length,
                              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                                ArqVideo arqVideo = arqVideosModel.listaEntidades[inIndex];
                                print("##101 ArqVideosList._showArqVideos().ListView.builder(): "
                                  "arqVideo = $arqVideo");
                                // Filter out any arqVideo that isn't for the specified date.
                                if (arqVideo.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height : 0);
                                }
                                print("##102 ArqVideosList._showArqVideos().ListView.builder(): "
                                  "INCLUDING arqVideo = $arqVideo");
                                // If the arqVideo has a time, format it for display.
                                String apptTime = "";
                                if (arqVideo.apptTime != null) {
                                  List timeParts = arqVideo.apptTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                    hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                  );
                                  apptTime = " (${at.format(inContext)})";
                                }
                                // Return a widget for the arqVideo since it's for the correct date.
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                                  actionExtentRatio : .25,
                                  child : Container(
                                  margin : EdgeInsets.only(bottom : 8),
                                    color : Colors.grey.shade300,
                                    child : ListTile(
                                      title : Text("${arqVideo.title}$apptTime"),
                                      subtitle : arqVideo.description == null ?
                                        null : Text("${arqVideo.description}"),
                                      // Edit existing arqVideo.
                                      onTap : () async { _editArqVideo(inContext, arqVideo); }
                                    )
                                  ),
                                  secondaryActions : [
                                    IconSlideAction(
                                      caption : "Delete",
                                      color : Colors.red,
                                      icon : Icons.delete,
                                      onTap : () => _deleteArqVideo(inBuildContext, arqVideo)
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

  } /* End _showArqVideos(). */


  /// Handle taps on an arqVideo to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inArqVideo The ArqVideo being edited.
  void _editArqVideo(BuildContext inContext, ArqVideo inArqVideo) async {

    print("##103 ArqVideosList._editArqVideo(): inArqVideo = $inArqVideo");

    // Get the data from the database and send to the edit view.
    arqVideosModel.entidadeSendoEditada = await ArqVideosDB.db.get(inArqVideo.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (arqVideosModel.entidadeSendoEditada.apptDate == null) {
      arqVideosModel.definirDataEscolhida(null);
    } else {
      List dateParts = arqVideosModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      arqVideosModel.definirDataEscolhida(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }
    if (arqVideosModel.entidadeSendoEditada.apptTime == null) {
      arqVideosModel.setApptTime(null);
    } else {
      List timeParts = arqVideosModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      arqVideosModel.setApptTime(apptTime.format(inContext));
    }
    arqVideosModel.definirIndicePilha(1);
    Navigator.pop(inContext);

  } /* End _editArqVideo. */


  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inArqVideo The arqVideo (potentially) being deleted.
  /// @return               Future.
  Future _deleteArqVideo(BuildContext inContext, ArqVideo inArqVideo) async {

    print("##104 ArqVideosList._deleteArqVideo(): inArqVideo = $inArqVideo");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete ArqVideo"),
          content : Text("Are you sure you want to delete ${inArqVideo.title}?"),
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
                await ArqVideosDB.db.delete(inArqVideo.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("ArqVideo deleted")
                  )
                );
                // Reload data from database to update list.
                arqVideosModel.loadData("arqVideos", ArqVideosDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteArqVideo(). */


} /* End class. */
