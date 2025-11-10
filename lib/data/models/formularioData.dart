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
      {'pergunta': 'nome', 'resposta': nome},
      {'pergunta': 'idade', 'resposta': idade},
      {'pergunta': 'estresse', 'resposta': estresse ?? 'Não respondido'},
      {'pergunta': 'ansiedade', 'resposta': ansiedade ?? 'Não respondido'},
      {'pergunta': 'sobrecarga', 'resposta': sobrecarga ?? 'Não respondido'},
      {'pergunta': 'refeicoes', 'resposta': refeicoes ?? 'Não respondido'},
      {'pergunta': 'frutas', 'resposta': frutas},
      {'pergunta': 'agua', 'resposta': agua ?? 'Não respondido'},
      {
        'pergunta': 'ultraprocessados',
        'resposta': ultraprocessados ?? 'Não respondido',
      },
      {'pergunta': 'suplementos', 'resposta': suplementos ?? 'Não respondido'},
      {
        'pergunta': 'atividadeFreq',
        'resposta': atividadeFreq ?? 'Não respondido',
      },
      {'pergunta': 'duracao', 'resposta': duracao ?? 'Não respondido'},
      {'pergunta': 'motivacoes', 'resposta': motivacoes.join(', ')},
      {'pergunta': 'impeditivos', 'resposta': impeditivos.join(', ')},
      {'pergunta': 'sono', 'resposta': sono ?? 'Não respondido'},
      {
        'pergunta': 'telaAntesDormir',
        'resposta': telaAntesDormir ?? 'Não respondido',
      },
    ];
  }
}
