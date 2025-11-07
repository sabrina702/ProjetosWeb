import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/theme/colors.dart';
import 'package:intl/intl.dart';

class PageFormularioResultado extends StatelessWidget {
  const PageFormularioResultado({super.key});

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
        .collection('formularioRespostas'); // deve bater com o save

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

              // Pega a data do envio, se tiver
              final Timestamp? dataTimestamp = data['takenAt'] as Timestamp?;
              final formattedDate = dataTimestamp != null
                  ? DateFormat(
                      'dd/MM/yyyy – HH:mm',
                    ).format(dataTimestamp.toDate())
                  : 'Data não informada';

              // Cria a lista de respostas detalhadas
              final List<Widget> detalhes = [];
              data.forEach((key, value) {
                if (key != 'takenAt') {
                  // Mostra listas como texto separado por vírgula
                  if (value is List) {
                    detalhes.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '$key: ${value.join(', ')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  } else {
                    detalhes.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '$key: $value',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                }
              });

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text('Resposta ${index + 1} – $formattedDate'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detalhes,
                      ),
                    ),
                  ],
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
