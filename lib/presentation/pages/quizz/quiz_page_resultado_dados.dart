import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/theme/colors.dart';

class QuizResultsPage extends StatelessWidget {
  const QuizResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        drawer: const PerfilDrawer(),
        appBar: AppBar(title: const Text('Resultados do Quiz')),
        body: const Center(child: Text('Usuário não está logado')),
      );
    }

    // Subcoleção onde os resultados do quiz do usuário estão salvos
    final CollectionReference userQuizCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('QuizzResultado');

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados do Quiz')),
      body: StreamBuilder<QuerySnapshot>(
        stream: userQuizCollection.snapshots(),
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
              final data = doc.data() as Map<String, dynamic>;

              // Pegando os dados do quiz
              final pontuacao = data['score'] ?? 0;
              final totalPerguntas = data['totalQuestions'] ?? 0;
              final respostas = data['answers'] as List<dynamic>? ?? [];
              final Timestamp? dataRespostaTimestamp =
                  data['takenAt'] as Timestamp?;
              final dataFormatada = dataRespostaTimestamp != null
                  ? DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(dataRespostaTimestamp.toDate())
                  : 'Data não disponível';

              // Montando lista de widgets para exibir as respostas
              final List<Widget> quizWidgets = [
                Text(
                  'Pontuação: $pontuacao / $totalPerguntas',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Respondido em: $dataFormatada',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
              ];

              for (int i = 0; i < respostas.length; i++) {
                quizWidgets.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      'Pergunta ${i + 1}: ${respostas[i]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: quizWidgets,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Builder(
        builder: (context) => BottomNavigationBar(
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ),
    );
  }
}
