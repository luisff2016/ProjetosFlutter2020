import 'dart:core';

class Registro {
  // atributos
  String _prontuario;
  String _cpf;
  String _nome;
  int _idRegistro;

 Registro(this._prontuario, this._cpf, this._nome);

  Registro.map(dynamic obj) {
    this._idRegistro = obj['idRegistro'];
    this._prontuario = obj['prontuario'];
    this._cpf = obj['cpf'];
    this._nome = obj['nome'];
  }
// metodos get
  String get prontuario => _prontuario;
  String get cpf => _cpf;
  String get nome => _nome;
  int get idRegistro => _idRegistro;

  Map<String, dynamic> toMap() {
    
    var mapa = new Map<String, dynamic>();

    mapa['prontuario'] = _prontuario;
    
    mapa['cpf'] = _cpf;
    
    mapa['nome'] = _nome;

    if (idRegistro != null) {
    
      mapa['idRegistro'] = _idRegistro;
    
    }

    return mapa;
  
  }

  Registro.fromMap(Map<String, dynamic> mapa) {
  
    this._idRegistro = mapa['idRegistro'];
  
    this._prontuario = mapa['prontuario'];
  
    this._cpf = mapa['cpf'];
  
    this._nome = mapa['nome'];
  
  }

  String toString() {
  
    return "{ idRegistro=$idRegistro, prontuario=$prontuario, cpf=$cpf, nome=$nome }";
  
  }

}