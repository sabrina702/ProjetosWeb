import 'package:flutter/material.dart';
import 'package:myapp/data/models/formularioData.dart';
import 'package:myapp/presentation/pages/formulario/PageFormularioFinal.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageFormulario2 extends StatefulWidget {
  final FormularioData formularioData;
  const PageFormulario2({super.key, required this.formularioData});

  @override
  State<PageFormulario2> createState() => _PageFormulario2State();
}

class _PageFormulario2State extends State<PageFormulario2> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Campos do formulário
  String? estresse;
  String? ansiedade;
  String? sobrecarga;
  String? refeicoes;
  double frutas = 0;
  String? agua;
  String? ultraprocessados;
  String? suplementos;
  String? atividadeFreq;
  String? duracao;
  List<String> motivacoes = [];
  List<String> impeditivos = [];
  String? sono;
  String? telaAntesDormir;

  final List<String> escalaLikert = [
    'Nunca',
    'Raramente',
    'Às vezes',
    'Frequentemente',
    'Sempre',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Função para salvar dados no Firebase
  Future<void> saveFormToFirebase(FormularioData data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('formularioRespostas')
        .add(data.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PerfilDrawer(),
      appBar: AppBar(
        title: const Text('Formulário - Parte 2'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 6,
          radius: const Radius.circular(10),
          interactive: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧠 Saúde Mental
                  const Text(
                    '🧠 Saúde Mental e Emocional',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 1 - Estresse
                  const Text(
                    '1. Como você avaliaria o seu nível de estresse nos últimos 7 dias?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  ...['Baixo', 'Moderado', 'Alto', 'Muito alto']
                      .map(
                        (opcao) => RadioListTile(
                          title: Text(opcao),
                          value: opcao,
                          groupValue: estresse,
                          onChanged: (value) =>
                              setState(() => estresse = value),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),

                  // Pergunta 2 - Ansiedade
                  const Text(
                    '2. Com que frequência você tem se sentido ansioso(a), nervoso(a) ou tenso(a)?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma opção',
                    ),
                    value: ansiedade,
                    items: escalaLikert
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => ansiedade = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 3 - Sobrecarga
                  const Text(
                    '3. Com que frequência você se sente sobrecarregado(a) pelas suas responsabilidades?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma opção',
                    ),
                    value: sobrecarga,
                    items: escalaLikert
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => sobrecarga = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 20),

                  // 🍎 Hábitos Alimentares
                  const Text(
                    '🍎 Hábitos Alimentares',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 4 - Refeições
                  const Text(
                    '4. Quantas refeições completas você costuma fazer por dia?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              '1 refeição',
                              '2 refeições',
                              '3 refeições',
                              '4 ou mais refeições',
                            ]
                            .map(
                              (opcao) => RadioListTile(
                                title: Text(opcao),
                                value: opcao,
                                groupValue: refeicoes,
                                onChanged: (value) =>
                                    setState(() => refeicoes = value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 5 - Frutas
                  const Text(
                    '5. Com que frequência você consome frutas frescas durante o dia?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Slider(
                    value: frutas,
                    min: 0,
                    max: 4,
                    divisions: 4,
                    label: [
                      'Nunca',
                      '1 a 2 vezes por semana',
                      '3 a 4 vezes por semana',
                      '1 vez por dia',
                      '2 ou mais vezes por dia',
                    ][frutas.toInt()],
                    onChanged: (value) => setState(() => frutas = value),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 6 - Água
                  const Text(
                    '6. Quantos copos de água, em média, você consome por dia?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Menos de 4 copos (menos de 1 litro)',
                              'De 4 a 6 copos (1 a 1,5 litro)',
                              'De 7 a 9 copos (1,5 a 2 litros)',
                              '10 copos ou mais (acima de 2 litros)',
                            ]
                            .map(
                              (opcao) => RadioListTile(
                                title: Text(opcao),
                                value: opcao,
                                groupValue: agua,
                                onChanged: (value) =>
                                    setState(() => agua = value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 7 - Ultraprocessados
                  const Text(
                    '7. Com que frequência você consome alimentos ultraprocessados (refrigerantes, fast food, doces)?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma opção',
                    ),
                    value: ultraprocessados,
                    items:
                        [
                              'Nunca',
                              'Raramente',
                              'Às vezes',
                              'Frequentemente',
                              'Todos os dias',
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) =>
                        setState(() => ultraprocessados = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 8 - Suplementos
                  const Text(
                    '8. Você utiliza algum tipo de suplemento alimentar (vitaminas, proteínas, colágeno, etc.)?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Sim, uso regularmente',
                              'Sim, mas apenas ocasionalmente',
                              'Não uso suplementos',
                            ]
                            .map(
                              (opcao) => RadioListTile(
                                title: Text(opcao),
                                value: opcao,
                                groupValue: suplementos,
                                onChanged: (value) =>
                                    setState(() => suplementos = value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 20),

                  // 🏃‍♀️ Atividade Física
                  const Text(
                    '🏃‍♀️ Atividade Física',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 9
                  const Text(
                    '9. Com que frequência você pratica algum tipo de atividade física?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma opção',
                    ),
                    value: atividadeFreq,
                    items:
                        [
                              'Todos os dias',
                              '3 a 5 vezes por semana',
                              '1 a 2 vezes por semana',
                              'Raramente',
                              'Nunca',
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => atividadeFreq = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 10
                  const Text(
                    '10. Quando pratica atividade física, qual é o tempo médio de duração de cada sessão?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Menos de 30 minutos',
                              'De 30 a 60 minutos',
                              'De 1 a 2 horas',
                              'Mais de 2 horas',
                            ]
                            .map(
                              (opcao) => RadioListTile(
                                title: Text(opcao),
                                value: opcao,
                                groupValue: duracao,
                                onChanged: (value) =>
                                    setState(() => duracao = value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 11 - Motivações
                  const Text(
                    '11. Quais são suas principais motivações para praticar atividade física?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Manter a saúde',
                              'Melhorar o humor e reduzir o estresse',
                              'Questões estéticas (melhorar aparência, emagrecer, ganhar massa)',
                              'Lazer ou diversão',
                              'Indicação médica',
                              'Conviver com outras pessoas',
                              'Outros (especificar)',
                            ]
                            .map(
                              (opcao) => CheckboxListTile(
                                title: Text(opcao),
                                value: motivacoes.contains(opcao),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      motivacoes.add(opcao);
                                    } else {
                                      motivacoes.remove(opcao);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 12 - Impeditivos
                  const Text(
                    '12. O que mais te impede de praticar atividade física com frequência?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Falta de tempo',
                              'Falta de motivação',
                              'Cansaço físico ou mental',
                              'Falta de local adequado',
                              'Questões financeiras',
                              'Lesão ou problema de saúde',
                              'Nada me impede',
                            ]
                            .map(
                              (opcao) => CheckboxListTile(
                                title: Text(opcao),
                                value: impeditivos.contains(opcao),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      impeditivos.add(opcao);
                                    } else {
                                      impeditivos.remove(opcao);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 20),

                  // 😴 Sono e Descanso
                  const Text(
                    '😴 Sono e Descanso',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 13
                  const Text(
                    '13. Quantas horas de sono você costuma ter por noite, em média?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Column(
                    children:
                        [
                              'Menos de 5 horas',
                              'De 5 a 6 horas',
                              'De 7 a 8 horas',
                              'Mais de 8 horas',
                            ]
                            .map(
                              (opcao) => RadioListTile(
                                title: Text(opcao),
                                value: opcao,
                                groupValue: sono,
                                onChanged: (value) =>
                                    setState(() => sono = value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 14
                  const Text(
                    '14. Você costuma usar celular, computador ou assistir TV antes de dormir?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecione uma opção',
                    ),
                    value: telaAntesDormir,
                    items: escalaLikert
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => telaAntesDormir = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 30),

                  // Botão Enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Atualiza todos os campos no objeto
                          widget.formularioData.estresse = estresse;
                          widget.formularioData.ansiedade = ansiedade;
                          widget.formularioData.sobrecarga = sobrecarga;
                          widget.formularioData.refeicoes = refeicoes;
                          widget.formularioData.frutas = frutas;
                          widget.formularioData.agua = agua;
                          widget.formularioData.ultraprocessados =
                              ultraprocessados;
                          widget.formularioData.suplementos = suplementos;
                          widget.formularioData.atividadeFreq = atividadeFreq;
                          widget.formularioData.duracao = duracao;
                          widget.formularioData.motivacoes = motivacoes;
                          widget.formularioData.impeditivos = impeditivos;
                          widget.formularioData.sono = sono;
                          widget.formularioData.telaAntesDormir =
                              telaAntesDormir;

                          // Salva no Firebase
                          await saveFormToFirebase(widget.formularioData);

                          // Vai para página final
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PageFormularioFinal(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
