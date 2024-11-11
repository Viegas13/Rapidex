bool verifica_cpf(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica se o CPF tem 11 dígitos
  if (cpf.length != 11) return false;

  // Não permite CPFs com todos os números iguais (ex: 111.111.111-11)
  if (RegExp(r'(\d)\1{10}').hasMatch(cpf)) return false;

  // Cálculo do primeiro dígito verificador
  int sum1 = 0;
  for (int i = 0; i < 9; i++) {
    sum1 += int.parse(cpf[i]) * (10 - i);
  }
  int digit1 = (sum1 % 11 < 2) ? 0 : 11 - (sum1 % 11);

  // Cálculo do segundo dígito verificador
  int sum2 = 0;
  for (int i = 0; i < 9; i++) {
    sum2 += int.parse(cpf[i]) * (11 - i);
  }
  int digit2 = (sum2 % 11 < 2) ? 0 : 11 - (sum2 % 11);

  // Verifica se os dígitos verificadores calculados são iguais aos informados
  return cpf[9] == digit1.toString() && cpf[10] == digit2.toString();
}