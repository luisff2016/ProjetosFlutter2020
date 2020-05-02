import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ConsultasDB.dart";
import "ConsultasModel.dart" show Consulta, ConsultasModel, consultasModel;

/// ********************************************************************************************************************
/// The Consulta, List sub-screen.
/// ********************************************************************************************************************
class ConsultasHist extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##97 ConsultasHist.build()");

    // The list of dates with Consulta,.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < consultasModel.listaEntidades.length; i++) {
      Consulta consulta = consultasModel.listaEntidades[i];
      List dateParts = consulta.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
          apptDate,
          Event(
              date: apptDate,
              icon: Container(decoration: BoxDecoration(color: Colors.blue))));
    }

    // Return widget.
    return ScopedModel<ConsultasModel>(
        model: consultasModel,
        child: ScopedModelDescendant<ConsultasModel>(builder:
                (BuildContext inContext, Widget inChild,
                    ConsultasModel inModel) {
          return Scaffold(
             
              body: Column(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: CalendarCarousel<Event>(
                            thisMonthDayBorderColor: Colors.grey,
                            daysHaveCircularBorder: false,
                            markedDatesMap: _markedDateMap,
                            onDayPressed:
                                (DateTime inDate, List<Event> inEvents) {
                              _showConsulta(inDate, inContext);
                            }) /* End CalendarCarousel. */
                        ) /* End Container. */
                    ) /* End Expanded. */
              ] /* End Column.children. */
                  ) /* End Column. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

  /// Show a bottom sheet to see the Consulta, for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showConsulta(DateTime inDate, BuildContext inContext) async {
    print(
        "##98 Consulta,List._showConsulta,(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})");

    print(
        "##99 Consulta,List._showConsulta,(): consultasModel.listaEntidades.length = "
        "${consultasModel.listaEntidades.length}");
    print("##100 Consulta,List._showConsulta,(): consultasModel.listaEntidades = "
        "${consultasModel.listaEntidades}");

    showModalBottomSheet(
        context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<ConsultasModel>(
              model: consultasModel,
              child: ScopedModelDescendant<ConsultasModel>(builder:
                      (BuildContext inContext, Widget inChild,
                          ConsultasModel inModel) {
                return Scaffold(
                    body: Container(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                                child: Column(children: [
                              Text(
                                  DateFormat.yMMMMd("en_US")
                                      .format(inDate.toLocal()),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(inContext).accentColor,
                                      fontSize: 24)),
                              Divider(),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount:
                                          consultasModel.listaEntidades.length,
                                      itemBuilder: (BuildContext inBuildContext,
                                          int inIndex) {
                                        Consulta consulta =
                                            consultasModel.listaEntidades[inIndex];
                                        print(
                                            "##101 Consulta.List._showConsulta().ListView.builder(): Consulta = $Consulta");
                                        // Filter out any Consulta,that isn't for the specified date.
                                        if (consulta.apptDate !=
                                            "${inDate.year},${inDate.month},${inDate.day}") {
                                          return Container(height: 0);
                                        }
                                        print(
                                            "##102 ConsultasHist._showConsulta().ListView.builder(): "
                                            "INCLUDING Consulta = $Consulta");
                                        // If the Consulta,has a time, format it for display.
                                        String apptTime = "";
                                        if (consulta.apptTime != null) {
                                          List timeParts =
                                              consulta.apptTime.split(",");
                                          TimeOfDay at = TimeOfDay(
                                              hour: int.parse(timeParts[0]),
                                              minute: int.parse(timeParts[1]));
                                          apptTime =
                                              " (${at.format(inContext)})";
                                        }
                                        // Return a widget for the Consulta,since it's for the correct date.
                                        return Slidable(
                                            actionPane:
                                                SlidableBehindActionPane(), //delegate : SlidableDrawerDelegate(),
                                            actionExtentRatio: .25,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                color: Colors.grey.shade300,
                                                child: ListTile(
                                                    title: Text(
                                                        "${consulta.title}$apptTime"),
                                                    subtitle: consulta
                                                                .description ==
                                                            null
                                                        ? null
                                                        : Text(
                                                            "${consulta.description}"),
                                                    // Edit existing Consulta,
                                                    onTap: () async {
                                                      _editConsulta(
                                                          inContext, consulta);
                                                    })),
                                            secondaryActions: [
                                              IconSlideAction(
                                                caption: "Delete",
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () => _deleteConsulta(
                                                    inBuildContext, consulta),
                                              )
                                            ]); /* End Slidable. */
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
  } /* End _showConsulta,(). */

  /// Handle taps on an Consulta,to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inConsulta,The Consulta,being edited.
  void _editConsulta(BuildContext inContext, Consulta inConsulta) async {
    print("##103 ConsultasHist._editConsulta: inConsulta = $inConsulta");

    // Get the data from the database and send to the edit view.
    // consultasModel.entidadeSendoEditada = await ConsultasDB.db.get(inConsulta,id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (consultasModel.entidadeSendoEditada.apptDate == null) {
      consultasModel.definirDataEscolhida(null);
    } else {
      List dateParts = consultasModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      consultasModel
          .definirDataEscolhida(DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (consultasModel.entidadeSendoEditada.apptTime == null) {
      consultasModel.setApptTime(null);
    } else {
      List timeParts = consultasModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      consultasModel.setApptTime(apptTime.format(inContext));
    }
    consultasModel.definirIndicePilha(1);
    Navigator.pop(inContext);
  } /* End _editConsulta, */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inConsulta,The Consulta,(potentially) being deleted.
  /// @return               Future.
  Future _deleteConsulta(BuildContext inContext, Consulta inConsulta) async {
    print("##104 ConsultasHist._deleteConsulta: inConsulta = $inConsulta");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Delete Consulta"),
              content:
                  Text("Are you sure you want to delete ${inConsulta.title}?"),
              actions: [
                FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }),
                FlatButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await ConsultasDB.db.delete(inConsulta.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Consulta excluida")));
                      // Reload data from database to update list.
                      consultasModel.loadData("consulta", ConsultasDB.db);
                    })
              ]);
        });
  } /* End _deleteConsulta,). */

} /* End class. */

/**
 * FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    consultasModel.entidadeSendoEditada = Consulta();
                    DateTime now = DateTime.now();
                    consultasModel.entidadeSendoEditada.apptDate =
                        "${now.year},${now.month},${now.day}";
                    consultasModel.definirDataEscolhida(
                        DateFormat.yMMMMd("en_US").format(now.toLocal()));
                    consultasModel.setApptTime(null);
                    consultasModel.definirIndicePilha(1);
                  }),
 */
