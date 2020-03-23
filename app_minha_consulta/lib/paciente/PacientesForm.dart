import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';
import "PacientesDB.dart";
import "PacientesModel.dart" show PacientesModel, pacientesModel;

/// ****************************************************************************
/// Subtela para entradas da entidade.
/// ****************************************************************************
class PacientesForm extends StatelessWidget {
  /// Controladores para campos de texto.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  // Chave para o formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  PacientesForm() {
    print("## paciente PacientesForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      pacientesModel.entidadeSendoEditada.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      pacientesModel.entidadeSendoEditada.content = _contentEditingController.text;
    });
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## paciente PacientesForm.build()");

    // Set value of controllers.
    _titleEditingController.text = pacientesModel.entidadeSendoEditada.title;
    _contentEditingController.text = pacientesModel.entidadeSendoEditada.content;

    // Return widget.
    return ScopedModel(
        model: pacientesModel,
        child: ScopedModelDescendant<PacientesModel>(builder:
                (BuildContext inContext, Widget inChild,
                    PacientesModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Row(children: [
                    FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          // Hide soft keyboard.
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          // Go back to the list view.
                          inModel.definirIndicePilha(0);
                        }),
                    Spacer(),
                    FlatButton(
                        child: Text("Save"),
                        onPressed: () {
                          _save(inContext, pacientesModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                            decoration: InputDecoration(hintText: "Title"),
                            controller: _titleEditingController,
                            validator: (String inValue) {
                              if (inValue.length == 0) {
                                return "Please enter a title";
                              }
                              return null;
                            })),
                    // Content.
                    ListTile(
                        leading: Icon(Icons.content_paste),
                        title: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            decoration: InputDecoration(hintText: "Content"),
                            controller: _contentEditingController,
                            validator: (String inValue) {
                              if (inValue.length == 0) {
                                return "Please enter content";
                              }
                              return null;
                            })),
                    // Note color.
                    ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Row(children: [
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.red, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  pacientesModel.color == "red"
                                                      ? Colors.red
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color = "red";
                                pacientesModel.setColor("red");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.green, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  pacientesModel.color == "green"
                                                      ? Colors.green
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color = "green";
                                pacientesModel.setColor("green");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.blue, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  pacientesModel.color == "blue"
                                                      ? Colors.blue
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color = "blue";
                                pacientesModel.setColor("blue");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.yellow, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: pacientesModel.color ==
                                                      "yellow"
                                                  ? Colors.yellow
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color =
                                    "yellow";
                                pacientesModel.setColor("yellow");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.grey, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  pacientesModel.color == "grey"
                                                      ? Colors.grey
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color = "grey";
                                pacientesModel.setColor("grey");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.purple, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: pacientesModel.color ==
                                                      "purple"
                                                  ? Colors.purple
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                pacientesModel.entidadeSendoEditada.color =
                                    "purple";
                                pacientesModel.setColor("purple");
                              })
                        ]))
                  ] /* End Column children. */
                      ) /* End ListView. */
                  ) /* End Form. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The PacientesModel.
  void _save(BuildContext inContext, PacientesModel inModel) async {
    print("## paciente PacientesForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entidadeSendoEditada.id == null) {
      print(
          "## paciente PacientesForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      await PacientesDB.db.create(pacientesModel.entidadeSendoEditada);

      // Updating an existing note.
    } else {
      print(
          "## paciente PacientesForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      await PacientesDB.db.update(pacientesModel.entidadeSendoEditada);
    }

    // Reload data from database to update list.
    pacientesModel.loadData("pacientes", PacientesDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("paciente salvo!")));
  } /* End _save(). */

} /* End class. */
