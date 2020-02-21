import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "ContatosModel.dart";

/// ********************************************************************************************************************
/// Database provider class for contatoss.
/// ********************************************************************************************************************
class ContatosDB {
  /// Static instance and private constructor, since this is a singleton.
  ContatosDB._();
  static final ContatosDB db = ContatosDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.

  Future get database async {
    try {
      if (_db == null) {
        _db = await init();
      }

      print("##80 contatoss ContatosDB.get-database(): _db = $_db");

      return _db;
    } catch (e) {
      print("##81 ERRO get database: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("contatoss ContatosDB.init()");

    String path = join(utils.docsDir.path, "contatoss.db");
    print("##82 contatoss ContatosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS contatoss ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "email TEXT,"
          "phone TEXT,"
          "birthday TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a contatos from a Map.
  Contato contatoFromMap(Map inMap) {
    print("##83 contatoss ContatosDB.contatoFromMap(): inMap = $inMap");

    Contato contato = Contato();
    contato.id = inMap["id"];
    contato.name = inMap["name"];
    contato.phone = inMap["phone"];
    contato.email = inMap["email"];
    contato.birthday = inMap["birthday"];

    print(
        "##84 contatoss ContatosDB.contatoFromMap(): contato = $contato");

    return contato;
  } /* End contatoFromMap(); */

  /// Create a Map from a contatos.
  Map<String, dynamic> contatoToMap(Contato inContato) {
    print(
        "##85 contatoss ContatosDB.contatosToMap(): inContato = $inContato");

    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inContato.id;
    map["name"] = inContato.name;
    map["phone"] = inContato.phone;
    map["email"] = inContato.email;
    map["birthday"] = inContato.birthday;

    print("##86 contatoss ContatosDB.contatosToMap(): map = $map");

    return map;
  } /* End contatosToMap(). */

  /// Create a contatos.
  ///
  /// @param  inContato the contatos object to create.
  /// @return           The ID of the created contatos.
  Future create(Contato inContato) async {
    print("##87 contatoss ContatosDB.create(): inContato = $inContato");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM contatoss");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    await db.rawInsert(
        "INSERT INTO contatoss (id, name, email, phone, birthday) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inContato.name,
          inContato.email,
          inContato.phone,
          inContato.birthday
        ]);

    return id;
  } /* End create(). */

  /// Get a specific contatos.
  ///
  /// @param  inID The ID of the contatos to get.
  /// @return      The corresponding contatos object.
  Future<Contato> get(int inID) async {
    print("##88 contatoss ContatosDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("contatoss", where: "id = ?", whereArgs: [inID]);

    print("##89 contatoss ContatosDB.get(): rec.first = $rec.first");

    return contatoFromMap(rec.first);
  } /* End get(). */

  /// Get all contatoss.
  ///
  /// @return A List of contatos objects.
  Future<List> getAll() async {
    print("##90 contatoss ContatosDB.getAll()");
    try {
      Database db = await database;
      var recs = await db.query("contatoss");
      var list =
          recs.isNotEmpty ? recs.map((m) => contatoFromMap(m)).toList() : [];

      print("##91 contatoss ContatosDB.getAll(): list = $list");

      return list;
    } catch (e) {
      print("##92 ERRO getAll(): try_catch($e)");
      return null;
    }
  } /* End getAll(). */

  /// Update a contatos.
  ///
  /// @param  inContato The contatos to update.
  /// @return           Future.
  Future update(Contato inContato) async {
    print("##93 contatos ContatosDB.update(): inContato = $inContato");

    Database db = await database;
    return await db.update("contatos", contatoToMap(inContato),
        where: "id = ?", whereArgs: [inContato.id]);
  } /* End update(). */

  /// Delete a contatos.
  ///
  /// @param  inID The ID of the contatos to delete.
  /// @return      Future.
  Future delete(int inID) async {
    print("##94 contatoss ContatosDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("contatos", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
