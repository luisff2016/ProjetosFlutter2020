class Consulta {
  String _medico;
  String _especialidade;
  String _consultorio;
  int _fkconsulta;
  int _idConsulta;

  Consulta(this._medico, this._especialidade, this._consultorio, this._fkconsulta);

  Consulta.map(dynamic obj) {
    this._idConsulta = obj['idConsulta'];
    this._medico = obj['medico'];
    this._especialidade = obj['especialidade'];
    this._consultorio = obj['consultorio'];
    this._fkconsulta = obj['fkconsulta'];
  }

  String get medico => _medico;
  String get especialidade => _especialidade;
  String get consultorio => _consultorio;
  String get fkconsulta => _fkconsulta.toString();
  int get idConsulta => _idConsulta;

  Map<String, dynamic> toMap() {
    var mapa = new Map<String, dynamic>();

    mapa['medico'] = _medico;
    mapa['especialidade'] = _especialidade;
    mapa['consultorio'] = _consultorio;
    mapa['fkconsulta'] = _fkconsulta;

    if (idConsulta != null) {
      mapa['idConsulta'] = _idConsulta;
    }

    return mapa;
  }

  Consulta.fromMap(Map<String, dynamic> mapa) {
    this._idConsulta = mapa['idConsulta'];
    this._medico = mapa['medico'];
    this._especialidade = mapa['especialidade'];
    this._consultorio = mapa['consultorio'];
    this._fkconsulta = mapa['fkconsulta'];
  }

  String toString() {
    return "{ idConsulta=$idConsulta, medico=$medico," +
        "especialidade=$especialidade, consultorio=$consultorio, fkconsulta=$fkconsulta }";
  }
}
