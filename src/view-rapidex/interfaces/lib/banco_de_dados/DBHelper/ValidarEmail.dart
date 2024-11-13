bool validar_email(String email) {
  // Validação simples de e-mail
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
      .hasMatch(email);
}
