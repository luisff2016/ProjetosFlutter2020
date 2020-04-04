import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "NotificacoesModel.dart";

/// ********************************************************************************************************************
/// Database provider class for notificacoes.
/// ********************************************************************************************************************
class NotificacoesDB {
  /// Static instance and private constructor, since this is a singleton.
  NotificacoesDB._();
  static final NotificacoesDB db = NotificacoesDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    try {
      if (_db == null) {
        print("## ERRO _db: null");
        _db = await init();
      }
      print("## notificacao NotificacoesDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("## ERRO _db: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "notificacoes.db");
    print("## notificacao NotificacoesDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS notificacoes ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a notificacoes from a Map.
  Notificacao notificacaoFromMap(Map inMap) {
    print("## notificacao NotificacoesDB.notificacoesFromMap(): inMap = $inMap");
    Notificacao notificacao = Notificacao();
    notificacao.id = inMap["id"];
    notificacao.title = inMap["title"];
    notificacao.description = inMap["description"];
    notificacao.apptDate = inMap["apptDate"];
    notificacao.apptTime = inMap["apptTime"];
    print(
        "## notificacao NotificacoesDB.notificacaoFromMap(): notificacao = $notificacao");

    return notificacao;
  } /* End aNotificacoesFromMap(); */

  /// Create a Map from a notificacoes.
  Map<String, dynamic> notificacaoToMap(Notificacao inNotificacao) {
    print(
        "## notificacao NotificacoesDB.notificacaoToMap(): inNotificacao = $inNotificacao");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inNotificacao.id;
    map["title"] = inNotificacao.title;
    map["description"] = inNotificacao.description;
    map["apptDate"] = inNotificacao.apptDate;
    map["apptTime"] = inNotificacao.apptTime;
    print("## notificacao NotificacoesDB.notificacaoToMap(): map = $map");
    return map;
  } /* End aNotificacaoToMap(). */

  /// Create a notificacoes.
  ///
  /// @param inANotificacao the notificacoes object to create.
  Future create(Notificacao inNotificacao) async {
    print("## notificacao NotificacoesDB.create(): inNotificacao = $inNotificacao");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM notificacoes");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO notificacoes (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inNotificacao.title,
          inNotificacao.description,
          inNotificacao.apptDate,
          inNotificacao.apptTime
        ]);
  } /* End create(). */

  /// Get a specific notificacoes.
  ///
  /// @param  inID The ID of the notificacoes to get.
  /// @return      The corresponding notificacoes object.
  Future<Notificacao> get(int inID) async {
    print("## notificacao NotificacoesDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("notificacoes", where: "id = ?", whereArgs: [inID]);
    print("## notificacao NotificacoesDB.get(): rec.first = $rec.first");
    return notificacaoFromMap(rec.first);
  } /* End get(). */

  /// Get all Notificacoes.
  ///
  /// @return A List of notificacoes objects.
  Future<List> getAll() async {
    try {
      Database db = await database;
      var recs = await db.query("notificacoes");
      var list =
          recs.isNotEmpty ? recs.map((m) => notificacaoFromMap(m)).toList() : [];
      print("## notificacao NotificacoesDB.getAll(): list = $list");
      return list;
    } catch (e) {
      print("## ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a aNotificacoes.
  ///
  /// @param inANotificacao The aNotificacoes to update.
  Future update(Notificacao inNotificacao) async {
    print("## notificacao NotificacoesDB.update(): inNotificacao = $inNotificacao");

    Database db = await database;
    return await db.update("notificacoes", notificacaoToMap(inNotificacao),
        where: "id = ?", whereArgs: [inNotificacao.id]);
  } /* End update(). */

  /// Delete a aNotificacoes.
  ///
  /// @param inID The ID of the aNotificacoes to delete.
  Future delete(int inID) async {
    print("## notificacao NotificacoesDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("notificacoes", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
