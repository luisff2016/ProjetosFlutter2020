import "dart:async";
import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "../utils.dart" as utils;
import "AnotacoesDB.dart";
import "AnotacoesModel.dart" show AnotacoesModel, anotacoesModel;


/// ********************************************************************************************************************
/// The Appointments Entry sub-screen.
/// ********************************************************************************************************************
class AnotacoesForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  AnotacoesForm() {

    print("##105 AnotacoesForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      anotacoesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      anotacoesModel.entityBeingEdited.description = _descriptionEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##106 AnotacoesForm.build()");

    // Set value of controllers.
    _titleEditingController.text = anotacoesModel.entityBeingEdited.title;
    _descriptionEditingController.text = anotacoesModel.entityBeingEdited.description;

    // Return widget.
    return ScopedModel(
      model : anotacoesModel,
      child : ScopedModelDescendant<AnotacoesModel>(
        builder : (BuildContext inContext, Widget inChild, AnotacoesModel inModel) {
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
                    onPressed : () { _save(inContext, anotacoesModel); }
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
                    subtitle : Text(anotacoesModel.chosenDate == null ? "" : anotacoesModel.chosenDate),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () async {
                        // Request a date from the user.  If one is returned, store it.
                        String chosenDate = await utils.selectDate(
                          inContext, anotacoesModel, anotacoesModel.entityBeingEdited.apptDate
                        );
                        if (chosenDate != null) {
                          anotacoesModel.entityBeingEdited.apptDate = chosenDate;
                        }
                      }
                    )
                  ),
                  // Appointment Time.
                  ListTile(
                    leading : Icon(Icons.alarm),
                    title : Text("Time"),
                    subtitle : Text(anotacoesModel.apptTime == null ? "" : anotacoesModel.apptTime),
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
    if (anotacoesModel.entityBeingEdited.apptTime != null) {
      List timeParts = anotacoesModel.entityBeingEdited.apptTime.split(",");
      // Create a DateTime using the hours, minutes and a/p from the apptTime.
      initialTime = TimeOfDay(hour : int.parse(timeParts[0]), minute : int.parse(timeParts[1]));
    }

    // Now request the time.
    TimeOfDay picked = await showTimePicker(context : inContext, initialTime : initialTime);

    // If they didn't cancel, update it on the appointment being edited as well as the apptTime field in the model so
    // it shows on the screen.
    if (picked != null) {
      anotacoesModel.entityBeingEdited.apptTime = "${picked.hour},${picked.minute}";
      anotacoesModel.setApptTime(picked.format(inContext));
    }

  } /* End _selectTime(). */


  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The AnotacoesModel.
  void _save(BuildContext inContext, AnotacoesModel inModel) async {

      print("##107 AnotacoesForm._save()");

      // Abort if form isn't valid.
      if (!_formKey.currentState.validate()) { return; }

      // Creating a new appointment.
      if (inModel.entityBeingEdited.id == null) {

        print("##108 AnotacoesForm._save(): Creating: ${inModel.entityBeingEdited}");
        await AnotacoesDB.db.create(anotacoesModel.entityBeingEdited);

      // Updating an existing appointment.
      } else {

        print("##109 AnotacoesForm._save(): Updating: ${inModel.entityBeingEdited}");
        await AnotacoesDB.db.update(anotacoesModel.entityBeingEdited);

      }

      // Reload data from database to update list.
      anotacoesModel.loadData("anotacoes", AnotacoesDB.db);

      // Go back to the list view.
      inModel.setStackIndex(0);

      // Show SnackBar.
      Scaffold.of(inContext).showSnackBar(
        SnackBar(
          backgroundColor : Colors.green,
          duration : Duration(seconds : 2),
          content : Text("Anotacoes salvas")
        )
      );

  } /* End _save(). */


} /* End class. */
