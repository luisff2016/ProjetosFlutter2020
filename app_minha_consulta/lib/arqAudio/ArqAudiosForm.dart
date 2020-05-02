import "dart:async";
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "../utils.dart" as utils;
import "ArqAudiosDB.dart";
import "ArqAudiosModel.dart" show ArqAudiosModel, arqAudiosModel;


/// ********************************************************************************************************************
/// The ArqAudios Entry sub-screen.
/// ********************************************************************************************************************
class ArqAudiosForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  ArqAudiosForm() {

    print("##105 ArqAudiosForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      arqAudiosModel.entidadeSendoEditada.title = _titleEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      arqAudiosModel.entidadeSendoEditada.description = _descriptionEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##106 ArqAudiosForm.build()");

    // Set value of controllers.
    _titleEditingController.text = arqAudiosModel.entidadeSendoEditada.title;
    _descriptionEditingController.text = arqAudiosModel.entidadeSendoEditada.description;

    // Return widget.
    return ScopedModel(
      model : arqAudiosModel,
      child : ScopedModelDescendant<ArqAudiosModel>(
        builder : (BuildContext inContext, Widget inChild, ArqAudiosModel inModel) {
          return Scaffold(
            bottomNavigationBar : Padding(
              padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
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
                    onPressed : () { _save(inContext, arqAudiosModel); }
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
                    leading : Icon(Icons.subject),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Title"),
                      controller : _titleEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter a title"; }
                        return null;
                      }
                    )
                  ),
                  // Description.
                  ListTile(
                    leading : Icon(Icons.description),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline,
                      maxLines : 4,
                      decoration : InputDecoration(hintText : "Description"),
                      controller : _descriptionEditingController
                    )
                  ),
                  // Appointment Date.
                  ListTile(
                    leading : Icon(Icons.today),
                    title : Text("Date"),
                    subtitle : Text(arqAudiosModel.dataEscolhida == null ? "" : arqAudiosModel.dataEscolhida),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () async {
                        // Request a date from the user.  If one is returned, store it.
                        String dataEscolhida = await utils.selectDate(
                          inContext, arqAudiosModel, arqAudiosModel.entidadeSendoEditada.apptDate
                        );
                        if (dataEscolhida != null) {
                          arqAudiosModel.entidadeSendoEditada.apptDate = dataEscolhida;
                        }
                      }
                    )
                  ),
                  // Appointment Time.
                  ListTile(
                    leading : Icon(Icons.alarm),
                    title : Text("Time"),
                    subtitle : Text(arqAudiosModel.apptTime == null ? "" : arqAudiosModel.apptTime),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () => _selectTime(inContext)
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


  /// Function for handling taps on the edit icon for apptDate.
  ///
  /// @param inContext  The BuildContext of the parent Widget.
  /// @return           Future.
  Future _selectTime(BuildContext inContext) async {

    // Default to right now, assuming we're adding an appointment.
    TimeOfDay initialTime = TimeOfDay.now();

    // If editing an appointment, set the initialTime to the current apptTime, if any.
    if (arqAudiosModel.entidadeSendoEditada.apptTime != null) {
      List timeParts = arqAudiosModel.entidadeSendoEditada.apptTime.split(",");
      // Create a DateTime using the hours, minutes and a/p from the apptTime.
      initialTime = TimeOfDay(hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1]));
    }

    // Now request the time.
    TimeOfDay picked = await showTimePicker(context : inContext, initialTime : initialTime);

    // If they didn't cancel, update it on the appointment being edited as well as the apptTime field in the model so
    // it shows on the screen.
    if (picked != null) {
      arqAudiosModel.entidadeSendoEditada.apptTime = "${picked.hour},${picked.minute}";
      arqAudiosModel.setApptTime(picked.format(inContext));
    }

  } /* End _selectTime(). */


  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The ArqAudiosModel.
  void _save(BuildContext inContext, ArqAudiosModel inModel) async {

      print("##107 ArqAudiosForm._save()");

      // Abort if form isn't valid.
      if (!_formKey.currentState.validate()) { return; }

      // Creating a new appointment.
      if (inModel.entidadeSendoEditada.id == null) {

        print("##108 ArqAudiosForm._save(): Creating: ${inModel.entidadeSendoEditada}");
        await ArqAudiosDB.db.create(arqAudiosModel.entidadeSendoEditada);

      // Updating an existing appointment.
      } else {

        print("##109 ArqAudiosForm._save(): Updating: ${inModel.entidadeSendoEditada}");
        await ArqAudiosDB.db.update(arqAudiosModel.entidadeSendoEditada);

      }

      // Reload data from database to update list.
      arqAudiosModel.loadData("audios", ArqAudiosDB.db);

      // Go back to the list view.
      inModel.definirIndicePilha(0);

      // Show SnackBar.
      Scaffold.of(inContext).showSnackBar(
        SnackBar(
          backgroundColor : Colors.green,
          duration : Duration(seconds : 2),
          content : Text("Audio salvo!")
        )
      );

  } /* End _save(). */


} /* End class. */
