import 'package:app_minha_consulta/consulta/ConsultasModel.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";


/// ********************************************************************************************************************
/// Classe para fazer consultas no Sistema AGHU - PostgresSQL.
/// ********************************************************************************************************************
class ConsultasAGHU {


  /// Static instance and private constructor, since this is a singleton.
  ConsultasAGHU._();
  static final ConsultasAGHU aghu = ConsultasAGHU._();


  /// The one and only database instance.
  Database _aghu;


  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    try{
if (_aghu == null) {
      print("##120 ERRO _aghu: null");
      _aghu = await init();
    }
    print("##121 Consultas ConsultasAGHU.get-database(): _aghu = $_aghu");
    return _aghu;
    }catch(e){
      print("##122 ERRO _aghu: try_catch($e)");
    }

    

  } /* End database getter. */


  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {

    String path = join("C:\Program Files\PostgreSQL\12\data", "Consulta");
    print("##123 Consultas ConsultasAGHU.init(): path = $path");
    Database aghu = await openDatabase(path, version : 1, onOpen : (aghu) { },
      
    );
    return aghu;

  } /* End init(). */


  /// Create a consulta from a Map.
  Consulta consultaFromMap(Map inMap) {

    print("##124 Consultas ConsultasAGHU.consultaFromMap(): inMap = $inMap");
    Consulta consulta = Consulta();
    consulta.id = inMap["id"];
    consulta.title = inMap["title"];
    consulta.description = inMap["description"];
    consulta.apptDate = inMap["apptDate"];
    consulta.apptTime = inMap["apptTime"];
    print("##125 Consultas ConsultasAGHU.consultaFromMap(): consulta = $consulta");

    return consulta;

  } /* End consultaFromMap(); */


  /// Create a Map from a consulta.
  Map<String, dynamic> consultaToMap(Consulta inConsulta) {

    print("##126 Consultas ConsultasAGHU.consultaToMap(): inConsulta = $inConsulta");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inConsulta.id;
    map["title"] = inConsulta.title;
    map["description"] = inConsulta.description;
    map["apptDate"] = inConsulta.apptDate;
    map["apptTime"] = inConsulta.apptTime;
    print("##127 Consultas ConsultasAGHU.consultaToMap(): map = $map");

    return map;

  } /* End consultaToMap(). */


  /// Create a consulta.
  ///
  /// @param inConsulta the consulta object to create.
  Future create(Consulta inConsulta) async {

    print("##128 Consultas ConsultasAGHU.create(): inConsulta = $inConsulta");

    Database aghu = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await aghu.rawQuery("SELECT MAX(id) + 1 AS id FROM Consultas");
    int id = val.first["id"];
    if (id == null) { id = 1; }

    // Insert into table.
    return await aghu.rawInsert(
      "INSERT INTO Consultas (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
      [
        id,
        inConsulta.title,
        inConsulta.description,
        inConsulta.apptDate,
        inConsulta.apptTime
      ]
    );

  } /* End create(). */


  /// Get a specific consulta.
  ///
  /// @param  inID The ID of the consulta to get.
  /// @return      The corresponding consulta object.
  Future<Consulta> get(int inID) async {

    print("##129 Consultas ConsultasAGHU.get(): inID = $inID");

    Database aghu = await database;
    var rec = await aghu.query("Consultas", where : "id = ?", whereArgs : [ inID ]);
    print("##130 Consultas ConsultasAGHU.get(): rec.first = $rec.first");
    return consultaFromMap(rec.first);

  } /* End get(). */


  /// Get all Consultas.
  ///
  /// @return A List of consulta objects.
  Future<List> getAll() async {
    try{
      Database aghu = await database;
      var recs = await aghu.query("Consultas");
      var list = recs.isNotEmpty ? recs.map((m) => consultaFromMap(m)).toList() : [ ];
      print("##131 Consultas ConsultasAGHU.getAll(): list = $list");
      return list;
    }catch(e){
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */


  /// Update a consulta.
  ///
  /// @param inConsulta The consulta to update.
  Future update(Consulta inConsulta) async {

    print("##133 Consultas ConsultasAGHU.update(): inConsulta = $inConsulta");

    Database aghu = await database;
    return await aghu.update(
      "Consultas", consultaToMap(inConsulta), where : "id = ?", whereArgs : [ inConsulta.id ]
    );

  } /* End update(). */


  /// Delete a consulta.
  ///
  /// @param inID The ID of the consulta to delete.
  Future delete(int inID) async {

    print("##134 Consultas ConsultasAGHU.delete(): inID = $inID");

    Database aghu = await database;
    return await aghu.delete("Consultas", where : "id = ?", whereArgs : [ inID ]);

  } /* End delete(). */


} /* End class. */