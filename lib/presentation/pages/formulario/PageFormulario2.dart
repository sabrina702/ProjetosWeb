import 'package:flutter/material.dart';
import 'package:myapp/theme/colors.dart';

class PageFormulario2 extends StatefulWidget {
  const PageFormulario2({super.key});

  @override
  State<PageFormulario2> createState() => _PageFormulario2State();
}

class _PageFormulario2State extends State<PageFormulario2> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController(); // 🔹 controlador da rolagem

  // Respostas zeradas
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
    'Sempre'
  ];

  @override
  void dispose() {
    _scrollController.dispose(); // 🔹 liberar o controlador quando sair da tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Formulário - Parte 2'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar( // 🔹 adiciona a barrinha lateral de rolagem
          controller: _scrollController,
          thumbVisibility: true, // 🔹 deixa visível enquanto rola
          thickness: 6, // 🔹 define a espessura da barra
          radius: const Radius.circular(10), // 🔹 cantos arredondados
          interactive: true, // 🔹 permite arrastar a barra
          child: SingleChildScrollView(
            controller: _scrollController, // 🔹 conecta o ScrollController
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🧠 Saúde Mental e Emocional',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 1
                  const Text(
                    '1. Como você avaliaria o seu nível de estresse nos últimos 7 dias?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  ...['Baixo', 'Moderado', 'Alto', 'Muito alto']
                      .map((opcao) => RadioListTile(
                            title: Text(opcao),
                            value: opcao,
                            groupValue: estresse,
                            onChanged: (value) =>
                                setState(() => estresse = value),
                          ))
                      .toList(),
                  const SizedBox(height: 10),

                  // Pergunta 2
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
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => ansiedade = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 3
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
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => sobrecarga = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    '🍎 Hábitos Alimentares',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 4
                  const Text(
                    '4. Quantas refeições completas (café, almoço, jantar) você costuma fazer por dia?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      '1 refeição',
                      '2 refeições',
                      '3 refeições',
                      '4 ou mais refeições'
                    ]
                        .map((opcao) => RadioListTile(
                              title: Text(opcao),
                              value: opcao,
                              groupValue: refeicoes,
                              onChanged: (value) =>
                                  setState(() => refeicoes = value),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Pergunta 7 (ultraprocessados)
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
                    items: [
                      'Nunca',
                      'Raramente',
                      'Às vezes',
                      'Frequentemente',
                      'Todos os dias'
                    ]
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => ultraprocessados = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma opção' : null,
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Botão Enviar igual ao da PageFormulario1
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Formulário enviado com sucesso!'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Enviar',
                        style:
                            TextStyle(fontSize: 18, color: Colors.white),
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
