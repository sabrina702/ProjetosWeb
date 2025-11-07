import 'package:cloud_firestore/cloud_firestore.dart';

class FormularioData {
  String nome;
  String idade;
  String? estresse;
  String? ansiedade;
  String? sobrecarga;
  String? refeicoes;
  double frutas;
  String? agua;
  String? ultraprocessados;
  String? suplementos;
  String? atividadeFreq;
  String? duracao;
  List<String> motivacoes;
  List<String> impeditivos;
  String? sono;
  String? telaAntesDormir;

  FormularioData({
    required this.nome,
    required this.idade,
    this.estresse,
    this.ansiedade,
    this.sobrecarga,
    this.refeicoes,
    this.frutas = 0,
    this.agua,
    this.ultraprocessados,
    this.suplementos,
    this.atividadeFreq,
    this.duracao,
    List<String>? motivacoes,
    List<String>? impeditivos,
    this.sono,
    this.telaAntesDormir,
  }) : motivacoes = motivacoes ?? [],
       impeditivos = impeditivos ?? [];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'idade': idade,
      'estresse': estresse,
      'ansiedade': ansiedade,
      'sobrecarga': sobrecarga,
      'refeicoes': refeicoes,
      'frutas': frutas,
      'agua': agua,
      'ultraprocessados': ultraprocessados,
      'suplementos': suplementos,
      'atividadeFreq': atividadeFreq,
      'duracao': duracao,
      'motivacoes': motivacoes,
      'impeditivos': impeditivos,
      'sono': sono,
      'telaAntesDormir': telaAntesDormir,
      'takenAt': FieldValue.serverTimestamp(),
    };
  }
}
