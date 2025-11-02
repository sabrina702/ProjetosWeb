class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'Qual destas opções é considerada um hábito saudável?',
    options: [
      'Fumar socialmente',
      'Praticar atividade física regularmente',
      'Dormir menos de 5 horas por noite',
      'Comer fast food todos os dias',
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Qual é a quantidade ideal de sono para um adulto?',
    options: [
      '4 horas',
      'Entre 7 e 9 horas por noite',
      'Mais de 12 horas',
      'Não dormir à noite e cochilar de dia',
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Beber água regularmente contribui para:',
    options: [
      'Ganho de peso',
      'Problemas digestivos',
      'Melhor funcionamento do corpo',
      'Insônia',
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'O que é considerado uma alimentação balanceada?',
    options: [
      'Comer só salada',
      'Comer carne em todas as refeições',
      'Comer frutas, legumes, proteínas e grãos variados',
      'Comer doces para obter energia',
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Qual das opções ajuda a melhorar a saúde mental?',
    options: [
      'Evitar todas as pessoas',
      'Meditação e autocuidado',
      'Trabalhar sem descanso',
      'Dormir o dia inteiro',
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Qual é o principal benefício da atividade física?',
    options: [
      'Ajuda a gastar dinheiro',
      'Aumenta o estresse',
      'Melhora o condicionamento físico e a saúde mental',
      'Causa cansaço constante',
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'O que é qualidade de vida?',
    options: [
      'Ter muito dinheiro',
      'Bem-estar físico, mental e social',
      'Trabalhar sem parar',
      'Comer o que quiser sem limites',
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Qual profissional deve ser procurado para acompanhamento da saúde mental?',
    options: [
      'Personal trainer',
      'Nutricionista',
      'Clínico geral',
      'Psicólogo ou psiquiatra',
    ],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: 'Qual das seguintes ações previne doenças crônicas?',
    options: [
      'Manter uma alimentação saudável e fazer exercícios',
      'Comer muito açúcar',
      'Ficar sentado o dia todo',
      'Evitar frutas e legumes',
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'Tomar sol moderadamente ajuda em quê?',
    options: [
      'Provoca câncer de pele',
      'Produção de vitamina D',
      'Aumenta o colesterol',
      'Causa insônia',
    ],
    correctAnswerIndex: 1,
  ),
];