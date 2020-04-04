import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "../utils.dart" as utils;
import "MedicamentosDB.dart";
import "MedicamentosModel.dart" show MedicamentosModel, medicamentosModel;


/// ********************************************************************************************************************
/// The Tasks Entry sub-screen.
/// ********************************************************************************************************************
class MedicamentosForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _descriptionEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  MedicamentosForm() {

    print("##14 TasksList.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _descriptionEditingController.addListener(() {
      medicamentosModel.entidadeSendoEditada.description = _descriptionEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##15 MedicamentosForm.build()");

    // Set value of controllers.
    _descriptionEditingController.text = medicamentosModel.entidadeSendoEditada.description;

    // Return widget.
    return ScopedModel(
      model : medicamentosModel,
      child : ScopedModelDescendant<MedicamentosModel>(
        builder : (BuildContext inContext, Widget inChild, MedicamentosModel inModel) {
          return Scaffold(
            bottomNavigationBar : Padding(
              padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
              child : Row(
                children : [
                  FlatButton(child : Text("Cancel"),
                    onPressed : () {
                      // Hide soft keyboard.
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      // Go back to the list view.
                      inModel.definirIndicePilha(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(child : Text("Save"),
                    onPressed : () { _save(inContext, medicamentosModel); }
                  )
                ]
              )
            ),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
                  // Description.
                  ListTile(
                    leading : Icon(Icons.description),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline,
                      maxLines : 4,
                      decoration : InputDecoration(hintText : "Description"),
                      controller : _descriptionEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter a description"; }
                        return null;
                      }
                    )
                  ),
                  // Due date.
                  ListTile(
                    leading : Icon(Icons.today),
                    title : Text("Due Date"),
                    subtitle : Text(medicamentosModel.dataEscolhida == null ? "" : medicamentosModel.dataEscolhida),
                    trailing : IconButton(
                      icon : Icon(Icons.edit), color : Colors.blue,
                      onPressed : () async {
                        // Request a date from the user.  If one is returned, store it.
                        String dataEscolhida = await utils.selectDate(
                          inContext, medicamentosModel, medicamentosModel.entidadeSendoEditada.dueDate
                        );
                        if (dataEscolhida != null) {
                          medicamentosModel.entidadeSendoEditada.dueDate = dataEscolhida;
                        }
                      }
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
  /// @param inModel   The MedicamentosModel.
  void _save(BuildContext inContext, MedicamentosModel inModel) async {

    print("##16 MedicamentosForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) { return; }

    // Creating a new task.
    if (inModel.entidadeSendoEditada.id == null) {

      print("##17 MedicamentosForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      await MedicamentosDB.db.create(medicamentosModel.entidadeSendoEditada);

    // Updating an existing task.
    } else {

      print("##18 MedicamentosForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      await MedicamentosDB.db.update(medicamentosModel.entidadeSendoEditada);

    }

    // Reload data from database to update list.
    medicamentosModel.loadData("tasks", MedicamentosDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Medicamento salvo!")
      )
    );


  } /* End _save(). */


} /* End class. */
