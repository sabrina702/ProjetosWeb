import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/presentation/widgets/custom_bottom_nav.dart';
import 'package:intl/intl.dart';

class PageFormularioResultado extends StatelessWidget {
  const PageFormularioResultado({super.key});

  Map<String, String> get perguntas => {
    "estresse":
        "1. Em geral, como você avaliaria o seu nível de estresse nos últimos 7 dias?",
    "ansiedade":
        "2. Com que frequência você tem se sentido ansioso(a), nervoso(a) ou tenso(a)?",
    "sobrecarga":
        "3. Com que frequência você se sente sobrecarregado(a) pelas suas responsabilidades diárias?",
    "refeicoes":
        "4. Quantas refeições completas (café da manhã, almoço, jantar) você costuma fazer por dia?",
    "frutas":
        "5. Com que frequência você consome frutas frescas durante o dia?",
    "agua": "6. Quantos copos de água, em média, você consome por dia?",
    "ultraprocessados":
        "7. Com que frequência você consome alimentos ultraprocessados (refrigerantes, fast food, salgadinhos, doces)?",
    "suplementos":
        "8. Você utiliza algum tipo de suplemento alimentar (vitaminas, proteínas, colágeno, etc.)?",
    "atividadeFreq":
        "9. Com que frequência você pratica algum tipo de atividade física?",
    "duracao":
        "10. Quando pratica atividade física, qual é o tempo médio de duração de cada sessão?",
    "motivacoes":
        "11. Quais são suas principais motivações para praticar atividade física?",
    "impeditivos":
        "12. O que mais te impede de praticar atividade física com frequência?",
    "sono": "13. Quantas horas de sono você costuma ter por noite, em média?",
    "telaAntesDormir":
        "14. Você costuma usar celular, computador ou assistir TV antes de dormir?",
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        drawer: const PerfilDrawer(),
        appBar: AppBar(title: const Text('Resultados do Formulário')),
        body: const Center(child: Text('Usuário não está logado')),
      );
    }

    final CollectionReference userFormCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('formularioRespostas');

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados do Formulário')),
      body: StreamBuilder<QuerySnapshot>(
        stream: userFormCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar resultados: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum resultado encontrado'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final Map<String, dynamic> data =
                  doc.data() as Map<String, dynamic>;

              final Timestamp? dataTimestamp = data['takenAt'] as Timestamp?;
              final formattedDate = dataTimestamp != null
                  ? DateFormat(
                      'dd/MM/yyyy – HH:mm',
                    ).format(dataTimestamp.toDate())
                  : 'Data não informada';

              final List<Widget> respostas = [];

              data.forEach((key, value) {
                if (key != 'takenAt') {
                  // Se o campo está no mapa, usa o texto completo
                  final textoPergunta = perguntas[key] ?? key;

                  respostas.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textoPergunta,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Resposta: ${value is List ? value.join(", ") : value}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              });

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ExpansionTile(
                  title: Text(
                    'Resposta ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Enviado em: $formattedDate',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: respostas,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
