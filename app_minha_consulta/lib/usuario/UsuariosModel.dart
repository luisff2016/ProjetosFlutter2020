import "../BaseModel.dart";

/// Esta classe representa um tipo de entidade existente no aplicativo.
class Usuario {
  /// Os campos que esse tipo de entidade contém.
  int id;
  int protocolo;
  int cpf;
  String nome;
  String color;

  /// Just for debugging, so we get something useful in the console.
  String toString() {
    return "{ id=$id, protocolo=$protocolo, cpf=$cpf, nome=$nome,  color=$color }";
  }
} /* End class. */

/// ****************************************************************************
/// O modelo que suporta as visualizações deste tipo de entidade.
/// ****************************************************************************
class UsuariosModel extends BaseModel {
  /// The color.  Needed to be able to display what the user picks in the Text widget on the entry screen.
  String color;

  /// For display of the color chosen by the user.
  ///
  /// @param inColor The color.
  void setColor(String inColor) {
    print("## usuario UsuariosModel.setColor(): inColor = $inColor");
    color = inColor;
    notifyListeners();
  } /* End setColor(). */

} /* End class. */

// Instancia unica segundo o padrao Singleton.
UsuariosModel usuariosModel = UsuariosModel();
