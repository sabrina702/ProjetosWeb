class UserModel {
  String id;
  String nome;
  String email;
  String senha;
  String tipoUsuario;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipoUsuario,
  });

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipoUsuario': tipoUsuario,
    };
  }

  // Converter de Map (para ler do Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      tipoUsuario: map['tipoUsuario'] ?? 'Aluno',
    );
  }
}
