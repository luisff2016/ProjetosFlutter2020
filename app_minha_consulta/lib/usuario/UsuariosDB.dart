import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "UsuariosModel.dart";

/// ********************************************************************************************************************
/// Classe do provedor de banco de dados
/// ********************************************************************************************************************

class UsuariosDB {
  /// Static instance and private constructor, since this is a singleton.
  UsuariosDB._();
  static final UsuariosDB db = UsuariosDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    if (_db == null) {
      print("## usuario Classe UsuariosDB: ERRO _db: null");
      _db = await init();
    }
    print("## usuario UsuariosDB.get-database(): _db = $_db");
    return _db;
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("## usuario UsuariosDB.init()");
    String path = join(utils.docsDir.path, "usuarios.db");
    print("## usuario UsuariosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS usuarios ("
          "id INTEGER PRIMARY KEY,"
          "protocolo INT,"
          "cpf INT,"
          "nome TEXT,"
          "color TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a usuario from a Map.
  Usuario usuarioFromMap(Map inMap) {
    print("## usuario UsuariosDB.usuarioFromMap(): inMap = $inMap");
    Usuario usuario = Usuario();
    usuario.id = inMap["id"];
    usuario.protocolo = inMap["protocolo"];
    usuario.cpf = inMap["cpf"];
    usuario.nome = inMap["nome"];
    usuario.color = inMap["color"];
    print("## usuario UsuariosDB.usuarioFromMap(): usuario = $usuario");
    return usuario;
  } /* End usuarioFromMap(); */

  /// Create a Map from a usuario.
  Map<String, dynamic> usuarioToMap(Usuario inUsuario) {
    print("## usuario UsuariosDB.usuarioToMap(): inUsuario = $inUsuario");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inUsuario.id;
    map["protocolo"] = inUsuario.protocolo;
    map["cpf"] = inUsuario.cpf;
    map["nome"] = inUsuario.nome;
    map["color"] = inUsuario.color;
    print("## usuario UsuariosDB.usuarioToMap(): map = $map");
    return map;
  } /* End usuarioToMap(). */

  /// Create a usuario.
  ///
  /// @param  inUsuario The usuario object to create.
  /// @return        Future.
  Future create(Usuario inUsuario) async {
    print("## usuario UsuariosDB.create(): inUsuario = $inUsuario");
    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM usuarios");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }
    print("## usuarios UsuariosDB.create(): id = $id");
    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO Usuarios (id, protocolo, cpf, color) VALUES (?, ?, ?, ?)",
        [
          id,
          inUsuario.protocolo,
          inUsuario.cpf,
          inUsuario.nome,
          inUsuario.color
        ]);
  } /* End create(). */

  /// Get a specific usuario.
  ///
  /// @param  inID The ID of the usuario to get.
  /// @return      The corresponding usuario object.
  Future<Usuario> get(int inID) async {
    print("## usuario UsuariosDB.get(): inID = $inID");
    Database db = await database;
    var rec = await db.query("usuarios", where: "id = ?", whereArgs: [inID]);
    print("## usuario UsuariosDB.get(): rec.first = $rec.first");
    return usuarioFromMap(rec.first);
  } /* End get(). */

  /// Get all Usuarios.
  ///
  /// @return A List of usuario objects.
  Future<List> get getAll async {
    print("## suario UsuariosDB.getAll()");
    Database db = await database;
    var recs = await db.query("usuarios");
    var list =
        recs.isNotEmpty ? recs.map((m) => usuarioFromMap(m)).toList() : [];
    print("## usuario UsuariosDB.getAll(): list = $list");
    return list;
  } /* End getAll(). */

  /// Update a usuario.
  ///
  /// @param inUsuario The usuario to update.
  /// @return       Future.
  Future update(Usuario inUsuario) async {
    print("## usuario UsuariosDB.update(): inUsuario = $inUsuario");
    Database db = await database;
    return await db.update("usuarios", usuarioToMap(inUsuario),
        where: "id = ?", whereArgs: [inUsuario.id]);
  } /* End update(). */

  /// Delete a usuario.
  ///
  /// @param inID The ID of the usuario to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("## usuario UsuariosDB.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("usuarios", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
