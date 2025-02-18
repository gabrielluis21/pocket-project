class Validations {
  static String? validarNome(String? value) {
    String pattern = r"(^[a-zA-Z ]*$)";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  static String? validarAddress(String? value) {
    String pattern = r"[A-Za-z0-9'\.\-\s\,]";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Informe o endereço";
    } else if (!regExp.hasMatch(value)) {
      return "O enderço deve conter caracteres de a-z ou A-Z e numeros";
    }
    return null;
  }

  static String? validarEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Informe o E-mail";
    } else if (!regExp.hasMatch(value)) {
      return "E-mail inválido";
    } else {
      return null;
    }
  }

  static String? validarSenha(String? value) {
    if (value!.isEmpty) {
      return "Informe a senha";
    } else if (value.length <= 6) {
      return "Digite uma senha com no mínimo 6 caracteres";
    } else if (value.length > 8) {
      return "Digite uma senha com no máximo 8 caracteres";
    } else {
      return null;
    }
  }

  static String? validarTelefone(String? value) {
    String pattern =
        r'^\s*(\d{2}|\d{0})[-. ]?(\d{5}|\d{4})[-. ]?(\d{4})[-. ]?\s*$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Informe o seu numero de telefone";
    } else if (!regExp.hasMatch(value)) {
      return "Número de telofone inválido";
    }
    return null;
  }
}
