import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/presentation/widgets/custom_bottom_nav.dart';

class PageFormularioResultado extends StatelessWidget {
  const PageFormularioResultado({super.key});

  // Perguntas na ordem correta, com a mesma string usada no FormularioData.toList()
  final Map<String, String> perguntas = const {
    "nome": "Nome",
    "idade": "Idade",
    "estresse": "Estresse",
    "ansiedade": "Ansiedade",
    "sobrecarga": "Sobrecarga",
    "refeicoes": "Refeições",
    "frutas": "Frutas",
    "agua": "Água",
    "ultraprocessados": "Ultraprocessados",
    "suplementos": "Suplementos",
    "atividadeFreq": "Frequência de Atividade Física",
    "duracao": "Duração da Atividade",
    "motivacoes": "Motivações",
    "impeditivos": "Impeditivos",
    "sono": "Sono",
    "telaAntesDormir": "Tela Antes de Dormir",
  };

  // Função para pegar a resposta correta dentro do array 'respostas'
  String getResposta(Map<String, dynamic> data, String key) {
    if (key == 'nome' || key == 'idade') {
      return data[key]?.toString() ?? 'Não respondido';
    }

    if (data['respostas'] != null) {
      final List respostasList = data['respostas'];
      for (var r in respostasList) {
        if (r['pergunta'] == perguntas[key]) {
          return r['resposta']?.toString() ?? 'Não respondido';
        }
      }
    }

    return 'Não respondido';
  }

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

    final userFormCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('formularioRespostas');

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados do Formulário')),
      body: StreamBuilder<QuerySnapshot>(
        stream: userFormCollection
            .orderBy('takenAt', descending: true)
            .snapshots(),
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

              final Timestamp? timestamp = data['takenAt'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateFormat('dd/MM/yyyy – HH:mm').format(timestamp.toDate())
                  : 'Data não informada';

              final List<Widget> respostasWidgets = perguntas.keys.map((key) {
                final resposta = getResposta(data, key);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        perguntas[key]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Resposta: $resposta',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList();

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
                        children: respostasWidgets,
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
