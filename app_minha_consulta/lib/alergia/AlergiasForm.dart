import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "AlergiasDB.dart";
import "AlergiasModel.dart" show AlergiasModel, alergiasModel;


/// ****************************************************************************
/// The Notes Entry sub-screen.
/// ****************************************************************************
class AlergiasForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  AlergiasForm() {

    print("##40 AlergiasForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      alergiasModel.entidadeSendoEditada.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      alergiasModel.entidadeSendoEditada.content = _contentEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##41 AlergiasForm.build()");

    // Set value of controllers.
    _titleEditingController.text = alergiasModel.entidadeSendoEditada.title;
    _contentEditingController.text = alergiasModel.entidadeSendoEditada.content;

    // Return widget.
    return ScopedModel(
      model : alergiasModel,
      child : ScopedModelDescendant<AlergiasModel>(
        builder : (BuildContext inContext, Widget inChild, AlergiasModel inModel) {
          return Scaffold(
            bottomNavigationBar : Padding(
              padding : EdgeInsets.symmetric(vertical : 0, horizontal : 5),
              child : Row(
                children : [
                  FlatButton(
                    child : Text("Cancel"),
                    onPressed : () {
                      // Hide soft keyboard.
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      // Go back to the list view.
                      inModel.definirIndicePilha(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child : Text("Save"),
                    onPressed : () { _save(inContext, alergiasModel); }
                  )
                ]
              )
            ),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
                  // Title.
                  ListTile(
                    leading : Icon(Icons.title),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Title"),
                      controller : _titleEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter a title"; }
                        return null;
                      }
                    )
                  ),
                  // Content.
                  ListTile(
                    leading : Icon(Icons.content_paste),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline, maxLines : 8,
                      decoration : InputDecoration(hintText : "Content"),
                      controller : _contentEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter content"; }
                        return null;
                      }
                    )
                  ),
                  // Note color.
                  ListTile(
                    leading : Icon(Icons.color_lens),
                    title : Row(
                      children : [
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.red, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "red" ? Colors.red : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "red";
                            alergiasModel.setColor("red");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.green, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "green" ? Colors.green : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "green";
                            alergiasModel.setColor("green");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.blue, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "blue" ? Colors.blue : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "blue";
                            alergiasModel.setColor("blue");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.yellow, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "yellow" ? Colors.yellow : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "yellow";
                            alergiasModel.setColor("yellow");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.grey, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "grey" ? Colors.grey : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "grey";
                            alergiasModel.setColor("grey");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.purple, width : 15) +
                              Border.all(
                                width : 5,
                                color : alergiasModel.color == "purple" ? Colors.purple : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            alergiasModel.entidadeSendoEditada.color = "purple";
                            alergiasModel.setColor("purple");
                          }
                        )
                      ]
                    )
                  )
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
  /// @param inModel   The NAlergiasModel.
  void _save(BuildContext inContext, AlergiasModel inModel) async {

    print("##42 AlergiasForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) { return; }

    // Creating a new note.
    if (inModel.entidadeSendoEditada.id == null) {

      print("##43 AlergiasForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      await AlergiasDB.db.create(alergiasModel.entidadeSendoEditada);

    // Updating an existing note.
    } else {

      print("##44 AlergiasForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      await AlergiasDB.db.update(alergiasModel.entidadeSendoEditada);

    }

    // Reload data from database to update list.
    alergiasModel.loadData("alergias", AlergiasDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Alergia salva!")
      )
    );

  } /* End _save(). */


} /* End class. */
