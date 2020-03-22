import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "NotasDB.dart";
import "NotasModel.dart" show NotasModel, notasModel;

/// ****************************************************************************
/// Subtela para entradas da entidade.
/// ****************************************************************************
class NotasForm extends StatelessWidget {
  /// Controladores para campos de texto.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  // Chave para o formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  NotasForm() {
    print("## nota NotasForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      notasModel.entidadeSendoEditada.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notasModel.entidadeSendoEditada.content = _contentEditingController.text;
    });
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## nota NotasForm.build()");

    // Set value of controllers.
    _titleEditingController.text = notasModel.entidadeSendoEditada.title;
    _contentEditingController.text = notasModel.entidadeSendoEditada.content;

    // Return widget.
    return ScopedModel(
        model: notasModel,
        child: ScopedModelDescendant<NotasModel>(builder:
                (BuildContext inContext, Widget inChild, NotasModel inModel) {
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
                          _save(inContext, notasModel);
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
                                              color: notasModel.color == "red"
                                                  ? Colors.red
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "red";
                                notasModel.setColor("red");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.green, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: notasModel.color == "green"
                                                  ? Colors.green
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "green";
                                notasModel.setColor("green");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.blue, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: notasModel.color == "blue"
                                                  ? Colors.blue
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "blue";
                                notasModel.setColor("blue");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.yellow, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  notasModel.color == "yellow"
                                                      ? Colors.yellow
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "yellow";
                                notasModel.setColor("yellow");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.grey, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: notasModel.color == "grey"
                                                  ? Colors.grey
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "grey";
                                notasModel.setColor("grey");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.purple, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color:
                                                  notasModel.color == "purple"
                                                      ? Colors.purple
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                notasModel.entidadeSendoEditada.color = "purple";
                                notasModel.setColor("purple");
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
  /// @param inModel   The NotasModel.
  void _save(BuildContext inContext, NotasModel inModel) async {
    print("## nota NotasForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entidadeSendoEditada.id == null) {
      print("## nota NotasForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      await NotasDB.db.create(notasModel.entidadeSendoEditada);

      // Updating an existing note.
    } else {
      print("## nota NotasForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      await NotasDB.db.update(notasModel.entidadeSendoEditada);
    }

    // Reload data from database to update list.
    notasModel.loadData("notes", NotasDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Nota salva!")));
  } /* End _save(). */

} /* End class. */
