import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'PacientesForm.dart';
import 'PacientesDB.dart';
import 'PacientesList.dart';
import "PacientesModel.dart" show PacientesModel, pacientesModel;

/// ***********************************************************************************************************
/// Tela de Pacientes.
/// ********************************************************************************************************************

class Pacientes extends StatelessWidget {
  /// Construtor.
  Pacientes() {
    print("## paciente Pacientes.constructor");

    // Carregamento inicial dos dados.
    pacientesModel.loadData("pacientes", PacientesDB.db);
  } /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## paciente Pacientes.build()");

    return ScopedModel<PacientesModel>(
        model: pacientesModel,
        child: ScopedModelDescendant<PacientesModel>(builder:
                (BuildContext inContext, Widget inChild,
                    PacientesModel inModel) {
          return IndexedStack(index: inModel.indicePilha, children: [
            PacientesList(),
            PacientesForm()
          ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  } /* End build(). */

} /* End class. */
