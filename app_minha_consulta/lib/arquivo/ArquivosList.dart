import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ArquivosDB.dart";
import "ArquivosModel.dart" show Arquivo, ArquivosModel, arquivosModel;


/// ********************************************************************************************************************
/// The Arquivos List sub-screen.
/// ********************************************************************************************************************
class ArquivosList extends StatelessWidget {


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##97 ArquivossList.build()");

    // The list of dates with arquivos.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < arquivosModel.listaEntidades.length; i++) {
      Arquivo arquivo = arquivosModel.listaEntidades[i];
      List dateParts = arquivo.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
        apptDate, Event(date : apptDate, icon : Container(decoration : BoxDecoration(color : Colors.blue)))
      );
    }

    // Return widget.
    return ScopedModel<ArquivosModel>(
      model : arquivosModel,
      child : ScopedModelDescendant<ArquivosModel>(
        builder : (inContext, inChild, inModel) {
          return Scaffold(
            // Add arquivo.
            floatingActionButton : FloatingActionButton(
              child : Icon(Icons.add, color : Colors.white),
              onPressed : () async {
                arquivosModel.entidadeSendoEditada = Arquivo();
                DateTime now = DateTime.now();
                arquivosModel.entidadeSendoEditada.apptDate = "${now.year},${now.month},${now.day}";
                arquivosModel.definirDataEscolhida(DateFormat.yMMMMd("en_US").format(now.toLocal()));
                arquivosModel.setApptTime(null);
                arquivosModel.definirIndicePilha(1);
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
                        _showArquivos(inDate, inContext);
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


  /// Show a bottom sheet to see the arquivos for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showArquivos(DateTime inDate, BuildContext inContext) async {

    print(
      "##98 ArquivosList._showArquivos(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})"
    );

    print("##99 ArquivosList._showArquivos(): arquivosModel.listaEntidades.length = "
      "${arquivosModel.listaEntidades.length}");
    print("##100 ArquivosList._showArquivos(): arquivosModel.listaEntidades = "
      "${arquivosModel.listaEntidades}");

    showModalBottomSheet(
      context : inContext,
      builder : (BuildContext inContext) {
        return ScopedModel<ArquivosModel>(
          model : arquivosModel,
          child : ScopedModelDescendant<ArquivosModel>(
            builder : (BuildContext inContext, Widget inChild, ArquivosModel inModel) {
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
                              itemCount : arquivosModel.listaEntidades.length,
                              itemBuilder : (BuildContext inBuildContext, int inIndex) {
                                Arquivo arquivo = arquivosModel.listaEntidades[inIndex];
                                print("##101 ArquivosList._showArquivos().ListView.builder(): "
                                  "arquivo = $arquivo");
                                // Filter out any arquivo that isn't for the specified date.
                                if (arquivo.apptDate != "${inDate.year},${inDate.month},${inDate.day}") {
                                  return Container(height : 0);
                                }
                                print("##102 ArquivosList._showArquivos().ListView.builder(): "
                                  "INCLUDING arquivo = $arquivo");
                                // If the arquivo has a time, format it for display.
                                String apptTime = "";
                                if (arquivo.apptTime != null) {
                                  List timeParts = arquivo.apptTime.split(",");
                                  TimeOfDay at = TimeOfDay(
                                    hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
                                  );
                                  apptTime = " (${at.format(inContext)})";
                                }
                                // Return a widget for the arquivo since it's for the correct date.
                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),//delegate : SlidableDrawerDelegate(),
                                  actionExtentRatio : .25,
                                  child : Container(
                                  margin : EdgeInsets.only(bottom : 8),
                                    color : Colors.grey.shade300,
                                    child : ListTile(
                                      title : Text("${arquivo.title}$apptTime"),
                                      subtitle : arquivo.description == null ?
                                        null : Text("${arquivo.description}"),
                                      // Edit existing arquivo.
                                      onTap : () async { _editArquivo(inContext, arquivo); }
                                    )
                                  ),
                                  secondaryActions : [
                                    IconSlideAction(
                                      caption : "Delete",
                                      color : Colors.red,
                                      icon : Icons.delete,
                                      onTap : () => _deleteArquivo(inBuildContext, arquivo)
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

  } /* End _showArquivos(). */


  /// Handle taps on an arquivo to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inArquivo The Arquivo being edited.
  void _editArquivo(BuildContext inContext, Arquivo inArquivo) async {

    print("##103 ArquivosList._editArquivo(): inArquivo = $inArquivo");

    // Get the data from the database and send to the edit view.
    arquivosModel.entidadeSendoEditada = await ArquivosDB.db.get(inArquivo.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (arquivosModel.entidadeSendoEditada.apptDate == null) {
      arquivosModel.definirDataEscolhida(null);
    } else {
      List dateParts = arquivosModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(
        int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2])
      );
      arquivosModel.definirDataEscolhida(
        DateFormat.yMMMMd("en_US").format(apptDate.toLocal())
      );
    }
    if (arquivosModel.entidadeSendoEditada.apptTime == null) {
      arquivosModel.setApptTime(null);
    } else {
      List timeParts = arquivosModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
        hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1])
      );
      arquivosModel.setApptTime(apptTime.format(inContext));
    }
    arquivosModel.definirIndicePilha(1);
    Navigator.pop(inContext);

  } /* End _editArquivo. */


  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inArquivo The arquivo (potentially) being deleted.
  /// @return               Future.
  Future _deleteArquivo(BuildContext inContext, Arquivo inArquivo) async {

    print("##104 ArquivosList._deleteArquivo(): inArquivo = $inArquivo");

    return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
          title : Text("Delete Arquivo"),
          content : Text("Are you sure you want to delete ${inArquivo.title}?"),
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
                await ArquivosDB.db.delete(inArquivo.id);
                Navigator.of(inAlertContext).pop();
                Scaffold.of(inContext).showSnackBar(
                  SnackBar(
                    backgroundColor : Colors.red,
                    duration : Duration(seconds : 2),
                    content : Text("Arquivo deleted")
                  )
                );
                // Reload data from database to update list.
                arquivosModel.loadData("arquivos", ArquivosDB.db);
              }
            )
          ]
        );
      }
    );

  } /* End _deleteArquivo(). */


} /* End class. */
