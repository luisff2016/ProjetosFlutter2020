import "dart:async";
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "../utils.dart" as utils;
import "ConsultasDB.dart";
import "ConsultasModel.dart" show ConsultasModel, consultasModel;


/// ********************************************************************************************************************
/// The Consultas Entry sub-screen.
/// ********************************************************************************************************************
class ConsultasForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  ConsultasForm() {

    print("##105 ConsultasForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      ConsultasModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      ConsultasModel.entityBeingEdited.description = _descriptionEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##106 ConsultasForm.build()");

    // Set value of controllers.
    _titleEditingController.text = ConsultasModel.entityBeingEdited.title;
    _descriptionEditingController.text = ConsultasModel.entityBeingEdited.description;

    // Return widget.
    return ScopedModel(
      model : ConsultasModel,
      child : ScopedModelDescendant<ConsultasModel>(
        builder : (BuildContext inContext, Widget inChild, ConsultasModel inModel) {
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
                      inModel.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child : Text("Save"),
                    onPressed : () { _save(inContext, ConsultasModel); }
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
                    subtitle : Text(ConsultasModel.chosenDate == null ? "" : ConsultasModel.chosenDate),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () async {
                        // Request a date from the user.  If one is returned, store it.
                        String chosenDate = await utils.selectDate(
                          inContext, ConsultasModel, ConsultasModel.entityBeingEdited.apptDate
                        );
                        if (chosenDate != null) {
                          ConsultasModel.entityBeingEdited.apptDate = chosenDate;
                        }
                      }
                    )
                  ),
                  // Appointment Time.
                  ListTile(
                    leading : Icon(Icons.alarm),
                    title : Text("Time"),
                    subtitle : Text(ConsultasModel.apptTime == null ? "" : ConsultasModel.apptTime),
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
    if (ConsultasModel.entityBeingEdited.apptTime != null) {
      List timeParts = ConsultasModel.entityBeingEdited.apptTime.split(",");
      // Create a DateTime using the hours, minutes and a/p from the apptTime.
      initialTime = TimeOfDay(hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1]));
    }

    // Now request the time.
    TimeOfDay picked = await showTimePicker(context : inContext, initialTime : initialTime);

    // If they didn't cancel, update it on the appointment being edited as well as the apptTime field in the model so
    // it shows on the screen.
    if (picked != null) {
      ConsultasModel.entityBeingEdited.apptTime = "${picked.hour},${picked.minute}";
      ConsultasModel.setApptTime(picked.format(inContext));
    }

  } /* End _selectTime(). */


  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The ConsultasModel.
  void _save(BuildContext inContext, ConsultasModel inModel) async {

      print("##107 ConsultasForm._save()");

      // Abort if form isn't valid.
      if (!_formKey.currentState.validate()) { return; }

      // Creating a new appointment.
      if (inModel.entityBeingEdited.id == null) {

        print("##108 ConsultasForm._save(): Creating: ${inModel.entityBeingEdited}");
        await ConsultasDB.db.create(ConsultasModel.entityBeingEdited);

      // Updating an existing appointment.
      } else {

        print("##109 ConsultasForm._save(): Updating: ${inModel.entityBeingEdited}");
        await ConsultasDB.db.update(ConsultasModel.entityBeingEdited);

      }

      // Reload data from database to update list.
      ConsultasModel.loadData("Consultas", ConsultasDB.db);

      // Go back to the list view.
      inModel.setStackIndex(0);

      // Show SnackBar.
      Scaffold.of(inContext).showSnackBar(
        SnackBar(
          backgroundColor : Colors.green,
          duration : Duration(seconds : 2),
          content : Text("Appointment saved")
        )
      );

  } /* End _save(). */


} /* End class. */
