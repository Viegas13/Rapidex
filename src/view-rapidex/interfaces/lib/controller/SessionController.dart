class SessionController {
  static final SessionController instancia = SessionController._internal();

  String? _email;
  String? _senha;

  SessionController._internal();

  factory SessionController() {
    return instancia;
  }

  void setSession(String emailNovo, String senhaNova) {
    _email = emailNovo;
    _senha = senhaNova;
  }

  String? get email => _email;
  String? get senha => _senha;

  void limparSession() {
    _email = null;
    _senha = null;
  }
}
