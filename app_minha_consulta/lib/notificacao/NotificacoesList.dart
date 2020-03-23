import "package:flutter/material.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:scoped_model/scoped_model.dart";

import "NotificacoesDB.dart";
import "notificacoesModel.dart" show Notificacao, NotificacoesModel, notificacoesModel;
import 'Notificacoes.dart';

/// ********************************************************************************************************************
/// The Notificacoes List sub-screen.
/// ********************************************************************************************************************
class NotificacoesList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## notificacao NotificacoesList.build()");

    // The list of dates with Notificacoes.
    EventList<Event> _markedDateMap = EventList();
    for (int i = 0; i < notificacoesModel.listaEntidades.length; i++) {
      Notificacao notificacao = notificacoesModel.listaEntidades[i];
      List dateParts = notificacao.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDateMap.add(
          apptDate,
          Event(
              date: apptDate,
              icon: Container(decoration: BoxDecoration(color: Colors.blue))));
    }

    // Return widget.
    return ScopedModel<NotificacoesModel>(
        model: notificacoesModel,
        child: ScopedModelDescendant<NotificacoesModel>(
            builder: (inContext, inChild, inModel) {
          return Scaffold(
              // Add Notificacoes.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    notificacoesModel.entidadeSendoEditada = Notificacoes();
                    DateTime now = DateTime.now();
                    notificacoesModel.entidadeSendoEditada.apptDate =
                        "${now.year},${now.month},${now.day}";
                    notificacoesModel.definirDataEscolhida(
                        DateFormat.yMMMMd("en_US").format(now.toLocal()));
                    notificacoesModel.setApptTime(null);
                    notificacoesModel.definirIndicePilha(1);
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
                              _showNotificacoes(inDate, inContext);
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

  /// Show a bottom sheet to see the Notificacoes for the selected day.
  ///
  /// @param inDate    The date selected.
  /// @param inContext The build context of the parent widget.
  void _showNotificacoes(DateTime inDate, BuildContext inContext) async {
    print(
        "## notificacao NotificacoesList._showNotificacoes(): inDate = $inDate (${inDate.year},${inDate.month},${inDate.day})");

    print("## notificacao NotificacoesList._showNotificacoes(): "
        "notificacoesModel.listaEntidades.length = ${notificacoesModel.listaEntidades.length}");
    print("## notificacao NotificacoesList._showNotificacoes(): "
        "notificacoesModel.listaEntidades = ${notificacoesModel.listaEntidades}");

    showModalBottomSheet(
        context: inContext,
        builder: (BuildContext inContext) {
          return ScopedModel<NotificacoesModel>(
              model: notificacoesModel,
              child: ScopedModelDescendant<NotificacoesModel>(builder:
                      (BuildContext inContext, Widget inChild,
                          NotificacoesModel inModel) {
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
                                          notificacoesModel.listaEntidades.length,
                                      itemBuilder: (BuildContext inBuildContext,
                                          int inIndex) {
                                        Notificacao notificacao =
                                            notificacoesModel.listaEntidades[inIndex];
                                        print(
                                            "## notificacao NotificacoesList._showNotificacao().ListView.builder(): "
                                            "Notificacao = $notificacao");
                                        // Filter out any Notificacoes that isn't for the specified date.
                                        if (notificacao.apptDate !=
                                            "${inDate.year},${inDate.month},${inDate.day}") {
                                          return Container(height: 0);
                                        }
                                        print(
                                            "## notificacao NotificacoesList._showNotificacoes().ListView.builder(): "
                                            "INCLUDING Notificacao = $notificacao");
                                        // If the Notificacoes has a time, format it for display.
                                        String apptTime = "";
                                        if (notificacao.apptTime != null) {
                                          List timeParts =
                                              notificacao.apptTime.split(",");
                                          TimeOfDay at = TimeOfDay(
                                              hour: int.parse(timeParts[0]),
                                              minute: int.parse(timeParts[1]));
                                          apptTime =
                                              " (${at.format(inContext)})";
                                        }
                                        // Return a widget for the Notificacoes since it's for the correct date.
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
                                                        "${notificacao.title}$apptTime"),
                                                    subtitle: notificacao
                                                                .description ==
                                                            null
                                                        ? null
                                                        : Text(
                                                            "${notificacao.description}"),
                                                    // Edit existing Notificacoes.
                                                    onTap: () async {
                                                      _editNotificacao(
                                                          inContext, notificacao);
                                                    })),
                                            secondaryActions: [
                                              IconSlideAction(
                                                  caption: "Delete",
                                                  color: Colors.red,
                                                  icon: Icons.delete,
                                                  onTap: () => _deleteNotificacao(
                                                      inBuildContext, notificacao))
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
  } /* End _showNotificacoes(). */

  /// Handle taps on an Notificacoes to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inNotificacao The Notificacoes being edited.
  void _editNotificacao(BuildContext inContext, Notificacao inNotificacao) async {
    print("##103 NotificacoesList._editNotificacao(): inNotificacao = $inNotificacao");

    // Get the data from the database and send to the edit view.
    notificacoesModel.entidadeSendoEditada = await NotificacoesDB.db.get(inNotificacao.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (notificacoesModel.entidadeSendoEditada.apptDate == null) {
      notificacoesModel.definirDataEscolhida(null);
    } else {
      List dateParts = notificacoesModel.entidadeSendoEditada.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]),
          int.parse(dateParts[1]), int.parse(dateParts[2]));
      notificacoesModel
          .definirDataEscolhida(DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (notificacoesModel.entidadeSendoEditada.apptTime == null) {
      notificacoesModel.setApptTime(null);
    } else {
      List timeParts = notificacoesModel.entidadeSendoEditada.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      notificacoesModel.setApptTime(apptTime.format(inContext));
    }
    notificacoesModel.definirIndicePilha(1);
    Navigator.pop(inContext);
  } /* End _editNotificacao. */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inNotificacao The Notificacoes (potentially) being deleted.
  /// @return               Future.
  Future _deleteNotificacao(BuildContext inContext, Notificacao inNotificacao) async {
    print("##104 NotificacoesList._deleteNotificacao(): inNotificacao = $inNotificacao");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Excluir Anotação"),
              content:
                  Text("Are you sure you want to delete ${inNotificacao.title}?"),
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
                      await NotificacoesDB.db.delete(inNotificacao.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Notificacoes deleted")));
                      // Reload data from database to update list.
                      notificacoesModel.loadData("Notificacoes", NotificacoesDB.db);
                    })
              ]);
        });
  } /* End _deleteNotificacao(). */

} /* End class. */
