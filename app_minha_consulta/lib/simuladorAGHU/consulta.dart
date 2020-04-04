import 'dart:convert';

class Consulta {
  String medico;
  String especialidade;
  String dataConsulta;
  String horaConsulta;
  String predio;
  String sala;
  String tipoConsulta;
  String status;
  int fkConsulta;
  int idConsulta;

  Consulta({
    this.medico,
    this.especialidade,
    this.dataConsulta,
    this.horaConsulta,
    this.predio,
    this.sala,
    this.tipoConsulta,
    this.status,
    this.fkConsulta,
    this.idConsulta,
  });

  Consulta copyWith({
    String medico,
    String especialidade,
    String dataConsulta,
    String horaConsulta,
    String predio,
    String sala,
    String tipoConsulta,
    String status,
    int fkConsulta,
    int idConsulta,
  }) {
    return Consulta(
      medico: medico ?? this.medico,
      especialidade: especialidade ?? this.especialidade,
      dataConsulta: dataConsulta ?? this.dataConsulta,
      horaConsulta: horaConsulta ?? this.horaConsulta,
      predio: predio ?? this.predio,
      sala: sala ?? this.sala,
      tipoConsulta: tipoConsulta ?? this.tipoConsulta,
      status: status ?? this.status,
      fkConsulta: fkConsulta ?? this.fkConsulta,
      idConsulta: idConsulta ?? this.idConsulta,
    );
  }

  Consulta.map(dynamic obj) {
    this.medico = obj['medico'];
    this.especialidade = obj['especialidade'];
    this.dataConsulta = obj['dataConsulta'];
    this.horaConsulta = obj['horaConsulta'];
    this.predio = obj['predio'];
    this.sala = obj['sala'];
    this.tipoConsulta = obj['tipoConsulta'];
    this.status = obj['status'];
    this.fkConsulta = obj['fkConsulta'];
    this.idConsulta = obj['idConsulta'];
    
  }

  Map<String, dynamic> toMap() {
    return {
      'medico': medico,
      'especialidade': especialidade,
      'dataConsulta': dataConsulta,
      'horaConsulta': horaConsulta,
      'predio': predio,
      'sala': sala,
      'tipoConsulta': tipoConsulta,
      'status': status,
      'fkConsulta': fkConsulta,
      'idConsulta': idConsulta,
    };
  }

  static Consulta fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Consulta(
      medico: map['medico'],
      especialidade: map['especialidade'],
      dataConsulta: map['dataConsulta'],
      horaConsulta: map['horaConsulta'],
      predio: map['predio'],
      sala: map['sala'],
      tipoConsulta: map['tipoConsulta'],
      status: map['status'],
      fkConsulta: map['fkConsulta'],
      idConsulta: map['idConsulta'],
    );
  }

  String toJson() => json.encode(toMap());

  static Consulta fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Consulta(medico: $medico, especialidade: $especialidade, dataConsulta: $dataConsulta, horaConsulta: $horaConsulta, predio: $predio, sala: $sala, tipoConsulta: $tipoConsulta, status: $status, fkConsulta: $fkConsulta, idConsulta: $idConsulta)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Consulta &&
        o.medico == medico &&
        o.especialidade == especialidade &&
        o.dataConsulta == dataConsulta &&
        o.horaConsulta == horaConsulta &&
        o.predio == predio &&
        o.sala == sala &&
        o.tipoConsulta == tipoConsulta &&
        o.status == status &&
        o.fkConsulta == fkConsulta &&
        o.idConsulta == idConsulta;
  }

  @override
  int get hashCode {
    return medico.hashCode ^
        especialidade.hashCode ^
        dataConsulta.hashCode ^
        horaConsulta.hashCode ^
        predio.hashCode ^
        sala.hashCode ^
        tipoConsulta.hashCode ^
        status.hashCode ^
        fkConsulta.hashCode ^
        idConsulta.hashCode;
  }
}
