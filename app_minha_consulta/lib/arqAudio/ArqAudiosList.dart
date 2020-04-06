import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "ArqAudiosDB.dart";
import "ArqAudiosModel.dart" show ArqAudio, ArqAudiosModel, arqAudiosModel;

/// ********************************************************************************************************************
/// The ArqAudios List sub-screen.
/// ********************************************************************************************************************
class ArqAudiosList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##97 arqAudio ArqAudiosList.build()");

    // The list of dates with audios.
    EventList<Event> _markedDateMap = EventList();

    for (int i = 0; i < arqAudiosModel.listaEntidades.length; i++) {
      ArqAudio arqAudio = arqAudiosModel.listaEntidades[i];

      List dateParts = arqAudio.apptDate.split(",");

      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
          apptDate,
          Event(
              date: apptDate,
              icon: Container(decoration: BoxDecoration(color: Colors.blue))));
    }
    // Return widget.
    return ScopedModel<ArqAudiosModel>(
        model: arqAudiosModel,
        child: ScopedModelDescendant<ArqAudiosModel>(
            builder: (inContext, inChild, inModel) {
          return Scaffold(
              // Add arqAudio.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    arqAudiosModel.entidadeSendoEditada = ArqAudio();
                    DateTime now = DateTime.now();
                    arqAudiosModel.entidadeSendoEditada.apptDate =
                        "${now.year},${now.month},${now.day}";
                    arqAudiosModel.definirDataEscolhida(
                        DateFormat.yMMMMd("en_US").format(now.toLocal()));
                    arqAudiosModel.setApptTime(null);
                    arqAudiosModel.definirIndicePilha(1);
                  }),
              body: Column(children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "listar arquivos de audio ...")) /* End Container. */
                    ) /* End Expanded. */
              ] /* End Column.children. */
                  ) /* End Column. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

  /// Show a bottom sheet to see the audios for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showAudios(DateTime inDate, BuildContext inContext) async {
    print(
        "##98 arqAudio ArqAudiosList._showAudios(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})");
    print(
        "##99 arqAudio ArqAudiosList._showAudios(): arqAudiosModel.listaEntidades.length = "
        "${arqAudiosModel.listaEntidades.length}");
    print(
        "##100 arqAudio ArqAudiosList._showAudios(): arqAudiosModel.listaEntidades = "
        "${arqAudiosModel.listaEntidades}");
    showModalBottomSheet(
        context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<ArqAudiosModel>(
              model: arqAudiosModel,
              child: ScopedModelDescendant<ArqAudiosModel>(builder:
                      (BuildContext inContext, Widget inChild,
                          ArqAudiosModel inModel) {
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
                                          arqAudiosModel.listaEntidades.length,
                                      itemBuilder: (BuildContext inBuildContext,
                                          int inIndex) {
                                        ArqAudio arqAudio = arqAudiosModel
                                            .listaEntidades[inIndex];
                                        print(
                                            "##101 ArqAudiosList._showAudios().ListView.builder(): "
                                            "arqAudio = $arqAudio");
                                        // Filter out any audio that isn't for the specified date.
                                        if (arqAudio.apptDate !=
                                            "${inDate.year},${inDate.month},${inDate.day}") {
                                          return Container(height: 0);
                                        }
                                        print(
                                            "##102 arqAudio ArqAudiosList._showAudios().ListView.builder(): "
                                            "INCLUINDO arqAudio = $arqAudio");
                                        // If the audio has a time, format it for display.
                                        String apptTime = "";
                                        if (arqAudio.apptTime != null) {
                                          List timeParts =
                                              arqAudio.apptTime.split(",");
                                          TimeOfDay at = TimeOfDay(
                                              hour: int.parse(timeParts[0]),
                                              minute: int.parse(timeParts[1]));
                                          apptTime =
                                              " (${at.format(inContext)})";
                                        }
                                        // Return a widget for the audio since it's for the correct date.
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
                                                        "${arqAudio.title}$apptTime"),
                                                    subtitle: arqAudio
                                                                .description ==
                                                            null
                                                        ? null
                                                        : Text(
                                                            "${arqAudio.description}"),
                                                    // Edit existing arqAudio.
                                                    onTap: () async {
                                                      _editArqAudio(
                                                          inContext, arqAudio);
                                                    })),
                                            secondaryActions: [
                                              IconSlideAction(
                                                  caption: "Delete",
                                                  color: Colors.red,
                                                  icon: Icons.delete,
                                                  onTap: () => _deleteArqAudio(
                                                      inBuildContext, arqAudio))
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
  } /* End _showAudios(). */

  /// Handle taps on an audio to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inArqAudio The Audio being edited.
  void _editArqAudio(BuildContext inContext, ArqAudio inArqAudio) async {
    print(
        "##103 arqAudio ArqAudiosList._editArqAudio(): inArqAudio = $inArqAudio");
    // Get the data from the database and send to the edit view.
    arqAudiosModel.entidadeSendoEditada =
        await ArqAudiosDB.db.get(inArqAudio.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (arqAudiosModel.entidadeSendoEditada.apptDate == null) {
      arqAudiosModel.definirDataEscolhida(null);
    } else {
      List dateParts = arqAudiosModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      arqAudiosModel.definirDataEscolhida(
          DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (arqAudiosModel.entidadeSendoEditada.apptTime == null) {
      arqAudiosModel.setApptTime(null);
    } else {
      List timeParts = arqAudiosModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      arqAudiosModel.setApptTime(apptTime.format(inContext));
    }
    arqAudiosModel.definirIndicePilha(1);
    Navigator.pop(inContext);
  } /* End _editArqAudio. */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inArqAudio The audio (potentially) being deleted.
  /// @return               Future.
  Future _deleteArqAudio(BuildContext inContext, ArqAudio inArqAudio) async {
    print(
        "##104 arqAudio ArqAudiosList._deleteArqAudio(): inArqAudio = $inArqAudio");
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Delete Audio"),
              content:
                  Text("Are you sure you want to delete ${inArqAudio.title}?"),
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
                      await ArqAudiosDB.db.delete(inArqAudio.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Audio deleted")));
                      // Reload data from database to update list.
                      arqAudiosModel.loadData("audios", ArqAudiosDB.db);
                    })
              ]);
        });
  } /* End _deleteArqAudio(). */
} /* End clrqAass. */
