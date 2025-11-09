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
    this.motivacoes = const [],
    this.impeditivos = const [],
    this.sono,
    this.telaAntesDormir,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'idade': idade,
      'respostas': toList(), // lista ordenada
      'takenAt': Timestamp.now(),
    };
  }

  List<Map<String, dynamic>> toList() {
    return [
      {'pergunta': 'Nome', 'resposta': nome},
      {'pergunta': 'Idade', 'resposta': idade},
      {'pergunta': 'Estresse', 'resposta': estresse},
      {'pergunta': 'Ansiedade', 'resposta': ansiedade},
      {'pergunta': 'Sobrecarga', 'resposta': sobrecarga},
      {'pergunta': 'Refeições', 'resposta': refeicoes},
      {
        'pergunta': 'Frutas',
        'resposta': frutas,
      }, // pode converter em string se quiser
      {'pergunta': 'Água', 'resposta': agua},
      {'pergunta': 'Ultraprocessados', 'resposta': ultraprocessados},
      {'pergunta': 'Suplementos', 'resposta': suplementos},
      {'pergunta': 'Frequência de Atividade Física', 'resposta': atividadeFreq},
      {'pergunta': 'Duração da Atividade', 'resposta': duracao},
      {'pergunta': 'Motivações', 'resposta': motivacoes.join(', ')},
      {'pergunta': 'Impeditivos', 'resposta': impeditivos.join(', ')},
      {'pergunta': 'Sono', 'resposta': sono},
      {'pergunta': 'Tela Antes de Dormir', 'resposta': telaAntesDormir},
    ];
  }
}
