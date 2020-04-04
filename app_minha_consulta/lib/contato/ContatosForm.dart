import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:scoped_model/scoped_model.dart";
import "package:image_picker/image_picker.dart";
import "../utils.dart" as utils;
import "ContatosDB.dart";
import "ContatosModel.dart" show ContatosModel, contatosModel;


/// ********************************************************************************************************************
/// The Contacts Entry sub-screen.
/// ********************************************************************************************************************
class ContatosForm extends StatelessWidget {


  /// Controllers for TextFields.
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();


  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  /// Constructor.
  ContatosForm() {

    print("##68 ContatosForm.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _nameEditingController.addListener(() {
      contatosModel.entidadeSendoEditada.name = _nameEditingController.text;
    });
    _phoneEditingController.addListener(() {
      contatosModel.entidadeSendoEditada.phone = _phoneEditingController.text;
    });
    _emailEditingController.addListener(() {
      contatosModel.entidadeSendoEditada.email = _emailEditingController.text;
    });

  } /* End constructor. */


  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {

    print("##69 ContatosForm.build()");

    // Set value of controllers.
    _nameEditingController.text = contatosModel.entidadeSendoEditada.name;
    _phoneEditingController.text = contatosModel.entidadeSendoEditada.phone;
    _emailEditingController.text = contatosModel.entidadeSendoEditada.email;

    // Return widget.
    return ScopedModel(
      model : contatosModel,
      child : ScopedModelDescendant<ContatosModel>(
        builder : (BuildContext inContext, Widget inChild, ContatosModel inModel) {
          // Get reference to avatar file, if any.  If it doesn't exist and the entidadeSendoEditada has an id then
          // look for an avatar file for the existing contact.
          File avatarFile = File(join(utils.docsDir.path, "avatar"));
          if (avatarFile.existsSync() == false) {
            if (inModel.entidadeSendoEditada != null && inModel.entidadeSendoEditada.id != null) {
              avatarFile = File(join(utils.docsDir.path, inModel.entidadeSendoEditada.id.toString()));
            }
          }
          return Scaffold(
            bottomNavigationBar : Padding(
            padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
            child : Row(
              children : [
                FlatButton(
                  child : Text("Cancel"),
                  onPressed : () {
                    // Delete avatar file if it exists (it shouldn't, but better safe than sorry!)
                    File avatarFile = File(join(utils.docsDir.path, "avatar"));
                    if (avatarFile.existsSync()) {
                      avatarFile.deleteSync();
                    }
                    // Hide soft keyboard.
                    FocusScope.of(inContext).requestFocus(FocusNode());
                    // Go back to the list view.
                    inModel.definirIndicePilha(0);
                  }
                ),
                Spacer(),
                FlatButton(
                  child : Text("Save"),
                  onPressed : () { _save(inContext, inModel); }
                )
              ]
            )),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
                  ListTile(
                    title : avatarFile.existsSync() ? Image.file(avatarFile) : Text("No avatar image for this contact"),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () => _selectAvatar(inContext)
                    )
                  ),
                  // Name.
                  ListTile(
                    leading : Icon(Icons.person),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Name"),
                      controller : _nameEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter a name"; }
                        return null;
                      }
                    )
                  ),
                  // Phone.
                  ListTile(
                    leading : Icon(Icons.phone),
                    title : TextFormField(
                      keyboardType : TextInputType.phone,
                      decoration : InputDecoration(hintText : "Phone"),
                      controller : _phoneEditingController
                    )
                  ),
                  // Email.
                  ListTile(
                    leading : Icon(Icons.email),
                    title : TextFormField(
                      keyboardType : TextInputType.emailAddress,
                      decoration : InputDecoration(hintText : "Email"),
                      controller : _emailEditingController
                    )
                  ),
                  // Birthday.
                  ListTile(
                    leading : Icon(Icons.today),
                    title : Text("Birthday"),
                    subtitle : Text(contatosModel.dataEscolhida == null ? "" : contatosModel.dataEscolhida),
                    trailing : IconButton(
                      icon : Icon(Icons.edit),
                      color : Colors.blue,
                      onPressed : () async {
                        // Request a date from the user.  If one is returned, store it.
                        String dataEscolhida = await utils.selectDate(
                          inContext, contatosModel, contatosModel.entidadeSendoEditada.birthday
                        );
                        if (dataEscolhida != null) {
                          contatosModel.entidadeSendoEditada.birthday = dataEscolhida;
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


  /// Function for handling taps on the edit icon for avatar.
  ///
  /// @param  inContext The BuildContext of the parent Widget.
  /// @return           Future.
  Future _selectAvatar(BuildContext inContext) {

    print("ContatosForm._selectAvatar()");

    return showDialog(context : inContext,
      builder : (BuildContext inDialogContext) {
        return AlertDialog(
          content : SingleChildScrollView(
            child : ListBody(
              children : [
                GestureDetector(
                  child : Text("Take a picture"),
                  onTap : () async {
                    var cameraImage = await ImagePicker.pickImage(source : ImageSource.camera);
                    if (cameraImage != null) {
                      // Copy the file into the app's docs directory.
                      cameraImage.copySync(join(utils.docsDir.path, "avatar"));
                      // Tell the entry screen to rebuild itself to show the avatar.
                      contatosModel.triggerRebuild();
                    }
                    // Hide this dialog.
                    Navigator.of(inDialogContext).pop();
                  }
                ),
                Padding(padding : EdgeInsets.all(10)),
                GestureDetector(
                  child : Text("Select From Gallery"),
                  onTap : () async {
                    var galleryImage = await ImagePicker.pickImage(source : ImageSource.gallery);
                    if (galleryImage != null) {
                      // Copy the file into the app's docs directory.
                      galleryImage.copySync(join(utils.docsDir.path, "avatar"));
                      // Tell the entry screen to rebuild itself to show the avatar.
                      contatosModel.triggerRebuild();
                    }
                    // Hide this dialog.
                    Navigator.of(inDialogContext).pop();
                  }
                )
              ]
            )
          )
        );
      }
    );

  } /* End _selectAvatar(). */


  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The ContatosModel.
  void _save(BuildContext inContext, ContatosModel inModel) async {

    print("##70 ContatosForm._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) { return; }

    // We'll need the ID whether creating or updating way.
    var id;

    // Creating a new contact.
    if (inModel.entidadeSendoEditada.id == null) {

      print("##71 ContatosForm._save(): Creating: ${inModel.entidadeSendoEditada}");
      id = await ContatosDB.db.create(contatosModel.entidadeSendoEditada);

    // Updating an existing contact.
    } else {

      print("##72 ContatosForm._save(): Updating: ${inModel.entidadeSendoEditada}");
      id = contatosModel.entidadeSendoEditada.id;
      await ContatosDB.db.update(contatosModel.entidadeSendoEditada);

    }

    // If there is an avatar file, rename it using the ID.
    File avatarFile = File(join(utils.docsDir.path, "avatar"));
    if (avatarFile.existsSync()) {
      print("##73 ContatosForm._save(): Renaming avatar file to id = $id");
      avatarFile.renameSync(join(utils.docsDir.path, id.toString()));
    }

    // Reload data from database to update list.
    contatosModel.loadData("contacts", ContatosDB.db);

    // Go back to the list view.
    inModel.definirIndicePilha(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Contact saved")
      )
    );

  } /* End _save(). */


} /* End class. */
