import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "UsuariosDB.dart";
import "UsuariosModel.dart" show UsuariosModel, usuariosModel;

/// ****************************************************************************
/// Subtela para entradas da entidade.
/// ****************************************************************************
class UsuariosForm extends StatelessWidget {
  /// Controladores para campos de texto.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  // Chave para o formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  UsuariosForm() {
    print("## usuario UsuariosForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      usuariosModel.entidadeSendoEditada.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      usuariosModel.entidadeSendoEditada.content = _contentEditingController.text;
    });
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## usuario UsuariosForm.build()");

    // Set value of controllers.
    _titleEditingController.text = usuariosModel.entidadeSendoEditada.title;
    _contentEditingController.text = usuariosModel.entidadeSendoEditada.content;

    // Return widget.
    return ScopedModel(
        model: usuariosModel,
        child: ScopedModelDescendant<UsuariosModel>(builder:
                (BuildContext inContext, Widget inChild,
                    UsuariosModel inModel) {
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
                          _save(inContext, usuariosModel);
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
                                                  usuariosModel.color == "red"
                                                      ? Colors.red
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color = "red";
                                usuariosModel.setColor("red");
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
                                                  usuariosModel.color == "green"
                                                      ? Colors.green
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color = "green";
                                usuariosModel.setColor("green");
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
                                                  usuariosModel.color == "blue"
                                                      ? Colors.blue
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color = "blue";
                                usuariosModel.setColor("blue");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.yellow, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: usuariosModel.color ==
                                                      "yellow"
                                                  ? Colors.yellow
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color =
                                    "yellow";
                                usuariosModel.setColor("yellow");
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
                                                  usuariosModel.color == "grey"
                                                      ? Colors.grey
                                                      : Theme.of(inContext)
                                                          .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color = "grey";
                                usuariosModel.setColor("grey");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                              color: Colors.purple, width: 15) +
                                          Border.all(
                                              width: 5,
                                              color: usuariosModel.color ==
                                                      "purple"
                                                  ? Colors.purple
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                              onTap: () {
                                usuariosModel.entidadeSendoEditada.color =
                                    "purple";
                                usuariosModel.setColor("purple");
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
  /// @param inModel   The UsuariosModel.
  void _save(BuildContext inContext, UsuariosModel inModel) async {
    print("## usuario UsuariosForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entidadeSendoEditada.id == null) {
      print(
          "## usuario UsuariosForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      await UsuariosDB.db.create(usuariosModel.entidadeSendoEditada);

      // Updating an existing note.
    } else {
      print(
          "## usuario UsuariosForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      await UsuariosDB.db.update(usuariosModel.entidadeSendoEditada);
    }

    // Reload data from database to update list.
    usuariosModel.loadData("usuarios", UsuariosDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Usuario salvo!")));
  } /* End _save(). */

} /* End class. */
