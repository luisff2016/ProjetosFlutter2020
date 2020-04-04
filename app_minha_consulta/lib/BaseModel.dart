import "package:scoped_model/scoped_model.dart";

/// ********************************************************************************************************************
/// Base class that the model for all entities extend.
/// ********************************************************************************************************************
class BaseModel extends Model {
  /// Qual página da pilha está sendo exibida no momento.
  int indicePilha = 0;

  /// A lista de entidades.
  List listaEntidades = [];

  /// A entidade que está sendo editada.
  var entidadeSendoEditada;

  /// A data escolhida pelo usuário. Precisava ser capaz de exibir o que o usuário seleciona na tela de entrada.
  String dataEscolhida;

  /// Para exibição da data escolhida pelo usuário.
  ///
  /// @param inDate The date in MM/DD/YYYY form.
  void definirDataEscolhida(String inDate) {
    print("##9 BaseModel.definirDataEscolhida(): inDate = $inDate");
    dataEscolhida = inDate;
    notifyListeners();
  } /* End definirDataEscolhida(). */

  /// Load data from database.
  ///
  /// @param tipoEntidade The type of entity being loaded ("appointments", "contacts", "notes" or "tasks").
  /// @param inDatabase   The DBProvider.db instance for the entity.
  void loadData(String tipoEntidade, dynamic inDatabase) async {
    print("##10 ${tipoEntidade}Model.loadData()");
    // Load entities from database.
    listaEntidades = await inDatabase.getAll();
    // Notify listeners that the data is available so they can paint themselves.
    notifyListeners();
  } /* End loadData(). */

  /// For navigating between entry and list views.
  ///
  /// @param inindicePilha The stack index to make current.
  void definirIndicePilha(int inindicePilha) {
    print("## BaseModel.definirIndicePilha(): inindicePilha = $inindicePilha");
    indicePilha = inindicePilha;
    notifyListeners();
  } /* End definirIndicePilha(). */

} /* End class. */
