import "package:flutter/material.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:scoped_model/scoped_model.dart";

import "AnotacoesDB.dart";
import "AnotacoesModel.dart" show Anotacao, AnotacoesModel, anotacoesModel;
import 'Anotacoes.dart';

/// ********************************************************************************************************************
/// The Anotacoes List sub-screen.
/// ********************************************************************************************************************
class AnotacoesList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("##97 AnotacoesList.build()");

    // The list of dates with anotacoes.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < anotacoesModel.listaEntidades.length; i++) {
      Anotacao anotacao = anotacoesModel.listaEntidades[i];
      List dateParts = anotacao.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
          apptDate,
          Event(
              date: apptDate,
              icon: Container(decoration: BoxDecoration(color: Colors.blue))));
    }

    // Return widget.
    return ScopedModel<AnotacoesModel>(
        model: anotacoesModel,
        child: ScopedModelDescendant<AnotacoesModel>(
            builder: (inContext, inChild, inModel) {
          return Scaffold(
              // Add anotacoes.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    anotacoesModel.entidadeSendoEditada = Anotacoes();
                    DateTime now = DateTime.now();
                    anotacoesModel.entidadeSendoEditada.apptDate =
                        "${now.year},${now.month},${now.day}";
                    anotacoesModel.definirDataEscolhida(
                        DateFormat.yMMMMd("en_US").format(now.toLocal()));
                    anotacoesModel.setApptTime(null);
                    anotacoesModel.definirIndicePilha(1);
                  }),
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
                              _showAnotacoes(inDate, inContext);
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

  /// Show a bottom sheet to see the anotacoes for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showAnotacoes(DateTime inDate, BuildContext inContext) async {
    print(
        "##98 AnotacoesList._showAnotacoes(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})");

    print("##99 AnotacoesList._showAnotacoes(): "
        "anotacoesModel.listaEntidades.length = ${anotacoesModel.listaEntidades.length}");
    print("##100 AnotacoesList._showAnotacoes(): "
        "anotacoesModel.listaEntidades = ${anotacoesModel.listaEntidades}");

    showModalBottomSheet(
        context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<AnotacoesModel>(
              model: anotacoesModel,
              child: ScopedModelDescendant<AnotacoesModel>(builder:
                      (BuildContext inContext, Widget inChild,
                          AnotacoesModel inModel) {
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
                                          anotacoesModel.listaEntidades.length,
                                      itemBuilder: (BuildContext inBuildContext,
                                          int inIndex) {
                                        Anotacao anotacao =
                                            anotacoesModel.listaEntidades[inIndex];
                                        print(
                                            "##101 AnotacoesList._showAnotacao().ListView.builder(): "
                                            "anotacao = $anotacao");
                                        // Filter out any anotacoes that isn't for the specified date.
                                        if (anotacao.apptDate !=
                                            "${inDate.year},${inDate.month},${inDate.day}") {
                                          return Container(height: 0);
                                        }
                                        print(
                                            "##102 AnotacoesList._showAnotacoes().ListView.builder(): "
                                            "INCLUDING Anotacao = $Anotacao");
                                        // If the anotacoes has a time, format it for display.
                                        String apptTime = "";
                                        if (anotacao.apptTime != null) {
                                          List timeParts =
                                              anotacao.apptTime.split(",");
                                          TimeOfDay at = TimeOfDay(
                                              hour: int.parse(timeParts[0]),
                                              minute: int.parse(timeParts[1]));
                                          apptTime =
                                              " (${at.format(inContext)})";
                                        }
                                        // Return a widget for the anotacoes since it's for the correct date.
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
                                                        "${anotacao.title}$apptTime"),
                                                    subtitle: anotacao
                                                                .description ==
                                                            null
                                                        ? null
                                                        : Text(
                                                            "${anotacao.description}"),
                                                    // Edit existing anotacoes.
                                                    onTap: () async {
                                                      _editAnotacao(
                                                          inContext, anotacao);
                                                    })),
                                            secondaryActions: [
                                              IconSlideAction(
                                                  caption: "Delete",
                                                  color: Colors.red,
                                                  icon: Icons.delete,
                                                  onTap: () => _deleteAnotacao(
                                                      inBuildContext, anotacao))
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
  } /* End _showAnotacoes(). */

  /// Handle taps on an anotacoes to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inAnotacao The Anotacoes being edited.
  void _editAnotacao(BuildContext inContext, Anotacao inAnotacao) async {
    print("##103 AnotacoesList._editAnotacao(): inAnotacao = $inAnotacao");

    // Get the data from the database and send to the edit view.
    anotacoesModel.entidadeSendoEditada = await AnotacoesDB.db.get(inAnotacao.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (anotacoesModel.entidadeSendoEditada.apptDate == null) {
      anotacoesModel.definirDataEscolhida(null);
    } else {
      List dateParts = anotacoesModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      anotacoesModel
          .definirDataEscolhida(DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (anotacoesModel.entidadeSendoEditada.apptTime == null) {
      anotacoesModel.setApptTime(null);
    } else {
      List timeParts = anotacoesModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      anotacoesModel.setApptTime(apptTime.format(inContext));
    }
    anotacoesModel.definirIndicePilha(1);
    Navigator.pop(inContext);
  } /* End _editAnotacao. */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inAnotacao The anotacoes (potentially) being deleted.
  /// @return               Future.
  Future _deleteAnotacao(BuildContext inContext, Anotacao inAnotacao) async {
    print("##104 AnotacoesList._deleteAnotacao(): inAnotacao = $inAnotacao");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Excluir Anotação"),
              content:
                  Text("Are you sure you want to delete ${inAnotacao.title}?"),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }),
                FlatButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await AnotacoesDB.db.delete(inAnotacao.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Anotacoes deleted")));
                      // Reload data from database to update list.
                      anotacoesModel.loadData("anotacoes", AnotacoesDB.db);
                    })
              ]);
        });
  } /* End _deleteAnotacao(). */

} /* End class. */
